#!/usr/bin/env bash
set -e

here="$(dirname "$0")"
here="$(cd "$here"; pwd)"

font_dir="$HOME/.fonts"

remove-symlinks () {
    for file in "$here"/"$1"*; do
        name="$(basename "$file")"
        if [[ !( " install.bash uninstall.bash oh-my-zsh-custom readme.md " =~ " $name " ) ]]; then
            rm -rv "$HOME/.$1$name"
        fi
    done
}

remove-fonts() {
    if [[ ! -d "$font_dir" ]]; then
        echo "No powerline fonts installed on your system. Uninstall not needed."
    else
        echo "Removing fonts..."
        find "$powerline_fonts_dir" \( -name "$prefix*.[ot]tf" -or -name "$prefix*.pcf.gz" \) -type f -print0 | xargs -n1 -0 -I % sh -c "rm -f \"\$0/\${1##*/}\"" "$font_dir" %
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