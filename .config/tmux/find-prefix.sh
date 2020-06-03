#!/bin/bash

host="$(hostname)"
if [ "$host" = "harry-yoga920" ]; then
    tmux set -g prefix C-f
fi

