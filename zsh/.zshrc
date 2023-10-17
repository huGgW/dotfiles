# Initialize brew on mac
if [[ `uname` == "Darwin" ]] then
	if [[ "$(arch)" = "arm64" ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	else # x86_64
		eval "$(/usr/local/bin/brew shellenv)"
	fi
	export FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
fi

# logo
if [[ fastfetch ]] then
	fastfetch
fi

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

# Start starship
eval "$(starship init zsh)"

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
export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias sudo="sudo "
alias vim="nvim"
alias where="pwd"
alias ls="exa --icons"
alias gfs="git fetch && git status"
alias grep="rg"
if [[ `uname` == "Darwin" ]]; then
	alias cat="bat --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo OneHalfDark || echo OneHalfLight)"
else
	alias cat="bat"
fi

# alias for enable & disable sleep in systemctl linux
if [[ `uname` != "Darwin" ]]; then
	alias sleep_status="systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target"
	alias sleep_disable="systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target"
	alias sleep_enable="systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target"
fi

# fuck initialization
eval $(thefuck --alias)

# Set ls color (fix the odd color in wsl)
LS_COLORS="ow=01;36;40" && export LS_COLORS

# Bat theme
export BAT_THEME="gruvbox-dark"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if [[ `uname` == "Darwin" ]]; then # When execute on macos
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
if [[ `uname` != "Darwin" ]] then
	export MKL_DEBUG_CPU_TYPE=5
fi

# ROCm override
# alias for docker rocm
if [[ `uname` != "Darwin" ]] then
	alias drun='sudo docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -e HSA_OVERRIDE_GFX_VERSION=10.3.0'
	export HSA_OVERRIDE_GFX_VERSION=10.3.0
	export AMDGPU_TARGETS="gfx1030"
fi

# Mac specific
# iterm2 configuration for mac
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# openjdk env
if [[ `uname` == "Darwin" ]]; then
	export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi

##########################################temp###################################################
# berkely db envs
export PATH="/opt/homebrew/opt/berkeley-db/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/berkeley-db/lib"
export CPPFLAGS="-I/opt/homebrew/opt/berkeley-db/include"
export BERKELEYDB_DIR="/opt/homebrew/opt/berkeley-db"
