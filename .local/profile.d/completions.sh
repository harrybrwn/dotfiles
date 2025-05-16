#!/usr/bin/bash

if [ ! -f /usr/local/share/complete_alias/complete_alias ] && [ ! -f /usr/share/complete-alias/complete_alias ]; then
  read -p "Install 'complete-aliases' completion for aliases (y/n): " -n 1 -r
  case "$REPLY" in
    y|Y)
      git clone git@github.com:cykerway/complete-alias.git /tmp/complete-aliases
			echo '$ sudo mv /tmp/complete-aliases /usr/local/share/complete_alias'
      sudo mv /tmp/complete-aliases /usr/local/share/complete_alias
      ;;
    *) ;;
  esac
  unset REPLY
fi

for f in /usr/share/complete-alias/complete_alias /usr/local/share/complete_alias/complete_alias; do
  if [ -f "$f" ]; then
    source "$f"
    if [ -n "${COMPLETE_ALIASES:-}" ]; then
      for a in ${COMPLETE_ALIASES}; do
        complete -F _complete_alias "$a"
      done
    fi
    break
  fi
done

_complete_ollama() {
    local cur prev words cword
    _init_completion -n : || return

    if [[ ${cword} -eq 1 ]]; then
        COMPREPLY=($(compgen -W "serve create show run push pull list ps cp rm help" -- "${cur}"))
    elif [[ ${cword} -eq 2 ]]; then
        case "${prev}" in
            (run|show|cp|rm|push|list|stop)
                WORDLIST=$((ollama list 2>/dev/null || echo "") | tail -n +2 | cut -d "	" -f 1)
                COMPREPLY=($(compgen -W "${WORDLIST}" -- "${cur}"))
                __ltrim_colon_completions "$cur"
                ;;
        esac
    fi
}
complete -F _complete_ollama ollama

