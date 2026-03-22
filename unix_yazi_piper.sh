#!/bin/bash

set -euo pipefail

if ! command -v ya >/dev/null 2>&1; then
    echo "Error: 'ya' command not found. Install yazi first."
    exit 1
fi

if ya pkg list | grep -Eq '(^|/)piper(\s|$)'; then
    echo "piper.yazi is already installed."
    exit 0
fi

ya pkg add yazi-rs/plugins:piper
echo "Installed piper.yazi"
