host="$(hostname)"
if [ $host = "harry-yoga920" ]; then
    tmux set -g prefix C-f
    unset C-b
fi
