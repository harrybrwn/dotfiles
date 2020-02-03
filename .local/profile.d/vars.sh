# My Variables
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# Python stuff
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export PYLINTHOME="$XDG_CONFIG_HOME/pylint"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"

# Rust
export CARGO_HOME="$XDG_CONFIG_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# Ruby's Gem
export GEM_HOME="$XDG_CONFIG_HOME/gem"
export GEM_PATH="$XDG_CONFIG_HOME/gem"

# Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# Gpg
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# Gradle
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"

# libice
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEautority"

# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# wget
export WGETRC="$XDG_CONFIG_HOME/wgetrc"

# X11
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc

# adb
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export ADB_VENDOR_KEYS="$XDG_CONFIG_HOME/android"

# less
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export LESSHISTFILE=-

if [ -f ~/.local/profile.d/keys.sh ]; then
    . ~/.local/profile.d/keys.sh
fi

ucmerced_ssh="engapps00.ucmerced.edu"
