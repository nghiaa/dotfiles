#!/usr/bin/env bash
set -e

install () {
    if which tmux; then
        return
    fi

    printf "\033[1;32;49m=== Type Y/y to install tmux: \033[0m"
    read -n 1 c; echo '';
    if [[ !( " y Y " =~ " $c " ) ]]; then
        return
    fi

    (echo "Compiling tmux..."; \
    cd "$tmux_dir"; \
    make >/dev/null 2>&1; \
    echo "Copying binaries..."; \
    sudo make install; \
    echo "tmux installed successfully!")
}

install