#!/bin/sh

font_dir="$HOME/.fonts"
temp="$here/font-temp-140695"

download-meslo-fonts() {
    wget -P "$temp" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    wget -P "$temp" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    wget -P "$temp" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    wget -P "$temp" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
}

install-powerline-fonts() {
    echo "Cleaning existing fonts..."
    mkdir -p "$font_dir"
    rm -rfv "$font_dir/*"

    if which fc-cache; then
        echo 'Installing powerline-patched-font...'
       
        # clear existing temp            
        rm -rf "$temp"

        # download powerline fonts
        git clone --depth 1 https://github.com/powerline/fonts "$temp"
        
        # need these for powerlevel10k theme
        download-meslo-fonts

        find "$temp" -regextype posix-extended -iregex '.*\.(otf|ttf)' -print0 | xargs -0 -I % mv -v % "$font_dir"
        rm -rf "$temp"
        fc-cache -vf "$font_dir"
    fi
}