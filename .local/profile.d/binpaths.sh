#!/usr/bin/env bash

_ADR_TOOLS="${HOME}/.local/share/adr-tools/src"
if [[ -x "${_ADR_TOOLS}/adr" && ":${PATH}:" != *":${_ADR_TOOLS}:"* ]]; then
	export PATH="${PATH}:${_ADR_TOOLS}"
fi
unset _ADR_TOOLS

if [[ -d /usr/lib/cargo/bin && ":${PATH}:" != *":/usr/lib/cargo/bin:"* ]]; then
  PATH="$PATH:/usr/lib/cargo/bin"
fi
