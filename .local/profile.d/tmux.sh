function setup() {
	declare -r NOCOL="\e[0m"
	declare -r RED="\e[31m"

  t-new() {
    declare -a tflags=('-A') # attach only if session already exists
    declare -a args=()
    if [ -n "$TMUX" ]; then
      tflags+=('-d') # detach after creating session
    fi
    local s=""
    while [ $# -gt 0 ]; do
      case "$1" in
        -s) s="$2";       shift 2 ;;
        *)  args+=("$1"); shift   ;;
      esac
    done
    tmux new-session "${tflags[@]}" -s "$s" "${args[@]}"
    [ -n "$TMUX" ] && tmux switch-client -t "$s"
  }

	open-find() {
		local searchpaths=(~/dev ~/.config ~/Videos ~/Pictures ~/Desktop ~/Downloads ~/tools)
		if [ -d ~/work ]; then
			searchpaths+=(~/work)
		fi
		if [ -d ~/mounts ]; then
			searchpaths+=(~/mounts)
		fi
		local selected
		selected="$(
			find \
				"${searchpaths[@]}" \
				-mindepth 1 -maxdepth 4 \
				-type d \
				-not -wholename '*/mounts/**/backups/*' \
				-not -wholename '*/mounts/**/SeagateDriveBackup/*' \
				-not -wholename '*/mounts/**/.gvfs/*' \
				-not -wholename '*/mounts/**/.dbus/*' \
			| fzf \
				--tmux '75%' \
				--preview 'eza -la {} --git --group-directories-first'
		)"
		if [ -z "$selected" ]; then
			return 1
		fi
		local name
		name="$(basename "$selected")"
		if [ -z "$name" ]; then
			echo "Invalid input"
			return 1
		fi
		t-new -s "$(echo "$name" | tr -d .)" -n "$name" -c "$selected"
	}

	usage() {
		cat <<-EOF
Usage
  setup [alias|command] [flags...]
  
Commands
  help    print this help message
  find    search dirs and setup session with selected
  dir     open a session at the given directory
  
Aliases
  dev             dev folder
  homelab|lab     homelab
  website|site    personal website
  interviewing    interview studying
  
Flags
  -h --help    print help message
EOF
	}

	local ARGS=()
	while [ $# -gt 0 ]; do
		case "$1" in
			-h|-help|--help|help)
				usage
				return 0
				;;
			*)
				ARGS+=("$1")
				;;
		esac
		shift 1
	done

	if [ ${#ARGS[@]} -eq 0 ]; then
		if tmux has-session -t 'home' 2>/dev/null; then
			local me
			me="$(who am i | awk '/tmux/ { print $2 }')"
			if [[ -n "$TMUX" && -n "${me:-}" ]]; then
				# echo 'Error: already inside the default session' >&2
				# return 1
				open-find
				return 0
			else
				exec tmux attach -t home
				return 0
			fi
		fi
		tmux \
			new-session -d -n misc   -s misc -c ~    \;\
			new-session -d -n 'dev'  -s dev -c ~/dev \;\
			new-session    -n 'home' -s home -c ~    \;\
				new-window -t 'home:2' -n 'home' -c ~  \;\
				new-window -t 'home:3' -n 'home' -c ~  \;\
				select-window -t 'home:1'              \;\
			select-window -t 'home:1'
		return 0
	fi

	for arg in "${ARGS[@]}"; do
		case "$arg" in
			# commands
			dir|tmp)
				local dir="$arg"
				if [ -z "$dir" ]; then
					echo "Error: no directory in first argument" 1>&2
					return 1
				fi
				local name
				name="$(basename "$selected")"
				t-new -s "$name" -n "$name" -c "$dir"
				;;
			find|f)
				open-find
				;;

			# aliases
			dev)
				t-new -s dev -n dev -c ~/dev
				;;
			homelab|lab)
				t-new -s homelab -n homelab -c ~/dev/web/hrry.me \;\
					new-window    -t 'homelab:2' -n homelab -c ~/dev/web/hrry.me \;\
					new-window    -t 'homelab:3' -n homelab -c ~/dev/web/hrry.me \;\
					select-window -t 'homelab:1'
				;;
			site|website)
				t-new -s website -n hrry.me -c ~/dev/web/harrybrwn.github.io \;\
					select-window -t 'website:1'
				;;
			interviewing|interview|interviews)
				t-new -s interviewing -n interviewing -c ~/dev/jobs/interviewing \;\
					select-window -t 'interviewing:1'
				;;

			# Handle unknowns...
			*)
				echo -ne "${RED}Error${NOCOL}: unknown command or alias \"$arg\"\n\n" >&2
				echo 'Use --help for more info.' >&2
				return 1
				;;
		esac
	done
}

# vim: ts=2 sts=2 sw=2 noexpandtab
