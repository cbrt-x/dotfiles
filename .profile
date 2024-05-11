export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"
export MPLAYER_HOME="${XDG_CONFIG_HOME}/mplayer"
export npm_config_cache="${XDG_CACHE_HOME}/npm"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv"
export GOPATH="${XDG_DATA_HOME}/go"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java"
export __GL_SHADER_DISK_CACHE_PATH="${XDG_CACHE_HOME}/nv"
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export STACK_ROOT="${XDG_DATA_HOME}/stack"
export GHCUP_USE_XDG_DIRS=""

alias wget="wget --hsts-file="${XDG_CACHE_HOME}/wget-hsts""

export PATH=$PATH:$HOME/Scripts;

export HISTSIZE=1000
export SAVEHIST=1000
