#!/usr/bin/bash

function profile() {
	# shellcheck disable=SC1090
	source ~/.local/profile.d/lib/logging.sh 

	local flags=()
	local name=""
	local verbose=false

	declare -r BROWSER_CHROMIUM='chromium_chromium.desktop'
	declare -r BROWSER_CHROME='google-chrome.desktop'
	declare -r BROWSER_BRAVE='brave-browser.desktop'

	function set-browser() {
		xdg-settings set default-web-browser "$1"
		log debug "Default browser set to \"$1\""
	}

	function set-git-email() {
		git config --global user.email "$1"
		log dbug "Set git email to \"$1\""
	}

	function link-github-token() {
		local dst="$HOME/.config/environment.d/03-github-token.conf"
		if [ -f "$1" ]; then
			ln -s "$1" "${dst}"
			log i "linking \"$1\" to \"${dst}\""
		elif [[ "$1" == "-" && -L "${dst}" ]]; then
			rm "${dst}"
			log i "unlinking github token"
		fi
	}

	function get-github-user() {
		declare -r github_user="$(ssh -T git@github.com | sed 's/^Hi \([^!]*\)!.*$/\1/')"
		if [[ "$github_user" == 'harrybrwn' && "$name" == 'work' ]]; then
			error "Invalid profile state. Check ssh keys and default browser \"$name\""
			return 1
		fi
	}

	function show-current-profile() {
			declare -r browser="$(xdg-settings get default-web-browser)"
			case "$browser" in
				"${BROWSER_CHROMIUM}"|"${BROWSER_CHROME}")
					name='work'
					;;
				"${BROWSER_BRAVE}"|com.brave.Browser.desktop)
					name='home'
					;;
				*)
					error "Could not deturmine profile"
					;;
			esac
			if ${verbose}; then
				get-github-user
			fi
			echo -e "${CYAN}Current Profile${NOCOL}: \"$name\""
			return 0
	}

	local CMD=''

	# parse flags
	while [ $# -gt 0 ]; do
		case "$1" in
			show)
				CMD=show
				shift
				;;
			-h|-help|--help|help)
				cat<<EOF
Usage
  profile [options...] <profile|command>

Options
  -h --help   print help message

Commands
  show    print the currently selected profile
  help    print help message

Profiles
  work
  home
EOF
				return 0
				;;
			test)
				CMD='test'
				shift
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

	case "${CMD}" in
		show)
			show-current-profile
			return 0
			;;
		test)
			log i without date
			LOG_DATES=true log i with date
			export LOG_NOCOLORS=true
			log i without date and without colors
			export LOG_DATES=true
			log i with date and without colors
			;;
		'')
			# TODO: Show picker to select profile
			if [ -z "${name}" ]; then
				name="$(printf "home\nwork\n" | fzf --tmux)"
			fi
			;;
	esac

	# positional arguments
	case "$name" in
		work)
			log debug "Checking \$WORK_GIT_EMAIL"
			if [ -z "$WORK_GIT_EMAIL" ]; then
				error "\$WORK_GIT_EMAIL is not set"
				return 1
			fi
			if [[ -z "$(go env GOPRIVATE)" && -n "${WORK_GO_PRIVATE}" ]]; then
				go env -w GOPRIVATE="${WORK_GO_PRIVATE}"
				log dbug "GOPRIVATE set to \"${WORK_GO_PRIVATE}\""
			fi
			set-browser "${BROWSER_CHROME}"
			set-git-email "${WORK_GIT_EMAIL}"
			link-github-token "${HOME}/work/ncsa/github-token.conf"
			;;
		home)
			go env -w GOPRIVATE=''
			log debug 'GOPRIVATE set to ""'
			set-browser "${BROWSER_BRAVE}"
			set-git-email 'h@hrry.me'
			link-github-token '-'
			;;
		'') # No argument
			error "Select a valid profile"
			return 1
			;;
		*)
			error "Unknown profile name \"${name}\""
			return 1
			;;
	esac

	if [ ! -f "$HOME/.ssh/profiles/$name" ]; then
		error "Could not find ssh profile \"$HOME/.ssh/profiles/$name\""
		return 1
	fi
	pushd ~/.ssh >/dev/null || return
	ln -f -s "profiles/$name" profile
	popd >/dev/null || true
	ssh -T git@github.com
	echo
	echo -e "${BOLD}${CYAN}Default Browser${NOCOL}: ${BLUE}$(xdg-settings get default-web-browser)${NOCOL}"
	echo -e "${BOLD}${CYAN}git email${NOCOL}:       ${BLUE}$(git config --global --get user.email)${NOCOL}"
	echo -e "${BOLD}${CYAN}profile set${NOCOL}:     ${BLUE}$name${NOCOL}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	# file is being run as a script
	set -euo pipefail
	profile "$@"
else
	# file is being "sourced"
	:
fi

# vim: ts=2 sts=2 sw=2 noexpandtab
