#!/usr/bin/env bash
set -e

sudo apt update

printf "\033[1;31;49m=== Installing necessary packages \n\033[0m"
sudo apt -y install zsh tmux vim aptitude git curl wget
sudo apt -y install debhelper autotools-dev dh-autoreconf file
sudo apt -y install libncurses5-dev libevent-dev pkg-config libutempter-dev build-essential

printf "\033[1;32;49m=== Type Y/y to install/update python3: \033[0m"
read -n 1 c; echo ''
if [[ $c == 'Y' ]] || [[ $c == 'y' ]]; then
    sudo apt -y install python3 python3-venv python3-dev python3-pip
fi

source ./install-fonts.sh && install-powerline-fonts
source ./install-ohmyzsh.sh && install-ohmyzsh

printf "\033[1;32;49m=== Type Y/y to install/update fzf: \033[0m"
read -n 1 c; echo ''
if [[ $c == 'Y' ]] || [[ $c == 'y' ]]; then
    if [[ ! -d "$HOME/.fzf" ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    else
        (cd ~/.fzf; git pull origin master)
    fi
    ~/.fzf/install --all --no-update-rc
fi

printf "\033[1;32;49m=== Change default text editor \033[0m"
sudo update-alternatives --config editor

while [[ x${git_global_name} == 'x' ]]; do
    read -rp "gitconfig global name: " git_global_name
done
while [[ x${git_global_email} == 'x' ]]; do
    read -rp "gitconfig global email: " git_global_email
done

cat <<EOF > $HOME/.gitconfigp
[user]
	name = ${git_global_name}
	email = ${git_global_email}
[core]
	excludesfile = $HOME/.gitignore
EOF