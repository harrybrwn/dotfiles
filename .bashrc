# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f ~/.cache/wallust/sequences ]; then
	(cat ~/.cache/wallust/sequences &)
elif [ -f ~/.cache/wal/sequences ]; then
	(cat ~/.cache/wal/sequences &)
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
#HISTFILESIZE=2000
#HISTFILE="$HOME/.config/bash/.bash_history"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

ID="$(. /etc/os-release && echo $ID)"
case "$ID" in
  arch)
    # Not automatically sourced in arch
    source /usr/share/git/git-prompt.sh
    ;;
esac
unset ID

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [[ "$color_prompt" = yes ]]; then
    PS1="\[\033[01;32m\]\u@\[\033[01;32m\]\h:\[\033[01;34m\]\w\[\033[0m\]\$(__git_ps1)\[\033[34m\]\$\[\033[00m\] "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w \$ '
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#    ;;
#*)
#    ;;
#esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# See 'man environment.d' and 'man systemd-environment-d-generator'
if [ -x /usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator ]; then
  eval "$(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)"
fi

PATH="$PATH:$HOME/.local/bin"

#######################
####### My shit #######
#######################

. ~/.rc

# Prompt
_git_branch() {
    local __branch="`git symbolic-ref --short -q HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null`"
    if [ -z "$__branch" ]; then
        printf ''
    else
        printf "($__branch) "
    fi
}

__nix_prompt() {
  if [ -n "${IN_NIX_SHELL:-}" ]; then
    printf '\033[36m(nix:%s)\033[0m ' "${IN_NIX_SHELL}"
  fi
}

__connectiq_sdk() {
  if [ -n "${CONNECTIQ_SDK}" ]; then
    printf '\033[93m(garmin:%s)\033[0m ' "$(basename "${CONNECTIQ_SDK}")"
  fi
}

# Just saving my original
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[0m\]:\[\033[01;34m\]\w\[\033[01;31m\] `_git_branch`\[\033[00m\]\$ '
if command -v __git_ps1 > /dev/null; then
  if [ -n "$SSH_CONNECTION" ]; then
    __HOSTNAME_HASH="$(hostname | cksum | cut -f1 -d' ')"
    __HOSTNAME_COLORS=('2' '13' '34' '86' '109' '177' '197' '147' '124') # 256 colors
    __HOSTNAME_N_COLORS="${#__HOSTNAME_COLORS[@]}"
    __HOSTNAME_COLOR_INDEX=$(( (__HOSTNAME_HASH % __HOSTNAME_N_COLORS) + 1))
    __HOSTNAME_COLOR=${__HOSTNAME_COLORS[${__HOSTNAME_COLOR_INDEX}]}
  else
    __HOSTNAME_COLOR="${THEME_SECONDARY_COLOR}"
  fi
  PS1="\[\033[38;5;\${THEME_SECONDARY_COLOR};1m\]\u@\[\033[38;5;\${__HOSTNAME_COLOR};1m\]\h\[\033[0m\]:\[\033[01;34m\]\w\[\033[01;31m\]\$(__git_ps1)\[\033[00m\] \$ "
fi

if command -v gopass > /dev/null 2>&1; then
    source <(gopass completion bash)
fi
if command -v apizza > /dev/null 2>&1; then
    source <(apizza completion bash)
fi
if command -v edu > /dev/null 2>&1; then
    source <(edu completion bash)
fi
if command -v kubectl > /dev/null 2>&1; then
  source <(kubectl completion bash)
fi
if command -v helm > /dev/null 2>&1; then
  source <(helm completion bash)
fi

complete -C /usr/bin/mc mc

# pnpm
export PNPM_HOME="/home/harry/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
