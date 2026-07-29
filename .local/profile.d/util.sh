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
  # du -bshc $(\ls -A) | sort -rh

	local line
	declare -a files=()
	while read -r line; do
		files+=("$line")
	done < <(find . -mindepth 1 -maxdepth 1)
	du -bshc "${files[@]}" | sort -rh
}

mkdircd() {
  mkdir -p "$1" && cd "$1" || return
}

net() {
  # lspci -vv -s $(lspci | grep -i wireless | awk '{print $1}')
  # iwconfig $(iw dev | awk '/Interface /{print $2}')
  watch -n1 --color nmcli --colors yes device wifi list
}

show-colors() {
	local verbose=false
	while [ $# -gt 0 ]; do
		case "$1" in
			-v|-verbose)
				verbose=true
				shift
				;;
		esac
	done
  if [ -n "$*" ]; then
    for n in "$@"; do
      printf "\x1b[38;5;${n}mcolor%d\n" "$n"
    done
    return;
  fi
	echo -e "\e[1;3mTmux Colors\e[0m"
	printf "\t"
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolor%3d " "$i"
		# local code="x1b[38;5;${i}m"
		# printf "\\${code}\\\\%s " "${code}"
    if (( i%10==0&&i>0 )); then
      printf "\n\t"
    fi
  done
	printf "\n\n"
	echo -e "\e[1;3mANSI Terminal Escape Codes\e[0m"
	for i in {30..37}; do
		# printf "%d\n" "$i"
		printf "    "
		printf "basic: \x1b[0;${i}m\\\\e[0;%dm\x1b[0m " "${i}"
		printf "bold: \x1b[1;${i}m\\\\e[1;%dm\x1b[0m " "${i}"
		printf "dim: \x1b[2;${i}m\\\\e[2;%dm\x1b[0m " "${i}"
		printf "invert: \x1b[3;${i}m\\\\e[3;%dm\x1b[0m " "${i}"
		printf "underline: \x1b[4;${i}m\\\\e[4;%dm\x1b[0m " "${i}"
		printf "\n"
	done
	if $verbose; then
		printf "\n"
		echo -e "\e[1;3mBash 256 Colors\e[0m"
		printf "\t"
		for i in {0..255}; do
			local code="x1b[38;5;${i}m"
			printf "\\${code}\\\\%s " "${code}"
			if (( i%10==0&&i>0 )); then
				printf "\n\t"
			fi
		done
		printf "\n"
	fi
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
        echo "download-site [-h|--help] [-d] [flags...] <url>"
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
  echo "wget ${flags[*]}" "$host" > ./download.script
  # Crawl the site.
  wget "${flags[@]}" "$host"
}

stop-banyan() {
	sudo -v
	sudo systemctl stop banyanapp-admin.service bwgs.service
}

start-banyan() {
	sudo -v
	sudo systemctl start banyanapp-admin.service bwgs.service
}

alias stop-work-vpn=stop-banyan
alias start-work-vpn=start-banyan

function git-commit-set-date() {
	if [ -z "$1" ]; then
		echo "Error: no date passed."
		return 1
	fi
	local d
	d="$(date -d "$1")"
	GIT_COMMITTER_DATE="$d" git commit --amend --no-edit --date "$d"
}

# vim: ts=2 sts=2 sw=2 noexpandtab
