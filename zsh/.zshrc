# logo
neofetch

# Initialize zplug
source /usr/share/zsh/scripts/zplug/init.zsh

zplug "zsh-users/zsh-autosuggestions"

zplug "agkozak/zsh-z"

zplug "zdharma/fast-syntax-highlighting"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load


# PATH
export PATH="$HOME/.local/bin:$PATH"
# Jetbrains Path
export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias sudo="sudo "
alias vim="nvim"
alias where="pwd"
alias cat="bat"
alias ls="lsd"
# alias python="python3"
alias gfs="git fetch && git status"

# alias for docker rocm
alias drun='sudo docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v $HOME/dockerx:/dockerx -e HSA_OVERRIDE_GFX_VERSION=10.3.0'

# fuck initialization
eval $(thefuck --alias)

# Set ls color (fix the odd color in wsl)
LS_COLORS="ow=01;36;40" && export LS_COLORS

# miniconda3 activate
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# for amd MKL performance hack
export MKL_DEBUG_CPU_TYPE=5

# opam configuration
test -r ~/.opam/opam-init/init.zsh && . ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# iterm2 configuration for mac
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# ROCm override
export HSA_OVERRIDE_GFX_VERSION=10.3.0
export AMDGPU_TARGETS="gfx1030"

# Ryzen Controller
test -e "/opt/Ryzen Controller/ryzen-controller" && export PATH="/opt/Ryzen Controller:$PATH"

# Start starship
eval "$(starship init zsh)"
