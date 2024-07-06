# >>> Operating System Specific Configs >>>
if [[ `uname` == "Darwin" ]]; then
    source ~/zshrc/macos.sh
else
    source ~/zshrc/linux.sh
fi
# <<< Operating System Specific Configs <<<

# >>> ZPLUG >>>
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
# <<< PATH <<<

# >>> Alias >>>
alias sudo="sudo "
alias vim="nvim"
alias where="pwd"
alias ls="eza --icons"
alias gfs="git fetch && git status"
alias grep="rg"
# bat
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

# >>> Docker autocomplete >>>
if [[ docker ]]; then
    source <(docker completion zsh)
fi
# <<< Docker autocomplete <<<

# >>> Device Specific Configs >>>
if [[ -f ~/zshrc/device.sh ]]; then
    source ~/zshrc/device.sh
fi
# <<< Device Specific Configs <<<

# >>> logo >>>
if [[ fastfetch ]]; then
	fastfetch
fi
# <<< logo <<<

# >>> auto complete load >>>
autoload -Uz compinit
compinit
# <<< auto complete load <<<
