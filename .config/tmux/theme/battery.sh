#!/usr/bin/env bash
bat_symb='ϟ'
IMPORTANT=colour250

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

_bat_get_bar() {
    local percent=$1
    if [ $percent -lt 5 ]; then
        local bar=''
    elif [ $percent -lt 10 ]; then
        local bar='▁'
    elif [ $percent -lt 20 ]; then
        local bar='▂'
    elif [ $percent -lt 40 ]; then
        local bar='▃'
    elif [ $percent -lt 60 ]; then
        local bar='▄'
    elif [ $percent -lt 80 ]; then
        local bar='▅'
    else
        local bar='▇'
    fi
    echo "#[bg=colour240]$bar#[bg=default]"
}

battery() {
    local bat=$(upower -e | grep -E 'battery|DisplayDevice' | head -n1)
    local percent=$(upower -i $bat | awk '/percentage:/{print $2}' | tr -d '%')
    local state=$(upower -i $bat | awk '/state:/{print $2}')

    if $COLOR; then
        local out="#[fg=$(_percent_hex_range $percent)]"
    else
        local out="#[fg=$IMPORTANT]"
    fi
    if [ $state = "charging" ]; then
        out="$out$bat_symb "
    fi

    if [ -z "$percent" ]; then
        echo ''
    else
        echo "$out$(_bat_get_bar $percent) $percent%#[fg=colour249]"
    fi
}

battery
