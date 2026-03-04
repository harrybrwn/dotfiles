if [ -n "$BASH_VERSION" ]; then
	BASEDIR="$(dirname "${BASH_SOURCE[0]}")"
else
	BASEDIR=$(dirname "$0")
fi

LIBFILES=(
	"vars.sh"
	"paths.sh"
	"keys.sh"
	"secrets.sh"
	"util.sh"
	"completions.sh"
	"binpaths.sh"
	"tmux.sh"
)
for f in "${LIBFILES[@]}"; do
	if [ -f "$BASEDIR/$f" ]; then
		# shellcheck disable=SC1090
		source "${BASEDIR}/${f}"
	fi
done
unset BASEDIR LIBFILES

