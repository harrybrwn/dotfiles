# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.config/zsh/oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

#ZSH_THEME="robbyrussell"
# ZSH_THEME="gentoo"
#ZSH_THEME="lukerandall"
# ZSH_THEME="agnoster"
# ZSH_THEME="harry-gentoo"

# ZSH_THEME="harry-agnoster"
ZSH_THEME="harry-bash"
#ZSH_THEME="half-life"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

#plugins=(git man-theme)
#plugins=(git)

plugins=(man-theme vundle golang)

source $ZSH/oh-my-zsh.sh

autoload -U colors && colors
HISTFILE=~/.cache/zsh/history
_comp_options+=(globdots)

# My shit
. ~/.rc

# tetris
autoload -Uz tetriscurses

# Custom Color for harry theme
PROMPT_DIR_COLOR=magenta


# For st
function zle-line-init () { echoti smkx }
function zle-line-finish () { echoti rmkx }
zle -N zle-line-init
zle -N zle-line-finish

case "$TERM" in
st*)
    ;;
*)
    source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    :
    ;;
esac

# source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

comp_commands=(apizza edu yt arduino-cli)
for cmd in $comp_commands; do
    if command -v $cmd > /dev/null 2>&1; then
        source <($cmd completion zsh)
        compdef _$cmd $cmd
    fi
done

# Setup gopass completion
if command -v gopass > /dev/null 2>&1; then
    source <(gopass completion zsh | head -n -1 | tail -n +2)
    compdef _gopass gopass
fi
if command -v gh > /dev/null 2>&1; then
    source <(gh completion -s zsh)
    compdef _gh gh
fi
if command -v govm > /dev/null 2>&1; then
    source <(govm completion zsh)
    compdef _govm govm
fi
if command -v kubectl > /dev/null 2>&1; then
    source <(kubectl completion zsh)
    compdef _kubectl kubectl
fi
#if command -v minikube > /dev/null 2>&1; then
#    source <(minikube completion zsh)
#fi
if command -v kind > /dev/null 2>&1; then
    source <(kind completion zsh)
    compdef _kind kind
fi
if command -v k3d > /dev/null 2>&1; then
    source <(k3d completion zsh)
    compdef _k3d k3d
fi
if command -v helm > /dev/null 2>&1; then
    source <(helm completion zsh 2>/dev/null)
    compdef _helm helm
fi

# if command -v arpdb > /dev/null 2>&1; then
#     source <(arpdb completion zsh)
#     compdef _arpdb arpdb
# fi

## apizza completion
#if command -v apizza > /dev/null 2>&1; then
#    source <(apizza completion zsh)
#    compdef _apizza apizza
#fi
## github cli completion
## edu completion
#if command -v edu > /dev/null 2>&1; then
#    source <(edu completion zsh)
#    compdef _edu edu
#fi
## yt completion
#if command -v yt > /dev/null 2>&1; then
#    source <(yt completion zsh)
#    compdef _yt yt
#fi
#if command -v arduino-cli > /dev/null 2>&1; then
#    source <(arduino-cli completion zsh)
#    compdef _arduino-cli arduino-cli
#fi

