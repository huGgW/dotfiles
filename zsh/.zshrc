# uncomment if want to profile
# zmodload zsh/zprof

# Load utils
source ~/zshrc/utils.sh

# Operating System Specific Configs
if [[ `uname` == "Darwin" ]]; then
    safe_source ~/zshrc/macos.sh
else
    safe_source ~/zshrc/linux.sh
fi

# Load modules in order
safe_source ~/zshrc/core.sh
safe_source ~/zshrc/plugins.sh
safe_source ~/zshrc/tools.sh

# Device Specific Configs
safe_source ~/zshrc/device.sh

# Finish
safe_source ~/zshrc/finish.sh

# uncomment if want to profile
# zprof
