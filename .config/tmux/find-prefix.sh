#!/bin/bash

#host="$(hostname)"
#if [ "$host" = "harry-yoga920" ]; then
#    tmux set -g prefix C-f
#fi

if [ -n "$SSH_CLIENT" ] && [ -n "$SSH_TTY" ]; then
  tmux set -g prefix C-b
else
  tmux set -g prefix C-f
fi
