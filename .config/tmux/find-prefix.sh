#!/bin/bash

#host="$(hostname)"
#if [ "$host" = "harry-yoga920" ]; then
#    tmux set -g prefix C-f
#fi

if [ -n "$SSH_CLIENT" ] && [ -n "$SSH_TTY" ]; then
  echo "[$(date)] logged in via ssh" >> ~/tmux.log
  tmux set -g prefix C-b
else
  echo "[$(date)] logged in via tty" >> ~/tmux.log
  tmux set -g prefix C-f
fi
