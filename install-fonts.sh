#!/bin/sh
sudo apt install -y fontconfig

download-meslo-fonts() {
    wget -P $HOME/powerline-font-temp https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    wget -P $HOME/powerline-font-temp https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    wget -P $HOME/powerline-font-temp https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    wget -P $HOME/powerline-font-temp https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
}

install-powerline-fonts() {
    if [[ ! -d "$HOME/.fonts" ]]; then
        echo "Creating ~/.fonts"
        mkdir "$HOME/.fonts"
    fi

    if which fc-cache; then
        echo 'Installing powerline-patched-font'
       
        # download powerline fonts
        git clone https://github.com/powerline/fonts $HOME/powerline-font-temp
        
        # need these for powerlevel10k theme
        download-meslo-fonts

        find $HOME/powerline-font-temp -regextype posix-extended -iregex '.*\.(otf|ttf)' -print0 | xargs -0 -I % mv -v % $HOME/.fonts/
        rm -rfv $HOME/powerline-font-temp
        fc-cache -vf $HOME/.fonts/
    fi
}