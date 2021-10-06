#!/usr/bin/env zsh

# options
setopt NO_clobber
setopt NO_beep

# aliases
if [[ -f "$HOME/.oh-my-zsh/custom/.zshrc.alias" ]]; then
    while read -r line || [[ -n "$line" ]]; do
        alias "$line"
    done < "$HOME/.oh-my-zsh/custom/.zshrc.alias"
fi

if which fzf > /dev/null; then
    alias fzfp='fzf --preview '"'"'[[ $(file --mime {}) =~ binary ]] &&
        echo {} is a binary file ||
        (highlight -O ansi -l {} ||
        coderay {} ||
        rougify {} ||
        cat {}) 2> /dev/null | head -500'"'"
fi

[[ -f "$HOME/.fzf.zsh" ]] && source $HOME/.fzf.zsh

# enable powerlevel10k theme, run `p10k configure` or edit ~/.p10k.zsh to customize prompt.
[[ -f "$HOME/.p10k.zsh" ]] && source $HOME/.p10k.zsh

source $HOME/.oh-my-zsh/custom/plugins/zsh-histdb/sqlite-history.zsh
autoload -Uz add-zsh-hook

# zsh-syntax-highlighting must be sourced at the end
source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh