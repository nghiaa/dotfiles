#!/usr/bin/env zsh

# bindkey
bindkey '' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
export KEYTIMEOUT=1

# aliases
# alias ln='nocorrect ln'
# alias lsa='ls -alkiGF'
# alias rm='rm -r'
# alias cp='cp -vr'

if which fzf > /dev/null; then
    alias fzfp='fzf --preview '"'"'[[ $(file --mime {}) =~ binary ]] &&
        echo {} is a binary file ||
        (highlight -O ansi -l {} ||
        coderay {} ||
        rougify {} ||
        cat {}) 2> /dev/null | head -500'"'"
fi

export FZF_COMPLETION_TRIGGER=',,'
[[ -f "$HOME/.fzf.zsh" ]] && source $HOME/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f "$HOME/.p10k.zsh" ]] && source $HOME/.p10k.zsh

source $HOME/.oh-my-zsh/custom/plugins/zsh-histdb/sqlite-history.zsh
autoload -Uz add-zsh-hook

# zsh-syntax-highlighting must be sourced at the end
source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh