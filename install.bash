#!/usr/bin/env bash
set -e

here="$(dirname "$0")"
here="$(cd "$here"; pwd)"

(cd $here; git submodule init)
(cd $here; git submodule update)

sudo apt update

printf "\033[1;31;49m=== Installing necessary packages ===\n\033[0m"
sudo apt -y install zsh tmux aptitude git curl wget
sudo apt -y install debhelper autotools-dev dh-autoreconf file
sudo apt -y install libncurses5-dev libevent-dev pkg-config libutempter-dev build-essential

printf "\033[1;32;49m=== Type Y/y to install/update python3: \033[0m"
read -n 1 c; echo ''
if [[ $c == 'Y' ]] || [[ $c == 'y' ]]; then
    sudo apt -y install python3 python3-venv python3-dev python3-pip
fi

printf "\033[1;31;49m=== Creating symlinks in $HOME:\n\033[0m"
for file in "$here"/"$1"*; do
    name="$(basename "$file")"
    if [[ !( " install.bash uninstall.bash oh-my-zsh-custom readme.md " =~ " $name " ) ]]; then
        ln -sfv $file "$HOME/.$1$name"
        echo "-> $HOME/.$1$name"
    fi
done

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    find "$here/oh-my-zsh-custom/custom" -maxdepth 1 -mindepth 1 -type f -print0 | xargs -0 -L 1 -I % ln -sfv % "$HOME/.oh-my-zsh/custom/"
    find "$here/oh-my-zsh-custom/themes" -maxdepth 1 -mindepth 1 -print0 | xargs -0 -L 1 -I % ln -sfv % "$HOME/.oh-my-zsh/themes/"
    find "$here/oh-my-zsh-custom/custom/plugins/" -maxdepth 1 -mindepth 1 -print0 | xargs -0 -L 1 -I % ln -sfv % "$HOME/.oh-my-zsh/custom/plugins/"
    find "$here/oh-my-zsh-custom/custom/ext/" -maxdepth 1 -mindepth 1 -print0 | xargs -0 -L 1 -I % ln -sfv % "$HOME/.oh-my-zsh/custom/"
fi

if [[ ! -d "$HOME/.fonts" ]]; then
    echo "Creating ~/.fonts"
    mkdir "$HOME/.fonts"
fi

sudo apt install -y fontconfig
if which fc-cache; then
    echo 'Installing powerline-patched-font'
    git clone https://github.com/powerline/fonts $HOME/powerline-font-temp
    find $HOME/powerline-font-temp -regextype posix-extended -iregex '.*\.(otf|ttf)' -print0 | xargs -0 -I % mv -v % $HOME/.fonts/
    rm -rfv $HOME/powerline-font-temp
    fc-cache -vf $HOME/.fonts/
fi

printf "\033[1;32;49m=== Type Y/y to change default shell to zsh: \033[0m"
read -n 1 c; echo '';
if [[ $c == 'Y' ]] || [[ $c == 'y' ]]; then
    chsh -s `which zsh`
fi

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