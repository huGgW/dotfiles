# logo
neofetch

# Initialize zplug
source /usr/share/zsh/scripts/zplug/init.zsh

zplug romkatv/powerlevel10k, as:theme, depth:1

zplug zsh-users/zsh-autosuggestions

zplug agkozak/zsh-z

zplug zsh-users/zsh-syntax-highlighting

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


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

# Set ls color (fix the odd color in wsl)
LS_COLORS="ow=01;36;40" && export LS_COLORS

# opam configuration
test -r ~/.opam/opam-init/init.zsh && . ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# iterm2 configuration for mac
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# miniconda3 activate
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# for amd MKL performance hack
export MKL_DEBUG_CPU_TYPE=5

# for flatpak appclication environment
export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:/home/whjoon0225/.local/share/flatpak/exports/share

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
