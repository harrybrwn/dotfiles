#!/usr/bin/bash

set -euo pipefail

cmd="$1"
shift

filters=(':(exclude)*.gen.go' '*.go')
tests=false
args=()
while [ $# -gt 0 ]; do
	if [ "$1" == '--tests' ]; then
		tests=true
	else
		args+=("$1")
	fi
	shift
done

if ! $tests; then
	filters+=(':(exclude)*_test.go')
fi

git "${cmd}" "${args[@]}" -- "${filters[@]}"
