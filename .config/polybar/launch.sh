#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 0.5; done

mkdir -p "$HOME/.cache/polybar/"
LOGFILE="$HOME/.cache/polybar/polybar.log"

echo "[$(date)] *** Starting from launch.sh" | tee -a "$LOGFILE"

# Launch polybar
polybar -r top 2>&1 | tee -a "$LOGFILE" & disown
