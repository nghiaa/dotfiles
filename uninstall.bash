#!/usr/bin/env bash
set -e

source ./initialize.sh

uninstall_fzf() {
    printf "\033[1;31;49m=== Do you want to uninstall fzf (Y/y)? \033[0m"
    read -n 1 c; echo ''
    if [[ !( " y Y " =~ " $c " ) ]]; then
        return
    fi
    
    if [[ -d "$fzf_dir" ]]; then
        if [[ -e "$fzf_dir/uninstall" ]]; then
            # execute uninstall script
            "$fzf_dir/uninstall"
        fi
        rm -rf "$fzf_dir"
    fi
}

remove-symlinks () {
    printf "\033[1;31;49mRemoving symlinks in $HOME:\n\033[0m"
    for file in "$here"/*; do
        name="$(basename "$file")"
        if [[ !( $ignored_things =~ " $name " ) ]]; then
            rm -rfv "$HOME/.$name"
        fi
    done
}

remove-fonts() {
    if [[ ! -d "$font_dir" ]]; then
        echo "No powerline fonts installed on your system. Uninstall not needed."
    else
        echo "Removing fonts..."
        rm -rf "$font_dir"
    fi

    # Reset font cache
    if which fc-cache >/dev/null 2>&1 ; then
        echo "Resetting font cache..."
        fc-cache -f "$font_dir"
    fi

    echo "Powerline fonts uninstalled from $font_dir"
}

uninstall_fzf
remove-symlinks
remove-fonts