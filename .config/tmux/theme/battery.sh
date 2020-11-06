#!/usr/bin/env bash

# STATUS_BATTERY_BAR
# type: bool
# default: true
if [ -z "$STATUS_BATTERY_BAR" ]; then
    STATUS_BATTERY_BAR=true
fi

# STATUS_BATTERY_PERCENT
# type: bool
# default: true
if [ -z "$STATUS_BATTERY_PERCENT" ]; then
    STATUS_BATTERY_PERCENT=true
fi

# STATUS_CHARGING_SYMBOL
# type: string
# default: ""
if [ -z "$STATUS_CHARGING_SYMBOL" ]; then
    STATUS_CHARGING_SYMBOL=""
fi

# IMPORTANT
# type: color
# default: colour250
if [ -z "$IMPORTANT" ]; then
    IMPORTANT=colour250
fi

if [ -z "$STATUS_BATTERY_COLOR" ]; then
    STATUS_BATTERY_COLOR=$STATUS_COLOR
fi

if [ -z "$STATUS_CHARGING_SYMBOL_COLOR" ]; then
    STATUS_CHARGING_SYMBOL_COLOR=$STATUS_BATTERY_COLOR
fi

# This is just here so I don't have to look it up again
_bat_symb='ϟ'

# Get the hex battery color on a
# range from 0 to 100
#
# Args:
#   $1 - percent (numeric)
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

# Get the battery bar based on battery percentage.
#
# Args:
#   $1 - battery percentage (numeric)
_bat_get_bar() {
    # If the battery bar has been
    # disabled then just return.
    if [ ! $STATUS_BATTERY_BAR ]; then
        return
    fi
    # Get the bar hight from the
    # percentage passed as arg 1.
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

# Output the battery section of
# the status bar
battery() {
    # If all battery variables are false then just return nothing
    if (! $STATUS_BATTERY_BAR) && (! $STATUS_BATTERY_PERCENT); then
        return
    fi

    # Find the battery name
    local bat=$(upower -e | grep -E 'battery' | head -n1)
    # Get the battery's percentage
    local percent=$(upower -i $bat | awk '/percentage:/{print $2}' | tr -d '%')
    # Get the battery's chargine state
    local state=$(upower -i $bat | awk '/state:/{print $2}')

    if $STATUS_BATTERY_COLOR; then
        local out="#[fg=$(_percent_hex_range $percent)]"
    else
        local out="#[fg=$IMPORTANT]"
    fi

    case $state in
        "discharging")
            ;;
        "charging")
            out="$out$STATUS_CHARGING_SYMBOL"
            ;;
        "fully-charged")
            ;;
        "unkown")
            ;;
    esac

    # If we could not find the percent, output nothing
    if [ -z "$percent" ]; then
        echo ''
    else
        # Check to see if the user has
        # disabled the battery bar or not
        if $STATUS_BATTERY_BAR; then
            out="$out$(_bat_get_bar $percent) "
        fi
        if $STATUS_BATTERY_PERCENT; then
            out="$out$percent%"
        fi
        echo "$out#[fg=default]"
    fi
}

battery
