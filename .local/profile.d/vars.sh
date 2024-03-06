# XDG Config File Vars
[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"
[ -z "$XDG_CACHE_HOME"  ] && export XDG_CACHE_HOME="$HOME/.cache"
[ -z "$XDG_DATA_HOME"   ] && export XDG_DATA_HOME="$HOME/.local/share"
[ -z "$XDG_STATE_HOME"  ] && export XDG_DATA_HOME="$HOME/.local/state"
#export XDG_RUNTIME_DIR=

# Python stuff
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export PYLINTHOME="$XDG_CONFIG_HOME/pylint"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"

# Rust/Cargo
export CARGO_HOME="$XDG_CONFIG_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# Ruby's Gem
export GEM_HOME="$XDG_CONFIG_HOME/gem"
export GEM_PATH="$XDG_CONFIG_HOME/gem"

# Stack (haskell toolchain)
export STACK_ROOT="$XDG_CONIFIG_HOME/stack"

# Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME/docker/machine"

# Gpg
#export GNUPGHOME="$XDG_DATA_HOME/gnupg"
#export GPG_TTY="$(tty)"

# Gradle
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"

# libice/ICEauthority
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEautority"

# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# Node.js
export NODE_REPL_HISTORY="$XDG_CONFIG_HOME/node/repl_history"

# wget
export WGETRC="$XDG_CONFIG_HOME/wgetrc"

# PostgresQL
export PSQL_HISTORY="$XDG_CONFIG_HOME/psql/history"
export PSQLRC="$XDG_CONFIG_HOME/psql/psqlrc"
export PGPASSFILE="$XDG_CONFIG_HOME/psql/pgpass"
export PGSERVICEFILE="$XDG_CONFIG_HOME/psql/service.conf"

# vim
#export VIMINIT=:so $XDG_CONFIG_HOME/vim/vimrc"
#export VIMDOTDIR="$XDG_CONFIG_HOME/vim"

# X11
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc

# Wine
export WINEPREFIX="$XDG_CONFIG_HOME/wine"

# adb
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export ADB_VENDOR_KEYS="$XDG_CONFIG_HOME/android"

# Custom GNU Builds
#export GNULIB_SRCDIR="$HOME/dev/linux/gnulib"

# R
if command -v R > /dev/null 2>&1; then
    rversion=$(R --version | head -n1 | awk '{print $3}')
    case $rversion in
        4.0.*)
            export R_LIBS_USER="$HOME/.config/R/x86_64-pc-linux-gnu-library/4.0"
            ;;
        3.4.*)
            export R_LIBS_USER="$HOME/.config/R/x86_64-pc-linux-gnu-library/3.4"
            ;;
    esac
    unset rversion
fi

# Gopass
if command -v gopass > /dev/null 2>&1; then
    export PASSWORD_STORE_DIR="$HOME/.config/passwords"
fi

# less
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"

# ripgrep (rg)
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# MinIO Client
export MC_CONFIG_DIR="$XDG_CONFIG_HOME/mc"

# Terraform
export TF_CLI_CONFIG_FILE="$XDG_CONFIG_HOME/terraform"
export TF_PLUGIN_CACHE_DIR="$TF_CLI_CONFIG_FILE/plugin-cache"

# Nix
export PATH="$PATH:$HOME/.local/state/nix/profiles/profile/bin"

# My secret keys
if [ -f ~/.local/profile.d/keys.sh ]; then
    . ~/.local/profile.d/keys.sh
fi
