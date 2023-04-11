# Initialize brew on mac
eval "$(/opt/homebrew/bin/brew shellenv)"

# logo
neofetch

# Initialize zplug
if [[ `uname` == "Darwin" ]]; then
	export ZPLUG_HOME=/opt/homebrew/opt/zplug
	source $ZPLUG_HOME/init.zsh
else
	source /usr/share/zsh/scripts/zplug/init.zsh
fi

zplug "zsh-users/zsh-autosuggestions"

zplug "agkozak/zsh-z"

zplug "zdharma-continuum/fast-syntax-highlighting"

zplug "conda-incubator/conda-zsh-completion"

zplug 'wfxr/forgit'

zplug "caarlos0/zsh-git-sync"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# Save zsh history to ~/.zsh_history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# PATH
export PATH="$HOME/.local/bin:$PATH"
# Jetbrains Path
export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"
# ruby gem PATH
export PATH="/home/whjoon0225/.local/share/gem/ruby/3.0.0/bin:$PATH"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias sudo="sudo "
alias vim="nvim"
alias where="pwd"
alias cat="bat"
alias ls="exa --icons"
# alias python="python3"
alias gfs="git fetch && git status"

# alias for enable & disable sleep
alias sleep_status="systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target"
alias sleep_disable="systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target"
alias sleep_enable="systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target"

# alias for docker rocm
alias drun='sudo docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -e HSA_OVERRIDE_GFX_VERSION=10.3.0'

# fuck initialization
eval $(thefuck --alias)

# Set ls color (fix the odd color in wsl)
LS_COLORS="ow=01;36;40" && export LS_COLORS

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if [[ `uname` == "Darwin" ]]; then
	__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
	if [ $? -eq 0 ]; then
		eval "$__conda_setup"
	else
		if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
			. "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
		else
			export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
		fi
	fi
	unset __conda_setup
else
	[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
fi
# <<< conda initialize <<<

# for amd MKL performance hack
export MKL_DEBUG_CPU_TYPE=5

# opam configuration
test -r ~/.opam/opam-init/init.zsh && . ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# ROCm override
export HSA_OVERRIDE_GFX_VERSION=10.3.0
export AMDGPU_TARGETS="gfx1030"

# Ryzen Controller
test -e "/opt/Ryzen Controller/ryzen-controller" && export PATH="/opt/Ryzen Controller:$PATH"

# added by travis gem
[ ! -s /home/whjoon0225/.travis/travis.sh ] || source /home/whjoon0225/.travis/travis.sh

# Start starship
eval "$(starship init zsh)"

# Mac specific
# iterm2 configuration for mac
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# openjdk env
if [[ `uname` == "Darwin" ]]; then
	export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi
