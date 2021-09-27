#!/usr/bin/env bash
set -e

# workaround to run scripts at any directory
here="$(dirname "$0")"
here="$(cd "$here"; pwd)"

# export locations for other scripts to use
export here
export tmux_dir="$here/tmux"
export fzf_dir="$HOME/.fzf"
export font_dir="$HOME/.fonts"

# Files to ignore creating symlinks would be listed here.
# The spaces are important as it will be used for regex testing
# Exp: " file1 file2 file3 " =~ " file1 "
ignored_things=" install.bash "
ignored_things+=" install-fonts.sh "
ignored_things+=" install-ohmyzsh.sh "
ignored_things+=" install-tmux.sh "
ignored_things+=" initialize.sh "
ignored_things+=" uninstall.bash "
ignored_things+=" oh-my-zsh-custom "
ignored_things+=" tmux "
ignored_things+=" README.md "
export ignored_things

printf "\033[1;33;49mInitializing files...\n\033[0m"
# init submodules
cd $here && git submodule init
cd $here && git submodule update

# compile tmux
cd "$tmux_dir"
if [[ ! -f Makefile ]]; then
    sh autogen.sh
    ./configure >/dev/null 2>&1
fi
cd $here