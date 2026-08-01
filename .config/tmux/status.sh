#!/usr/bin/bash

# Just a simple tmux status line.
#
# Variables:
#
# * SESSION_BG - background color of the tmux session name
#
# * STATUS_CPU - Toggle cpu stats
#   type: bool
#   default: true
#
# * STATUS_MEM - Toggle memory stats
#   type: bool
#   default: true
#
# * STATUS_WIFI - Toggle wifi info
#   type: bool
#   default: true
#
# * STATUS_CHARGING_SYMBOL - charging symbol
#   type: string
#   default: ""
#
# * STATUS_COLOR - Enable or disable status bar colors
#   type: bool
#   default: true
#
# * STATUS_BATTERY_COLOR - Enable or disable battery colors
#   type: bool
#   default: true
#
# * STATUS_BATTERY_BAR - render the batter bar based on percentage if true
#   type: bool
#   default: true
#
# * STATUS_BATTERY_PERCENT - Enable or disable the battery percentage
#   type: bool
#   default: true
#
# * STATUS_PREFIX_ON_COLOR
#   type: string
#
# * STATUS_PANE_ACTIVE_TAB_BG_COLOR
# * STATUS_PANE_ACTIVE_TAB_FG_COLOR

set -e

BAR='▕▏'

#high=76
#low=220
#crit=1

BG=default
FG=black
DULL=colour246
IMPORTANT=colour250

if [ -z "$STATUS_COLOR" ]; then
    STATUS_COLOR=true
fi

if [ -z "$STATUS_CPU" ]; then
    STATUS_CPU=true
fi
if [ -z "$STATUS_MEM" ]; then
    STATUS_MEM=true
fi
if [ -z "$STATUS_WIFI" ]; then
    STATUS_WIFI=true
fi

_find_eth() {
  # Notes
  # plugged in => cat /sys/class/net/<dev>/carrier
  # device type => cat /sys/class/net/<dev>/device/class
  for d in "${@}"; do
    if [ -f "/sys/class/net/$d/device/class" ] && [ "$(cat "/sys/class/net/$d/device/class")" = "0x020000" ]; then
      return 0
    fi
  done
}

_is_usb_eth() {
	# shellcheck disable=SC1090
  test "$(. "/sys/class/net/$1/device/uevent" && echo -n "$DEVTYPE")" = "usb_interface"
}

_is_wireless() {
	# shellcheck disable=SC1090
  test "$(. "/sys/class/net/$1/uvent" && echo -n "$DEVTYPE")" = "wlan"
}

wifi() {
		local net_dev
    net_dev="$(
      ip -oneline -family inet address show up dynamic \
        | awk '{ print $2 }'
    )"
		local ssid
    ssid=$(iw dev | sed -En 's/\s*(ssid )(.*$)/\2/p')
    if [ -z "$ssid" ]; then
        net_dev="$(
          ip -oneline -family inet address show up dynamic \
            | awk '{ print $2 }'
        )"
        echo "$net_dev"
        if [ -z "$net_dev" ]; then
          echo 'no network'
        else
          echo "nic:$net_dev"
        fi
        return
    fi

    # adding "0" to end because /proc/net/wireless adds a "."
		local snr
		local link_quality
    snr="$(awk 'NR==3{print $3}' /proc/net/wireless)0"
    link_quality="$(awk "BEGIN{printf \"%.1f\", 100 * $snr/70}")"
    local out

    case $1 in
        -a)
            out="$ssid $link_quality%"
            ;;
        ssid)
            out=$ssid
            ;;
        link|link-quality)
            out=$link_quality
            ;;
        *)
            out=$link_quality
            ;;
    esac
    echo "$out"
}

mem() {
		local out
    if [ "$1" = "-h" ]; then
        # local total=$(free | awk '/Mem:/{print $3+$5}' | numfmt --to=iec --from-unit=1024)
        # local out="$total/$(free -h | awk '/Mem:/{print $2}')"
        out="$(free -h | awk '/Mem:/{print $3+$5}')/$(free -h | awk '/Mem:/{print $2}')"
        if [ "$out" = "/" ]; then out=""; fi
    else
        out=$(free | awk '/Mem:/{printf "%.1f%%\n",  100*(($3+$5)/$2)}')
    fi
    if [ -z "$out" ]; then
        echo ''
    else
        echo "#[fg=$DULL]mem: #[fg=$IMPORTANT]$out"
    fi
}

temp() {
		local temps
    temps="$(sensors | grep 'Core' | sed -En 's/Core [0-9]:\s+\+(.*)°C\s+.*$/\1/p' | tr '\n' ',')"
    python -c "t=[$temps];print('{:.1f}'.format(sum(t)/len(t)), '°C', sep='')"
}

cpu() {
    echo "#[fg=$DULL]cpu: #[fg=$IMPORTANT]#($HOME/.config/tmux/cpu.py)"
}

cpu_and_temp() {
    echo "#[fg=$DULL]cpu: #[fg=$IMPORTANT]#($HOME/.config/tmux/cpu.py) $(temp)"
}

date_status() {
    echo "#[bg=$BG,fg=$IMPORTANT]%b %d, %Y"
}

time_status() {
    echo "#[bg=colour240,fg=$IMPORTANT] %l:%M %P #[bg=default]"
}

# This script
self=$(readlink -f "$0")
# Directory for the library files
lib="$(dirname "$self")/theme"

if [ ! -d "$lib" ]; then
    err="Error: could not find theme directory '$lib'"
    tmux set -g status-right "$err"
    echo "$err"
    exit 1
fi

if [ -z "$SESSION_BG" ]; then
    SESSION_BG=magenta
fi


status_right() {
  local sep="#[fg=colour240]$BAR#[fg=default]"
  local stats=""
  local CPU="#($self cpu_and_temp)"
  local MEM="#($self mem)"
  local WIFI="#[fg=$DULL]#($self wifi -a)"
  local HOST=""
  if [[ "$STATUS_SHOW_HOST" = true ]] || [[ -n "$SSH_CLIENT" && -n "$SSH_TTY" ]]; then
    # stats="$stats${USER}@$(hostname)$sep"
    HOST="${USER}@$(hostname)$sep"
  fi
  if $STATUS_CPU && [ ! -z "$CPU" ]; then
      stats="$stats$CPU$sep"
  fi
  if $STATUS_MEM && [ ! -z "$MEM" ]; then
      stats="$stats$MEM$sep"
  fi
  if $STATUS_WIFI && [ ! -z "$WIFI" ]; then
      stats="$stats$WIFI$sep"
  fi
  local if_width_lt_90='#(test ! #{window_width} -lt 90; echo $?)'
  printf "%s\n" "#{?$if_width_lt_90,,$stats}$HOST$(date_status) $(time_status) #($lib/battery.sh)"
}

apply() {
    local current_tab_fg="${STATUS_PANE_ACTIVE_TAB_FG_COLOR:-colour234}"
		local current_tab_bg="${STATUS_PANE_ACTIVE_TAB_BG_COLOR:-color250}"
    tmux \
        set -g status-style bg=default,fg=default \; \
        set -g status-right-length 110    \; \
        set -g status-left-length 50      \; \
        set -g status-bg $BG              \; \
        set -g message-style fg="$DULL"   \; \
        set -g message-style bg="default" \; \
        set -g status-left "#[bg=${STATUS_PREFIX_ON_COLOR:-$SESSION_BG},fg=$FG]\
														#{?client_prefix,#[bg=$IMPORTANT]#[fg=$FG] #S ,[#S]}#[bg=$BG,fg=$BG] " \; \
        setw -g window-status-format '#[bg=colour0,fg=none]#[fg=colour7] #W ' \; \
        setw -g window-status-current-format \
					"#[fg=${current_tab_bg}]#[bg=${current_tab_bg},fg=${current_tab_fg},bold]\
					#W#[bg=colour0,fg=${current_tab_bg}]" \; \
        set -g status-right "$(status_right)"
}

"$@"
