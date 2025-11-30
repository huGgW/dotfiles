# PATH
export PATH="$HOME/.local/bin:$PATH"

# Jetbrains Path
export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"

# Claude code path
export PATH="$HOME/.claude/local:$PATH"

# EDITOR
export EDITOR="nvim"

# Set ls color (fix the odd color in wsl)
LS_COLORS="ow=01;36;40" && export LS_COLORS

# enable zsh history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Alias
alias sudo="sudo "
alias vim="nvim"
alias where="pwd"
alias ls="eza --icons"
alias k="kubectl"
alias lg="lazygit"

# bat
alias cat="bat --theme=ansi"

# auto complete load
autoload -Uz compinit
compinit
