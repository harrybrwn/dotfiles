#!/bin/sh

ssid=$(iw dev | sed -En 's/\s*(ssid )(.*$)/\2/p')

if [ -z "$ssid" ]; then
    echo "Not Connected"
    return
fi

# get the wifi link strength percetage and ssid
if [ "$1" = "ssid" ]; then
    out=$ssid
elif [ "$1" = "-a" ]; then
    out="$(awk "BEGIN{printf \"%.1f\", 100 * `awk 'NR==3{print $3}' /proc/net/wireless`/70}") $ssid"
else
    out=$(awk "BEGIN{printf \"%.1f\", 100 * `awk 'NR==3{print $3}' /proc/net/wireless`/70}")
fi
echo "$out"

echo "#[fg=$DULL]$out"
