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
  if [ -n "$*" ]; then
    for n in $*; do
      printf "\x1b[38;5;${n}mcolor%d\n" "$n"
    done
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

brightness() {
  local f='/sys/class/backlight/intel_backlight/brightness'
  if [ ! -f "$f" ]; then
    echo 'Error: /sys/class/backlight/intel_backlight/brightness not found' 1>&2
    return 1
  fi
  case "$1" in
    help|-h|-help|--help)
      echo 'Usage brightness [on|off|help]'
      return 0
      ;;
    on)
      cat /sys/class/backlight/intel_backlight/max_brightness | sudo tee "$f"
      ;;
    off)
      echo '0' | sudo tee "$f"
      ;;
    *)
      cat "$f"
      ;;
  esac
}

download-site() {
  local dir_mode=false
  local ua='Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/134.0.6998.99 Mobile/15E148 Safari/604.1'
  local flags=(
    # Don't check robots.txt
    -e robots=off
    --user-agent="$ua"
    # Don't send caching headers to the server.
    --no-cache
    # Crawl all links on each page
    --recursive
    --continue
    --no-clobber
    --page-requisites
    # Don't crawl pages above the one supplied
    --no-parent
    # Print out status code and response headers
    --server-response
    --wait=5
  )
  local host
  while [ $# -gt 0 ]; do
    case "$1" in
      -h|-help|--help|help)
        echo "download-site [args...] <url>"
        return 0
        ;;
      -d)
        shift
        flags+=(--adjust-extension --convert-file-only)
        ;;
      -*)
        flags+=("$1")
        shift
        ;;
      *)
        if [ -n "${host:-}" ]; then
          echo "Error: unknown argument"
          return 1
        fi
        host="$1"
        shift
        ;;
    esac
  done
  # Get robots.txt so it looks like we're being good if a site admin looks at
  # their logs.
  wget --user-agent="$ua" -O /dev/null "$host/robots.txt" || true
  echo "wget ${flags[@]}" "$host" > ./download.script
  # Crawl the site.
  wget "${flags[@]}" "$host"
}
