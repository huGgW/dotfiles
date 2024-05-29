# >>> homebrew (mac) >>>
if [[ `uname` == "Darwin" ]] then
	if [[ "$(arch)" = "arm64" ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	else # x86_64
		eval "$(/usr/local/bin/brew shellenv)"
	fi
	export FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
fi
# <<< homebrew (mac) <<<

# >>> logo >>>
if [[ fastfetch ]] then
	fastfetch
fi
# <<< logo <<<

# >>> ZPLUG >>>
# Initialize zplug
if [[ `uname` == "Darwin" ]]; then
	export ZPLUG_HOME=/opt/homebrew/opt/zplug
	source $ZPLUG_HOME/init.zsh
else
	source /usr/share/zsh/scripts/zplug/init.zsh
fi

zplug "zsh-users/zsh-autosuggestions"
zplug "zdharma-continuum/fast-syntax-highlighting"
zplug "conda-incubator/conda-zsh-completion"
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
# <<< ZPLUG <<<

# >>> starship >>>
eval "$(starship init zsh)"
# <<< starship <<<

# >>> enable zsh history >>>
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
# <<< enable zsh history <<<

# >>> PATH >>>
export PATH="$HOME/.local/bin:$PATH"
# Jetbrains Path
export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"
# ruby gem PATH
export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"
# mojo path
export MODULAR_HOME="$HOME/.modular"
export PATH="$HOME/.modular/pkg/packages.modular.com_mojo/bin:$PATH"
# <<< PATH <<<

# >>> Alias >>>
alias sudo="sudo "
alias vim="nvim"
alias where="pwd"
alias ls="eza --icons"
alias gfs="git fetch && git status"
alias grep="rg"
if [[ `uname` == "Darwin" ]]; then
	alias cat="bat --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo OneHalfDark || echo OneHalfLight)"
else
	alias cat="bat"
fi

# <<< Alias <<<

# >>> thefuck >>>
eval $(thefuck --alias)
# <<< thefuck <<<

# >>> fzf >>>
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# <<< fzf <<<

# Set ls color (fix the odd color in wsl)
LS_COLORS="ow=01;36;40" && export LS_COLORS

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
else # when execute on linux
    [ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
    export TERMINFO=/usr/share/terminfo
fi
# <<< conda initialize <<<

# >>> zoxide (z) configs >>>
# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    \builtin pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    # shellcheck disable=SC2164
    \builtin cd -- "$@"
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
function __zoxide_hook() {
    # shellcheck disable=SC2312
    \command zoxide add -- "$(__zoxide_pwd)"
}

# Initialize hook.
# shellcheck disable=SC2154
if [[ ${precmd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]] && [[ ${chpwd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]]; then
    chpwd_functions+=(__zoxide_hook)
fi

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

__zoxide_z_prefix='z#'

# Jump to a directory using only keywords.
function __zoxide_z() {
    # shellcheck disable=SC2199
    if [[ "$#" -eq 0 ]]; then
        __zoxide_cd ~
    elif [[ "$#" -eq 1 ]] && { [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]; }; then
        __zoxide_cd "$1"
    elif [[ "$@[-1]" == "${__zoxide_z_prefix}"?* ]]; then
        # shellcheck disable=SC2124
        \builtin local result="${@[-1]}"
        __zoxide_cd "${result:${#__zoxide_z_prefix}}"
    else
        \builtin local result
        # shellcheck disable=SC2312
        result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" &&
            __zoxide_cd "${result}"
    fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
    \builtin local result
    result="$(\command zoxide query --interactive -- "$@")" && __zoxide_cd "${result}"
}

# Completions.
if [[ -o zle ]]; then
    function __zoxide_z_complete() {
        # Only show completions when the cursor is at the end of the line.
        # shellcheck disable=SC2154
        [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

        if [[ "${#words[@]}" -eq 2 ]]; then
            _files -/
        elif [[ "${words[-1]}" == '' ]] && [[ "${words[-2]}" != "${__zoxide_z_prefix}"?* ]]; then
            \builtin local result
            # shellcheck disable=SC2086,SC2312
            if result="$(\command zoxide query --exclude "$(__zoxide_pwd)" --interactive -- ${words[2,-1]})"; then
                result="${__zoxide_z_prefix}${result}"
                # shellcheck disable=SC2296
                compadd -Q "${(q-)result}"
            fi
            \builtin printf '\e[5n'
        fi
        return 0
    }

    \builtin bindkey '\e[0n' 'reset-prompt'
    [[ "${+functions[compdef]}" -ne 0 ]] && \compdef __zoxide_z_complete __zoxide_z
fi

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

\builtin alias z=__zoxide_z
\builtin alias zi=__zoxide_zi

# <<< zoxide (z) configs <<<


# >>> Linux Specific >>>

# for amd MKL performance hack
if [[ `uname` != "Darwin" ]] then
	export MKL_DEBUG_CPU_TYPE=5
fi

# >>> ROCM docker >>>
# alias for docker rocm
if [[ `uname` != "Darwin" ]] then
	alias drun='sudo docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -e HSA_OVERRIDE_GFX_VERSION=10.3.0'
	export HSA_OVERRIDE_GFX_VERSION=10.3.0
	export AMDGPU_TARGETS="gfx1030"
fi
# <<< ROCM docker <<<

# alias for enable & disable sleep in systemctl linux
if [[ `uname` != "Darwin" ]]; then
	alias sleep_status="systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target"
	alias sleep_disable="systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target"
	alias sleep_enable="systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target"
fi
# <<< Linux Specific <<<

# >>> Mac specific >>>
# iterm2 configuration for mac
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# <<< Mac specific <<<
