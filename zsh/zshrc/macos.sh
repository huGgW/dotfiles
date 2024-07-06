# >>> Initialize zplug >>>
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh
# <<< Initialize zplug <<<

# >>> homebrew >>>
if [[ "$(arch)" = "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else # x86_64
    eval "$(/usr/local/bin/brew shellenv)"
fi

export FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
# <<< homebrew <<<

# >>> iterm2 >>>
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
# <<< iterm2 <<<
