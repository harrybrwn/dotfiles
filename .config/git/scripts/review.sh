#!/usr/bin/bash

set -euo pipefail

if [ -z "${1:-}" ]; then
	echo 'Error: One revision is required. (example: "review main..", "review main..HEAD")'
	exit 1
fi

mapfile -t commits < <(git log --pretty='tformat:%H' "$1")

for c in "${commits[@]}"; do
	echo "reviewing commit: $c"
	git show "$c"
done
