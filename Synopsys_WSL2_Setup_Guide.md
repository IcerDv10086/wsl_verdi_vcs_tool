# Synopsys EDA (VCS/Verdi 2018) on WSL2 (Ubuntu 24.04) 完整部署指南

> 参考自虚拟机安装：<https://blog.csdn.net/huayangshiboqi/article/details/89525723>，目的是基于windows安装vcs 和 verdi，方便本地做一些小想法的测试。使用WSL遇到最主要的问题是第4个，MAC地址随机造成 license 失效。本文使用一种方式进行解决。

## 1. 资源准备与获取

为了方便环境复现，所有安装文件与配置文件库已分离存储。

### 1.1 核心安装包 (夸克网盘)

请从夸克网盘下载以下安装包(设置为永久有效)：
链接：<https://pan.quark.cn/s/c65d54c05d50>
提取码：S7Qn

### 1.2 配置文件库 (GitHub)

配置文件、启动脚本及补丁代码托管于 GitHub：
> <https://github.com/IcerDv10086/wsl_verdi_vcs_tool>

你需要下载或关注的文件：

- `.bashrc_synopsys`: 完整的环境变量配置模板。
- `lmfakemac.c`: 针对 WSL2 的 MAC 地址伪造源码。
- `lmfakemac.so`: 编译结果文件

---

## 2. 系统基础环境配置 (Ubuntu 24.04)

WSL2 (Ubuntu 24.04) 默认缺少 EDA 软件所需的旧版库和图形库，需手动补全。

### 2.1 替换 Shell (必须)

Ubuntu 默认 sh 为 dash，Verdi 启动脚本需要 bash 才能正确解析数组语法。

```bash
sudo rm -rf /bin/sh
sudo ln -s /bin/bash /bin/sh
```

### 2.2 安装基础依赖

```bash
sudo apt update
sudo apt install -y build-essential vim git csh lsb-release \
    libxt6 libxtst6 libxi6 libxrender1 libxrandr2 \
    libglib2.0-0 libxmu6 libxpm4 libnuma1
```

### 2.3 手动安装 libpng12 (Ubuntu 24.04 特有)

Ubuntu 24.04 官方源已移除 libpng12，必须手动解压安装。

```bash
# 1. 下载 deb 包
wget http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb

# 2. 解压并提取库文件
mkdir libpng_temp
dpkg -x libpng12-0_1.2.54-1ubuntu1.1_amd64.deb libpng_temp

# 3. 复制到系统库目录
sudo cp libpng_temp/lib/x86_64-linux-gnu/libpng12.so.0.54.0 /usr/lib/x86_64-linux-gnu/

# 4. 建立软链接
sudo ln -sf /usr/lib/x86_64-linux-gnu/libpng12.so.0.54.0 /usr/lib/x86_64-linux-gnu/libpng12.so.0

# 5. 刷新缓存并清理
sudo ldconfig
rm -rf libpng_temp *.deb
```

## 3. 软件安装与解压

参考对应目录链接

## 4. license适配与伪造MAC地址

WSL2 的 MAC 地址随机变化且无法固定，导致 License 校验失败。我们通过 LD_PRELOAD 劫持系统调用来解决。

### 4.1 伪造库（lmfakemac.c）与编译

1. 编译文件：lmfakemac.c，编译到用户目录下，或者直接将编译结果：lmfakemac.so，放置在home/用户/目录下
2. source .bashrc 启动劫持系统调用

### 4.2 激活

执行前执行：killall -9 lmgrd snpslmd
执行后: /home/tbin/synopsys/scl_11.9/scl/2018.06/linux64/bin/lmgrd -c $SYNOPSYS_HOME/license/Synopsys.dat -l $SYNOPSYS_HOME/license/license.log

## 5. 补充的注意事项

verdi 默认为sh，需要修改成bash！！！
