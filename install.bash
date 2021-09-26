#!/usr/bin/env bash
set -e

sudo apt update

printf "\033[1;33;49m=== Installing necessary packages \n\033[0m"
# terminal & editor
sudo apt -y install zsh tmux vim fontconfig

# utilities
sudo apt -y install git curl wget tar zip unzip keychain
sudo apt -y install gdebi-core aptitude manpages manpages-dev file

# dev packages
sudo apt -y install libutempter-dev debhelper autotools-dev dh-autoreconf
sudo apt -y install libncurses5-dev libevent-dev pkg-config bison build-essential

printf "\033[1;33;49m=== Installing python3 and packages: \033[0m"
sudo apt -y install python3 python3-venv python3-dev python3-pip
sudo pip3 install --system wheel
sudo pip3 install --system powerline-status

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

printf "\033[1;32;49m=== Configure git \n\033[0m"

# git config
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

# create a file to store your ssh keys for auto loading
echo "Create my-ssh-keys.sh"

cat <<EOF > $HOME/.my-ssh-keys.sh
# put your ssh keys here to automatically load them
# keys must be placed at default location: $HOME/.ssh/
ssh_keys=(
    # your_key
)
EOF

chmod 744 $HOME/.my-ssh-keys.sh