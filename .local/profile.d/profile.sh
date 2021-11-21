#!/bin/sh

set -e

BASEDIR=$(dirname $0)
LIBFILES=(
    "vars.sh"
    "paths.sh"
)
for f in ${LIBFILES[@]}; do
    if [ -f "$BASEDIR/$f" ]; then
        source "$BASEDIR/$f"
    fi
done
unset BASEDIR LIBFILES

