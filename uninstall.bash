#!/usr/bin/env bash
set -e

font_dir="$HOME/.fonts"
things2avoid=" install.bash uninstall.bash install-fonts.sh install-ohmyzsh.sh oh-my-zsh-custom README.md "

# workaround to run this script at any directory
here="$( cd "$( dirname "$0" )" && pwd )"

remove-symlinks () {
    printf "\033[1;31;49m=== Removing symlinks in $HOME:\n\033[0m"
    for file in "$here"/*; do
        name="$(basename "$file")"
        if [[ !( things2avoid =~ " $name " ) ]]; then
            rm -rv "$HOME/.$name"
        fi
    done
}

remove-fonts() {
    if [[ ! -d "$font_dir" ]]; then
        echo "No powerline fonts installed on your system. Uninstall not needed."
    else
        echo "Removing fonts..."
        rm -rfv "$font_dir"
    fi

    # Reset font cache
    if which fc-cache >/dev/null 2>&1 ; then
        echo "Resetting font cache..."
        fc-cache -f "$font_dir"
    fi

    echo "Powerline fonts uninstalled from $font_dir"
}

remove-symlinks ''
remove-fonts