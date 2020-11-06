# XDG Config File Vars
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
#export XDG_RUNTIME_DIR=

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

# less
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
#export LESSHISTFILE='-'
# export LESS_TERMCAP_mp=$(tput bold; tput setaf 4)
# export LESS_TERMCAP_md=$(tput bold; tput setaf 5) # headers and flags
# export LESS_TERMCAP_me=$(tput sgr0)
# export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 0) # status bar
# export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
# export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # names of other programs
# # unset LESS_TERMCAP_us
# export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
# export LESS_TERMCAP_mr=$(tput rev)
# export LESS_TERMCAP_mh=$(tput dim)
# export LESS_TERMCAP_ZN=$(tput ssubm)
# export LESS_TERMCAP_ZV=$(tput rsubm)
# export LESS_TERMCAP_ZO=$(tput ssupm)
# export LESS_TERMCAP_ZW=$(tput rsupm)
#
if [ -f ~/.local/profile.d/keys.sh ]; then
    . ~/.local/profile.d/keys.sh
fi

if command -v gopass > /dev/null 2>&1; then
    export PASSWORD_STORE_DIR="$HOME/.config/passwords"
fi
