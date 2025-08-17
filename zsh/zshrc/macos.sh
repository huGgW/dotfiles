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

# >>> rust >>>
if [ -d "/opt/homebrew/opt/rustup/bin" ]; then
    export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
fi
# <<< rust <<<
