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
  du -bshc "$(\ls -A)" | sort -rh
}

mkdircd() {
  mkdir "$1" && cd "$1" || return
}

net() {
  # lspci -vv -s $(lspci | grep -i wireless | awk '{print $1}')
  # iwconfig $(iw dev | awk '/Interface /{print $2}')
  watch -n1 --color nmcli --colors yes device wifi list
}

show-colors() {
  if [ -n "$*" ]; then
    for n in "$@"; do
      printf "\x1b[38;5;${n}mcolor%d\n" "$n"
    done
    return;
  fi
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolor%3d " "$i"
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
  echo "wget ${flags[*]}" "$host" > ./download.script
  # Crawl the site.
  wget "${flags[@]}" "$host"
}

profile() {
	local flags=()
	local name=""
	local verbose=false
	declare -r NOCOL="\e[0m"
	declare -r YELLOW="\e[33m"
	declare -r RED="\e[31m"
	declare -r BLUE="\e[36m"

	log() {
		local lvl="$1"
		shift
		case "$lvl" in 
			d|dbg|dbug|debug) if $verbose; then echo -e "${YELLOW}[DBUG]${NOCOL} $*"; fi ;;
			i|inf|info)       echo -e "${BLUE}[INFO]${NOCOL} $*" ;;
			e|err|erro|error) echo -e "${RED}[ERRR]${NOCOL} $*"  ;;
		esac
	}

	declare -r BROWSER_CHROMIUM='chromium_chromium.desktop'
	declare -r BROWSER_BRAVE='brave-browser.desktop'
	set-browser() {
		log debug "Setting browser to \"$1\""
		xdg-settings set default-web-browser "$1"
	}
	set-git-email() {
		git config --global user.email "$1"
		log dbug "Set git email to \"$1\""
	}

	# parse flags
	while [ $# -gt 0 ]; do
		case "$1" in
			-h|-help|--help|help)
				cat<<EOF
Usage
  profile [options...] <profile|command>

Options
  -h --help   print help message

Commands
	help    print help message

Profiles
  work
  home
EOF
				return 0
				;;
			-v|--verbose)
				verbose=true
				shift
				;;
			*)
				if [ -z "$name" ]; then
					name="$1"
					shift
				else
					echo -e "\e[031mError\e[0m: Unknown flag \"$1\"" 1>&2
					return 1
				fi
				;;
		esac
	done

	log debug "Loading profile \"${name}\""

	# positional arguments
	case "$name" in
		work)
			if [ -z "$WORK_GIT_EMAIL" ]; then
				echo -e "\e[031mError\e[0m: \$WORK_GIT_EMAIL is not set" 1>&2
				return 1
			fi
			if [[ -z "$(go env GOPRIVATE)" && -n "${WORK_GO_PRIVATE}" ]]; then
				log dbug "Setting GOPRIVATE to \"${WORK_GO_PRIVATE}\""
				go env -w GOPRIVATE="${WORK_GO_PRIVATE}"
			fi
			set-browser "${BROWSER_CHROMIUM}"
			set-git-email "${WORK_GIT_EMAIL}"
			;;
		home)
			go env -w GOPRIVATE=''
			set-browser "${BROWSER_BRAVE}"
			set-git-email 'me@h3y.sh'
			;;
		'') # No argument
			declare -r browser="$(xdg-settings get default-web-browser)"
			case "$browser" in
				chromium_chromium.desktop)
					name='work'
					;;
				brave-browser.desktop|com.brave.Browser.desktop)
					name='home'
					;;
				*)
					echo -e "\e[031mError\e[0m: Unknown profile" 1>&2
					;;
			esac
			declare -r github_user="$(ssh -T git@github.com | sed 's/^Hi \([^!]*\)!.*$/\1/')"
			if [[ "$github_user" == 'harrybrwn' && "$name" == 'work' ]]; then
				echo -e "\e[031mError\e[0m: Invalid profile state. Check ssh keys and default browser \"$name\"" 1>&2
				return 1
			fi
			echo -e "\e[036mCurrent Profile\e[0m: \"$name\""
			return 0
			;;
		*)
			echo -e "\e[031mError\e[0m: Unknown profile name \"$name\"" 1>&2
			return 1
			;;
	esac
	echo -e "\e[036mDefault Browser\e[0m: $(xdg-settings get default-web-browser)"
	if [ ! -f "$HOME/.ssh/profiles/$name" ]; then
		echo -e "\e[031mError\e[0m: Could not find ssh profile \"$HOME/.ssh/profiles/$name\"" 1>&2
		return 1
	fi
	pushd ~/.ssh >/dev/null || return
	ln -f -s "profiles/$name" profile
	popd >/dev/null || true
	ssh -T git@github.com
	echo -e "\e[036mgit email\e[0m:   \e[034m$(git config --global --get user.email)\e[0m"
	echo -e "\e[036mprofile set\e[0m: \e[034m$name\e[0m"
}

# vim: ts=2 sts=2 sw=2 noexpandtab
