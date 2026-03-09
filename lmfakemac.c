#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/if.h>
#include <dlfcn.h>
#include <ifaddrs.h>
#include <netpacket/packet.h>

/* Target MAC: 00:15:5d:f7:c2:2f */
unsigned char fake_mac[] = {0x00, 0x15, 0x5d, 0xf7, 0xc2, 0x2f};

/* 1. Intercept getifaddrs */
int getifaddrs(struct ifaddrs **ifap)
{
    static int (*real_getifaddrs)(struct ifaddrs **) = NULL;
    if (!real_getifaddrs)
        real_getifaddrs = dlsym(RTLD_NEXT, "getifaddrs");
    if (!real_getifaddrs)
        return -1;

    int ret = real_getifaddrs(ifap);

    if (ret == 0 && *ifap)
    {
        struct ifaddrs *ifa = *ifap;
        while (ifa)
        {
            if (ifa->ifa_addr && ifa->ifa_addr->sa_family == AF_PACKET)
            {
                struct sockaddr_ll *sll = (struct sockaddr_ll *)ifa->ifa_addr;
                if (sll->sll_halen == 6)
                {
                    memcpy(sll->sll_addr, fake_mac, 6);
                }
            }
            ifa = ifa->ifa_next;
        }
    }
    return ret;
}

/* 2. Intercept ioctl */
typedef int (*ioctl_t)(int, unsigned long, ...);

int ioctl(int d, unsigned long request, ...)
{
    void *arg;
    va_list ap;
    va_start(ap, request);
    arg = va_arg(ap, void *);
    va_end(ap);

    static ioctl_t real_ioctl = NULL;
    if (!real_ioctl)
        real_ioctl = (ioctl_t)dlsym(RTLD_NEXT, "ioctl");

    int ret = real_ioctl(d, request, arg);

    if ((request == SIOCGIFHWADDR || request == 0x8927) && ret == 0)
    {
        struct ifreq *ifr = (struct ifreq *)arg;
        memcpy(ifr->ifr_hwaddr.sa_data, fake_mac, 6);
    }

    return ret;
}
