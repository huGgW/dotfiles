#!/bin/bash

OS=`uname`
StowOnHome="stow -v --target $HOME"

stow_common() {
    $StowOnHome \
        ghostty \
        ideavim \
        nvim \
        starship \
        tmux \
        zsh \
        claudecode
}

stow_macos() {
    $StowOnHome \
        aerospace \
        hammerspoon
}

stow_linux() {
    $StowOnHome \
        hypr \
        waybar \
        xremap
}

# stow
echo "stow common configs..."
stow_common
if [ "$OS" = "Darwin" ]; then
    echo "stow macos configs..."
    stow_macos
elif [ "$OS" = "Linux" ]; then
    echo "stow linux configs..."
    stow_linux
else
    echo "unknown os: $OS"
fi

