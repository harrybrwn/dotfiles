wttr() {
  local request="https://wttr.in/"
  local args=()
  while [ $# -gt 0 ]; do
    case $1 in
      -h|--help)
        request+=':help'
        shift
        ;;
      *)
        request+="$1"
        shift
        ;;
    esac
  done
  #local request="wttr.in/"
  #local request="wttr.in/?0" # small
  #local request="wttr.in/?n" # shorter
  [ "$(tput cols)" -lt 125 ] && request+='?n'
  #echo "$request"
  curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}

fsizes() {
  du -bshc $(\ls -A) | sort -rh
}

mkdircd() {
  mkdir $1 && cd $1
}

net() {
  # lspci -vv -s $(lspci | grep -i wireless | awk '{print $1}')
  # iwconfig $(iw dev | awk '/Interface /{print $2}')
  watch -n1 --color nmcli --colors yes device wifi list
}

show-colors() {
  if [ -n "$1" ]; then
    echo "\x1b[38;5;$1mcolor$1 "
    return;
  fi
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolor%3d " $i
    if (( i%10==0&&i>0 )); then
      printf "\n"
    fi
  done
  echo ''
}

ipv6-disable() {
  echo '$ sudo -v'
  sudo -v
  sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
  sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
  # sudo sysctl -w net.ipv6.conf.tun0.disable_ipv6=1
}

ipv6-enable() {
  echo '$ sudo -v'
  sudo -v
  sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0
  sudo sysctl -w net.ipv6.conf.default.disable_ipv6=0
  # sudo sysctl -w net.ipv6.conf.tun0.disable_ipv6=0
  sudo sysctl -p
}

reset-mouse-speed() {
  echo "Error: '$0' has been deactivated."
  return 1
  if command -v xinput > /dev/null 2>&1; then
    xinput set-prop 'MX Master 2S Mouse' 'libinput Accel Speed' 1.0 > /dev/null 2>&1
    xinput set-prop 'MX Master 2S Mouse' 'Coordinate Transformation Matrix' \
      1.0 0.0 0.0 \
      0.0 1.0 0.0 \
      0.0 0.0 1.0 > /dev/null 2>&1
    xinput set-prop 'SYNA2B31:00 06CB:7F8B Touchpad' 'libinput Accel Speed' 1.0
    xinput set-prop 'SYNA2B31:00 06CB:7F8B Touchpad' 'Coordinate Transformation Matrix' \
      1.0 0.0 0.0 \
      0.0 1.0 0.0 \
      0.0 0.0 1.0
  fi
}
