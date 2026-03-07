
# if flag given, load profiling module
if [[ "$ZSH_PROFILE_ENABLE" == "true" || "$ZSH_PROFILE_ENABLE" == "1" ]]; then
    zmodload zsh/zprof
fi

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

# if flag given, do profiling
if [[ "$ZSH_PROFILE_ENABLE" == "true" || "$ZSH_PROFILE_ENABLE" == "1" ]]; then
    zprof
fi

