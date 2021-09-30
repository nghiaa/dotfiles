#!/usr/bin/env bash
set -e

source ./initialize.sh

sudo apt update

printf "\033[1;33;49mInstalling necessary packages...\n\033[0m"
# terminal & editor
sudo apt -y install zsh vim fontconfig

# utilities
sudo apt -y install git curl wget tar zip unzip keychain \
                    gdebi-core aptitude manpages manpages-dev file

# dev packages
sudo apt -y install mysql-client build-essential automake autoconf \
                    autotools-dev dh-autoreconf libutempter-dev debhelper \
                    libncurses5-dev libevent-dev bison pkg-config

printf "\033[1;33;49mInstalling python3 and packages...\n\033[0m"
sudo apt -y install python3 python3-venv python3-dev python3-pip
sudo pip3 install --system wheel
sudo pip3 install --system powerline-status

source ./install-fonts.sh
source ./install-ohmyzsh.sh
source ./install-tmux.sh

printf "\033[1;33;49mConfigure Vim\n\033[0m"
if [[ ! -d "$HOME/.vimbackup" ]]; then
    echo "Creating ~/.vimbackup"
    mkdir -p "$HOME/.vimbackup"
fi
vim +'PlugInstall --sync' +qa

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

printf "\033[1;32;49m=== Configure Git \n\033[0m"
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
if [[ -f "$HOME/.my-ssh-keys.sh" ]]; then
    echo "$HOME/.my-ssh-keys.sh existed!"
    exit
fi

cat <<EOF > $HOME/.my-ssh-keys.sh
# put your ssh keys here to automatically load them
# keys must be placed at default location: $HOME/.ssh/
ssh_keys=(
    # your_key
)
EOF

chmod 760 $HOME/.my-ssh-keys.sh
echo "Create $HOME/.my-ssh-keys.sh successfully!"