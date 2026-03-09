# ==========================================================
# Synopsys Environment Variables (Corrected)
# ==========================================================

# 1. VCS (Version O-2018.09-SP2)
export VCS_HOME=/home/tbin/synopsys/vcs_2016.06/vcs/O-2018.09-SP2
export PATH=$PATH:$VCS_HOME/bin
# DVE
export PATH=$PATH:$VCS_HOME/gui/dve/bin

# 2. Verdi (Version O-2018.09-SP2)
export VERDI_HOME=/home/tbin/synopsys/verdi_2016.06-1/verdi/Verdi_O-2018.09-SP2
export NOVAS_HOME=$VERDI_HOME
export PATH=$PATH:$VERDI_HOME/bin

# 3. SCL (Synopsys Common Licensing - Version 2018.06)
export PATH=$PATH:/home/tbin/synopsys/scl_11.9/scl/2018.06/linux64/bin

# 4. LICENSE
export LM_LICENSE_FILE=27000@DESKTOP-PRI0FN9
export SNPSLMD_LICENSE_FILE=27000@DESKTOP-PRI0FN9

# 5. Others
export VCS_ARCH_OVERRIDE=linux
alias vcs="vcs -full64"
alias verdi="verdi -full64"
alias dve="dve -full64"

# ==========================================================
# Auto-License Setup: Dummy Interface & Hosts Mapping
# ==========================================================
LICENSE_MAC="00:15:5d:f7:c2:2f"
LICENSE_IP="192.168.50.50"
HOSTNAME=$(hostname)

# 1. 设置虚拟网卡 (eth1)
if ! ip link show eth1 >/dev/null 2>&1; then
    sudo ip link add eth1 type dummy
    sudo ip link set dev eth1 address $LICENSE_MAC
    sudo ip addr add $LICENSE_IP/24 dev eth1
    sudo ip link set eth1 up
    echo "🔧 Created dummy interface eth1 ($LICENSE_IP) with MAC $LICENSE_MAC"
fi

# 2. 注入 Hosts 映射 (关键步骤!)
# 检查 hosts 文件里是否已经指向了我们的虚拟 IP
if ! grep -q "$LICENSE_IP.*$HOSTNAME" /etc/hosts; then
    echo "🔧 Updating /etc/hosts to map $HOSTNAME -> $LICENSE_IP..."
    # 删除旧的解析 (如果有)
    sudo sed -i "/$HOSTNAME/d" /etc/hosts
    # 添加新的解析
    echo "$LICENSE_IP $HOSTNAME" | sudo tee -a /etc/hosts >/dev/null
    echo "✅ Hosts updated."
fi
# ==========================================================
export LD_PRELOAD=~/lmfakemac.so
