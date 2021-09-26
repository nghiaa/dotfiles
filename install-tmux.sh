#!/bin/sh

tmux_dir="$here/tmux"

install () {
    printf "\033[1;33;49m=== Installing tmux \033[0m"
    git clone https://github.com/tmux/tmux.git "$tmux_dir"

    echo "Preparing..."
    cd "$tmux_dir"
    sh autogen.sh

    echo "compiling tmux..."
    ./configure >/dev/null 2>&1
    make >/dev/null 2>&1

    echo "copying binaries..."
    sudo make install
    make clean
    
    echo "tmux installed successfully!"
    cd "$here"
}