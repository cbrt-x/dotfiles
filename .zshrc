export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

autoload -Uz compinit promptinit
compinit
promptinit

PS1="%F{49}λ(%?, %3~). %f"

# aliases
alias sudo='sudo '

alias ls='ls --color=auto -h'
alias la='ls -lA'
alias ll='ls -1'
alias tree='tree -C'

alias df='df -H'

alias heat='watch -d sensors'

alias dot-config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

[ -f "/home/jade/.local/share/ghcup/env" ] && source "/home/jade/.local/share/ghcup/env" # ghcup-env

setopt appendhistory

eval "$(zoxide init --cmd cd zsh)"

function mkdir_ () {
    mkdir -p "$1" && cd "$1"
}

function mkcabal () {
    mkdir_ "$1" && cabal init -m
}
