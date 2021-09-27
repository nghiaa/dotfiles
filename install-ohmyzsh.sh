#!/usr/bin/env bash
set -e

install-ohmyzsh() {
    printf "\033[1;33;49mCreating symlinks in $HOME:\n\033[0m"
    for file in "$here"/*; do
        name="$(basename "$file")"
        if [[ !( $ignored_things =~ " $name " ) ]]; then
            ln -sfv $file "$HOME/.$name"
        fi
    done

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        find "$here/oh-my-zsh-custom" -maxdepth 1 -mindepth 1 -type f -print0 | xargs -0 -L 1 -I % ln -sfv % "$HOME/.oh-my-zsh/custom/"
        find "$here/oh-my-zsh-custom/themes" -maxdepth 1 -mindepth 1 -print0 | xargs -0 -L 1 -I % ln -sfv % "$HOME/.oh-my-zsh/custom/themes/"
        find "$here/oh-my-zsh-custom/plugins/" -maxdepth 1 -mindepth 1 -print0 | xargs -0 -L 1 -I % ln -sfv % "$HOME/.oh-my-zsh/custom/plugins/"
    fi

    printf "\033[1;32;49m=== Type Y/y to change default shell to zsh: \033[0m"
    read -n 1 c; echo '';
    if [[ !( " y Y " =~ " $c " ) ]]; then
        return
    fi
    zsh_dir="$(which zsh)"
    if chsh -s "$zsh_dir"; then
        echo "Default shell has been changed successfully to $zsh_dir"
    else
        echo "Unexpected error while trying to change default shell!"
    fi
}

install-ohmyzsh