#!/usr/bin/env bash
set -e

install () {
    printf "\033[1;32;49m=== Type Y/y to install tmux: \033[0m"
    read -n 1 c; echo '';
    if [[ !( " y Y " =~ " $c " ) ]]; then
        return
    fi

    echo "Installing tmux..."
    git clone https://github.com/tmux/tmux.git "$tmux_dir"

    echo "Compiling tmux..."
    cd "$tmux_dir"
    make >/dev/null 2>&1

    echo "Copying binaries..."
    sudo make install
    
    echo "tmux installed successfully!"
    cd "$here"
}

install