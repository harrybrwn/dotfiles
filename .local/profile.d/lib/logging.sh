# shellcheck disable=SC1090
source ~/.local/profile.d/lib/colors.sh

function error() {
	echo -e "${BOLD}${RED}Error${NOCOL}: $*" 1>&2
}

function warning() {
	echo -e "${BOLD}${YELLOW}Warning${NOCOL}: $*" 1>&2
}

export LOG_DATES=false
export LOG_DATE_FORMAT='%FT%T %P %:z'
export LOG_NOCOLORS=false
export LOG_LOGFILE=''

function log() {
	declare -r LEVEL_NAMES=('DBUG' 'INFO' 'WARN' 'ERRR')
	local nocol="${NOCOL}"
	local MODIFIERS=(
		"${DIM}"
		"${BOLD}${CYAN}"
		"${BOLD}${YELLOW}"
		"${BOLD}${RED}"
	)
	if [[ $LOG_NOCOLORS == 'true' ]]; then
		nocol=''
		MODIFIERS=('' '' '' '')
	fi

	log-date() {
		if [[ $LOG_NOCOLORS == 'true' ]]; then
			date "+${LOG_DATE_FORMAT}"
		else
			echo -e "${PURPLE}$(date "+${LOG_DATE_FORMAT}")${NOCOL}"
		fi
	}

	# # shellcheck disable=SC2329
	# eecho() {
	# 	echo "$@" >&2
	# }

	# Flags
	local outfile=/dev/stdout
	if [ -n "${LOG_LOGFILE:-}" ]; then
		outfile="${LOG_LOGFILE}"
	fi
	while [[ "$1" == --* ]]; do
		case "$1" in
			-h|--help)
				echo 'log [flags...] <level> [messages...]'
				echo
				echo 'Flags'
				echo '  -f --log-file'
				echo '  -h --help'
				echo
				echo 'Valid options for <level> are:'
				echo '  debug (d)'
				echo '  info (i)'
				echo '  warn (w)'
				echo '  error (e)'
				return
				;;
			-f|--file|--log-file)
				outfile="$2"				
				if [ -z "${outfile:-}" ]; then
					error 'No output file given'
					return 1
				fi
				shift 2
				;;
			*)
				error "unknown flag \"$1\""
				return 1
				;;
		esac
	done

	# Level argument
	local lvl
	case "$1" in 
		d|dbg|dbug|debug) lvl=0 ;;
		i|inf|info)       lvl=1 ;;
		w|warn|warning)   lvl=2 ;;
		e|err|erro|error) lvl=3 ;;
	esac
	shift
	# local print='echo'
	if [[ $lvl -gt 1 && "${outfile}" == '/dev/stdout' ]]; then
		# print=eecho
		outfile='/dev/stderr'
	fi
	local header="${MODIFIERS[$lvl]}${LEVEL_NAMES[$lvl]}${nocol}"
	if [[ ${LOG_DATES} == 'true' ]]; then
		header="$header $(log-date)"
	fi
	echo -e "[ $header ] $*" >> "${outfile}"
}

# vim: ft=sh ts=2 sts=2 sw=2 noexpandtab
