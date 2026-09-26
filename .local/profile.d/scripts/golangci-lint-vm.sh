#!/usr/bin/bash

# golangci-lint Version Manager
function golangci-lint-vm() {
	# shellcheck disable=SC1090
	source ~/.local/profile.d/lib/logging.sh 

	usage() {
		echo "golangci-lint-vm [flags...] <command>"
		echo
		echo "Commands"
		echo "  list (ls)      list installed versions"
		echo "  ls-remote      list versions available in the GitHub repository"
		echo "  use            switch the current version"
		echo "  download (dl)  download a new version"
		echo "  remove (rm)    remove an installed version"
		echo
		echo "Flags"
		echo "  -h --help  print help message"
	}

	local args=()
	function version_arg() {
		if [[ ${#args[@]} -lt 1 || "${args[0]}" == '' ]]; then
			error "no version given"
			return 1
		fi
		local v="${args[0]}"
		if [[ "${v}" == v* ]]; then
			v="$(echo "${v}" | sed -r 's/^v//g;')"
		fi
		if [[ "${v}" == 'latest' ]]; then
			error "version of 'latest' is not supported yet"
			return 1
		fi
		echo -n "${v}"
	}

	function list-installed() {
			find "${DOWNLOAD_DIR}/" \
				-maxdepth 1 \
				-type d \
				-regextype 'posix-extended' \
				-regex '/.*/[0-9]+\.[0-9]+(\.[0-9]+)?' \
				-printf "%f\n"
	}

	local dl_base='https://github.com/golangci/golangci-lint/releases/download'
	local repo='https://github.com/golangci/golangci-lint.git'
	local DOWNLOAD_DIR="$HOME/.local/share/golangci-lint-vm"
	mkdir -p "${DOWNLOAD_DIR}"

	local cmd
	while [ $# -gt 0 ]; do
		case "$1" in
			-h|--help)
				usage
				return 0
				;;
			*)
				if [ -z "${cmd:-}" ]; then
					cmd="$1"
				else
					args+=("$1")
				fi
				shift
				;;
		esac
	done

	case "$cmd" in
		help)
			usage
			return 0
			;;
		unuse)
			local target="$HOME/.local/bin/golangci-lint"
			[ -L "$target" ] && rm "$target"
			;;

		use)
			local v
			if [[ ${#args[@]} -eq 0 ]]; then
				# Prompt user for a version if no argument is given.
				v="$(list-installed | fzf)"
			elif ! v="$(version_arg)"; then
				return 1
			fi
			local dst="${DOWNLOAD_DIR}/${v}"
			local target="$HOME/.local/bin/golangci-lint"
			local bin
			if ! bin="$(find "${dst}" -executable -name 'golangci-lint')"; then
				error "could not find executable for $dst"
				return 1
			fi
			if [ -L "${target}" ]; then
				rm "${target}"
			fi
			echo -e "${GREEN}Linking to ${bin}${NOCOL}"
			ln -fs "${bin}" "${target}"
			# reset bash's bin paths cache
			hash golangci-lint
			;;

		dl|download)
			local v
			if ! v="$(version_arg)"; then
				return 1
			fi
			local dst="${DOWNLOAD_DIR}/${v}"
			local bin
			if bin="$(find "${dst}" -executable -name 'golangci-lint' 2> /dev/null)"; then
				if [[ -d "${dst}" && -x "${bin}" ]]; then
					warning "${v} is already installed"
				fi
			fi
			log info "version: ${v}"
			log info "dest:    ${dst}"
			local tarball=/tmp/golangci-lint-${v}.tar.gz
			# rm -f "${tarball}"
			if [ ! -f "${tarball}" ]; then
				if ! curl -SsLf -o "${tarball}" "${dl_base}/v${v}/golangci-lint-${v}-linux-amd64.tar.gz" ; then
					return 1
				fi
			fi
			mkdir -p "${dst}"
			tar -C "${dst}" -xzf "${tarball}"
			;;

		ls-remote)
			local remote_tags
			if ! remote_tags="$(git ls-remote --tags --refs "${repo}")"; then
				error "could not fetch versions from ${repo}"
				return 1
			fi
			printf '%s\n' "${remote_tags}" \
				| awk -F/ '$NF ~ /^v[0-9]/ { sub(/^v/, "", $NF); print $NF }' \
				| sort -V
			;;

		ls|list)
			local current
			if [ -f ~/.local/bin/golangci-lint ]; then
				local link
				link="$(readlink ~/.local/bin/golangci-lint)"
				current="$(basename "$(dirname "$(dirname "${link}")")")"
			fi
			for v in $(list-installed); do
				if [ "${v}" == "$current" ]; then
					echo -e "~> ${YELLOW}${v}${NOCOL}"
				else
					echo -e "   ${CYAN}${v}${NOCOL}"
				fi
			done
			;;

		rm|remove)
			local v
			if ! v="$(version_arg)"; then
				return 1
			fi
			local dst="${DOWNLOAD_DIR}/${v}"
			rm -rf "${dst}"
			;;

		*)
			error "Unknown command \"$cmd\""
			;;
	esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	# file is being run as a script
	set -euo pipefail
	golangci-lint-vm "$@"
else
	# file is being "sourced"
	alias golintvm=golangci-lint-vm
fi

# vim: ts=2 sts=2 sw=2 noexpandtab
