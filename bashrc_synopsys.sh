# ==========================================================
# Synopsys Environment Variables (Template)
# ==========================================================

# 使用说明：
# 1) 本文件已移除机器相关的路径和主机配置，请按你自己的环境填写。
# 2) 将下面的 <...> 占位符替换为真实路径/主机名后再 source。

# 1. VCS (示例版本：O-2018.09-SP2)
# 请填写你本机 VCS 安装路径
export VCS_HOME=<YOUR_VCS_HOME_PATH>
export PATH=$PATH:$VCS_HOME/bin
# DVE
export PATH=$PATH:$VCS_HOME/gui/dve/bin

# 2. Verdi (示例版本：O-2018.09-SP2)
# 请填写你本机 Verdi 安装路径
export VERDI_HOME=<YOUR_VERDI_HOME_PATH>
export NOVAS_HOME=$VERDI_HOME
export PATH=$PATH:$VERDI_HOME/bin

# 3. SCL (示例版本：2018.06)
# 请填写你本机 SCL 可执行文件目录
export SCL_BIN=<YOUR_SCL_BIN_PATH>
export PATH=$PATH:$SCL_BIN

# 4. LICENSE
# 请填写你的 license server，例如：27000@your-hostname
export LM_LICENSE_FILE=<YOUR_LICENSE_SERVER>
export SNPSLMD_LICENSE_FILE=<YOUR_LICENSE_SERVER>

# 5. 其他推荐项
export VCS_ARCH_OVERRIDE=linux
alias vcs="vcs -full64"
alias verdi="verdi -full64"
alias dve="dve -full64"

# 6. LD_PRELOAD (可选)
# 若使用 lmfakemac.so 方案，请确认文件路径正确
export LD_PRELOAD=$HOME/lmfakemac.so
