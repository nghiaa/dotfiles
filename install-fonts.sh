#!/usr/bin/env bash
set -e

temp="$here/font-temp-140695"

download-meslo-fonts() {
    wget -P "$temp" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    wget -P "$temp" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    wget -P "$temp" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    wget -P "$temp" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
}

install-powerline-fonts() {
    printf "\033[1;33;49mInstalling powerline-patched-font...\n\033[0m"
    
    echo "Cleaning existing fonts..."
    mkdir -p "$font_dir"
    rm -rfv "$font_dir/*"

    if ! which fc-cache; then
        echo "No fc-cache found, abort!"
        return
    fi

    # clear existing temp            
    rm -rf "$temp"

    # download powerline fonts
    git clone --depth 1 https://github.com/powerline/fonts "$temp"
    
    # need these for powerlevel10k theme
    download-meslo-fonts

    find "$temp" -regextype posix-extended -iregex '.*\.(otf|ttf)' -print0 | xargs -0 -I % mv -v % "$font_dir"
    rm -rf "$temp"
    fc-cache -vf "$font_dir"

    echo "Powerline fonts have been installed successfully!"
}

install-powerline-fonts