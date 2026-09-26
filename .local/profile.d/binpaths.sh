#!/usr/bin/env bash

_ADR_TOOLS="${HOME}/.local/share/adr-tools/src"
if [[ -x "${_ADR_TOOLS}/adr" && ":${PATH}:" != *":${_ADR_TOOLS}:"* ]]; then
	export PATH="${PATH}:${_ADR_TOOLS}"
fi
unset _ADR_TOOLS

if [[ -d /usr/lib/cargo/bin && ":${PATH}:" != *":/usr/lib/cargo/bin:"* ]]; then
  PATH="$PATH:/usr/lib/cargo/bin"
fi

# pnpm
export PNPM_HOME='/home/harry/.local/share/pnpm'
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# Add mason installed LSPs
case ":${PATH}:" in
	*":$HOME/.local/share/nvim/mason/bin:"*) ;;
	*)
		if [[ -d "$HOME/.local/share/nvim/mason/bin" ]]; then
			export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"
		fi
		;;
esac
