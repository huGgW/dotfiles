# ZPLUG
if [ -d /opt/homebrew/opt/zplug ]; then
    export ZPLUG_HOME=/opt/homebrew/opt/zplug
    source $ZPLUG_HOME/init.zsh
elif [ -d /usr/share/zsh/scripts/zplug ]; then
	source /usr/share/zsh/scripts/zplug/init.zsh
	export ZPLUG_HOME=~/.zplug
elif [ -d ~/.zplug ]; then
	export ZPLUG_HOME=~/.zplug
	source $ZPLUG_HOME/init.zsh
fi

zplug "zsh-users/zsh-autosuggestions"
zplug "zdharma-continuum/fast-syntax-highlighting"
zplug "caarlos0/zsh-git-sync"
zplug "Aloxaf/fzf-tab"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    if is_interactive; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    else
        # Non-interactive: skip install to avoid blocking
        echo "zplug: skipping install in non-interactive mode"
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# starship
eval "$(starship init zsh)"
