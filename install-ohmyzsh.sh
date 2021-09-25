#!/bin/sh

# workaround to run this script at any directory
here="$(dirname "$0")"
here="$(cd "$here"; pwd)"

(cd $here; git submodule init)
(cd $here; git submodule update)

things2Ignore=" install.bash uninstall.bash install-fonts.sh install-ohmyzsh.sh oh-my-zsh-custom README.md "

install-ohmyzsh() {
    printf "\033[1;33;49m=== Creating symlinks in $HOME:\n\033[0m"
    for file in "$here"/*; do
        name="$(basename "$file")"
        if [[ !( $things2Ignore =~ " $name " ) ]]; then
            ln -sfv $file "$HOME/.$name"
            echo "-> $HOME/.$name"
        fi
    done

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        find "$here/oh-my-zsh-custom" -maxdepth 1 -mindepth 1 -type f -print0 | xargs -0 -L 1 -I % ln -sfv % "$HOME/.oh-my-zsh/custom/"
        find "$here/oh-my-zsh-custom/themes" -maxdepth 1 -mindepth 1 -print0 | xargs -0 -L 1 -I % ln -sfv % "$HOME/.oh-my-zsh/custom/themes/"
        find "$here/oh-my-zsh-custom/plugins/" -maxdepth 1 -mindepth 1 -print0 | xargs -0 -L 1 -I % ln -sfv % "$HOME/.oh-my-zsh/custom/plugins/"
    fi

    printf "\033[1;32;49m=== Type Y/y to change default shell to zsh: \033[0m"
    read -n 1 c; echo '';
    if [[ $c == 'Y' ]] || [[ $c == 'y' ]]; then
        chsh -s `which zsh`
    fi
}