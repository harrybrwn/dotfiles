# XDG Config File Vars
#
# For a collection of guides on migrating to xdg dirs, see https://wiki.archlinux.org/title/XDG_Base_Directory
[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"
[ -z "$XDG_CACHE_HOME"  ] && export XDG_CACHE_HOME="$HOME/.cache"
[ -z "$XDG_DATA_HOME"   ] && export XDG_DATA_HOME="$HOME/.local/share"
[ -z "$XDG_STATE_HOME"  ] && export XDG_STATE_HOME="$HOME/.local/state"
#export XDG_RUNTIME_DIR=

# Python stuff
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export PYLINTHOME="$XDG_CONFIG_HOME/pylint"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export MYPY_CACHE_DIR="$XDG_CACHE_HOME/mypy"

# Rust/Cargo
export CARGO_HOME="$XDG_CONFIG_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export RUST_BACKTRACE=1 # 0|1|full
[ -f "$CARGO_HOME/env" ] && source "$CARGO_HOME/env"

# Ruby's Gem
export GEM_HOME="$XDG_CONFIG_HOME/gem"
export GEM_PATH="$XDG_CONFIG_HOME/gem"

# Stack (haskell toolchain)
export STACK_ROOT="$XDG_CONIFIG_HOME/stack"

# Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

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
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

# PostgresQL
export PSQL_HISTORY="$XDG_CONFIG_HOME/psql/history"
export PSQLRC="$XDG_CONFIG_HOME/psql/psqlrc"
export PGPASSFILE="$XDG_CONFIG_HOME/psql/pgpass"
export PGSERVICEFILE="$XDG_CONFIG_HOME/psql/service.conf"

# SQLite
export SQLITE_HISTORY="$XDG_CACHE_HOME/sqlite_history"

# Ansible (see https://docs.ansible.com/ansible/latest/reference_appendices/config.html)
export ANSIBLE_HOME="${XDG_CONFIG_HOME}/ansible"
export ANSIBLE_CONFIG="${XDG_CONFIG_HOME}/ansible.cfg"
export ANSIBLE_GALAXY_CACHE_DIR="${XDG_CACHE_HOME}/ansible/galaxy_cache"

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
#export TF_CLI_CONFIG_FILE="$XDG_CONFIG_HOME/terraform"
#export TF_PLUGIN_CACHE_DIR="$TF_CLI_CONFIG_FILE/plugin-cache"

# Nix
if [ -d "$HOME/.local/state/nix/profiles/profile/bin" ]; then
  export PATH="$PATH:$HOME/.local/state/nix/profiles/profile/bin"
fi

# Yarn
if [[ 
  -d "$HOME/.local/share/yarn/global" &&
  ":$PATH:" != *":$HOME/.local/share/yarn/global/node_modules/.bin:"*
]]; then
  PATH="$PATH:$HOME/.local/share/yarn/global/node_modules/.bin"
fi

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) [ -d "$PNPM_HOME" ] && export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$XDG_CONFIG_HOME/bun"
export PATH="$PATH:$BUN_INSTALL/bin"

# Grossness :(
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre"
export AXIS2_HOME="$HOME/dev/claresco/tools/axis2-1.8.0"
export CATALINA_BASE="/usr/local/tomcat7"
export CATALINA_HOME="$CATALINA_BASE"
export TOMCAT_HOME="$CATALINA_HOME"
export LEIN_HOME="$XDG_DATA_HOME/lein"
#export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib/oracle/instantclient_19_10"

# ollama
export OLLAMA_MODELS="$XDG_DATA_HOME/ollama/models"

# minikube
export MINIKUBE_HOME="$XDG_DATA_HOME/minikube"

# k9s
export K9SCONFIG="$XDG_CONFIG_HOME"/k9s

export IPFS_PATH="$XDG_DATA_HOME"/ipfs
export DISCORD_USER_DATA_DIR="${XDG_DATA_HOME}"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc

# CUDA
if [ -d /usr/local/cuda/bin ]; then
  export PATH="$PATH:/usr/local/cuda/bin"
fi

# vim: syntax=bash
