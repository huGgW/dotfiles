### ZINIT
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Load plugins

zinit light "zsh-users/zsh-autosuggestions"
zinit light "zsh-users/zsh-history-substring-search"
zinit light "zsh-users/zsh-completions"
zinit light "zdharma-continuum/fast-syntax-highlighting"
zinit light "caarlos0/zsh-git-sync"
zinit light "Aloxaf/fzf-tab"

zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

### _ZINIT
