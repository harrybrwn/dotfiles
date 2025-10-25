#!/bin/sh

set -eu

case "${1:-}" in
	check)
		systemctl status bluetooth.service >/dev/null
		;;

	toggle)
		if bluetoothctl show | grep -q 'Powered: yes'; then
			bluetoothctl power off
		else
			bluetoothctl power on
		fi
		;;

	status)
		if bluetoothctl show | grep -q 'Powered: yes'; then
			if echo info | bluetoothctl | grep -Eq '^Device ([A-F0-9]{2}:){5}[A-F0-9]{2}'; then
				#echo "%{F#2193ff}󰂱"
				echo "%{F#1079de}󰂱"
			else
				echo "󰂯"
			fi
		else
			echo "%{F#66ffffff}󰂲"
		fi
		;;

	*)
		echo "unknown command"
		exit 1
		;;
esac
