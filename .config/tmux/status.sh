#!/bin/sh

set -e

bat_symb='ϟ'
BAR='▕▏'

high=76
low=220
crit=1

BG=default
DULL=colour246
IMPORTANT=colour250
if [ -z "$COLOR" ]; then
    COLOR=false
fi

wifi() {
    local ssid=$(iw dev | sed -En 's/\s*(ssid )(.*$)/\2/p')
    if [ -z "$ssid" ]; then
        echo 'Not Connected'
        return
    fi
    local out
    if [ "$1" = "ssid" ]; then
        out=$ssid
    elif [ "$1" = "-a" ]; then
        out="$(awk "BEGIN{printf \"%.1f\", 100 * `awk 'NR==3{print $3}' /proc/net/wireless`/70}") $ssid"
    else
        out=$(awk "BEGIN{printf \"%.1f\", 100 * `awk 'NR==3{print $3}' /proc/net/wireless`/70}")
    fi
    echo "#[fg=$DULL]$out"
}

_percent_hex_range() {
    local percent=$1
    if [ $percent -le 10 ]; then
        echo '#c80000'
    elif [ $percent -le 20 ]; then
        echo '#c52f00'
    elif [ $percent -le 30 ]; then
        echo '#c35f00'
    elif [ $percent -le 40 ]; then
        echo '#c08e00'
    elif [ $percent -le 50 ]; then
        echo '#bebe00'
    elif [ $percent -le 60 ]; then
        echo '#98be00'
    elif [ $percent -le 70 ]; then
        echo '#72be00'
    elif [ $percent -le 80 ]; then
        echo '#4cbe00'
    elif [ $percent -le 90 ]; then
        echo '#26be00'
    else
        echo '#00be00'
    fi
}

mem() {
    if [ "$1" = "-h" ]; then
        # local total=$(free | awk '/Mem:/{print $3+$5}' | numfmt --to=iec --from-unit=1024)
        # local out="$total/$(free -h | awk '/Mem:/{print $2}')"
        local out="$(free -h | awk '/Mem:/{print $3+$5}')/$(free -h | awk '/Mem:/{print $2}')"
        if [ "$out" = "/" ]; then out=""; fi
    else
        local out=$(free | awk '/Mem:/{printf "%.1f%%\n",  100*(($3+$5)/$2)}')
    fi
    if [ -z "$out" ]; then
        echo ''
    else
        echo "#[fg=$DULL]mem: #[fg=$IMPORTANT]$out"
    fi
}

temp() {
    local temps="$(sensors | grep 'Core' | sed -En 's/Core [0-9]:\s+\+(.*)°C\s+.*$/\1/p' | tr '\n' ',')"
    python -c "t=[$temps];print('{:.1f}'.format(sum(t)/len(t)), '°C', sep='')"
}

cpu() {
    echo "#[fg=$DULL]cpu: #[fg=$IMPORTANT]#($HOME/.config/tmux/cpu.py) $(temp)"
}

date_status() {
    echo "#[bg=$BG,fg=$IMPORTANT]%b %d, %Y"
}

time_status() {
    echo "#[bg=colour240,fg=$IMPORTANT] %l:%M %P #[bg=default]"
}

self=$(dirname `readlink -f "$0"`)

apply() {
    local sep="#[fg=colour240]$BAR#[fg=default]"
    local if_width_lt_110='#(test ! #{window_width} -lt 110; echo $?)'
    local CPU="#[fg=$DULL]cpu: #[fg=$IMPORTANT]#($HOME/.config/tmux/cpu.py) $(temp)"
    local MEM="$(mem -h)"
    local WIFI="$(wifi -a)"
    local stats=""
    if [ ! -z "$CPU" ]; then
        stats="$stats $CPU $sep"
    fi
    if [ ! -z "$MEM" ]; then
        stats="$stats $MEM $sep"
    fi
    if [ ! -z "$WIFI" ]; then
        stats="$stats $WIFI $sep"
    fi
    tmux \
        set -g status-right-length 110 \; \
        set -g status-left-length 50 \; \
        set -g status-bg $BG \; \
        set -g message-fg "$DULL" \; \
        set -g message-bg "default" \; \
        set -g status-left "#[bg=magenta,fg=colour0]#{?client_prefix,#[bg=$IMPORTANT]#[italics] #S ,[#S]}#[bg=$BG,fg=colour12] " \; \
        setw -g window-status-format '#[bg=colour0,fg=$dull]#[fg=colour7] #W ' \; \
        setw -g window-status-current-format '#[bg=colour240,fg=colour250,nobold,italics] #W ' \; \
        set -g status-right "#{?$if_width_lt_110,,$stats }$(date_status) $(time_status) #($self/theme/battery.sh)"
}

"$@"