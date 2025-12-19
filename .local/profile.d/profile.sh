if [ -n "$BASH_VERSION" ]; then
	BASEDIR="$(dirname "$BASH_SOURCE")"
else
	BASEDIR=$(dirname $0)
fi

LIBFILES=(
	"vars.sh"
	"paths.sh"
	"keys.sh"
	"secrets.sh"
	"util.sh"
	"completions.sh"
	"binpaths.sh"
)
for f in "${LIBFILES[@]}"; do
	if [ -f "$BASEDIR/$f" ]; then
		source "$BASEDIR/$f"
	fi
done
unset BASEDIR LIBFILES

