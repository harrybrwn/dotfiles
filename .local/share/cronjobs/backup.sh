#!/usr/bin/bash

set -euo pipefail

if [ -z "${LOGNAME:-}" ]; then
  INCRON=false
  LOGNAME="$USER"
elif [ -n "${SYSTEMD_EXEC_PID}" ]; then
  # see systemd.exec(1)
  INCRON=false
  IN_SYSTEMD=true
else
  INCRON=true
fi

BASECAMP="${1:-}"
if [ -z "${BASECAMP}" ]; then
  BASECAMP="${HOME}/.local/share/cronjobs"
fi

LOGFILE="${BASECAMP}/log/cron-$LOGNAME.log"

check_logfile() {
  if [ ! -d "${BASECAMP}/log" ]; then
    mkdir -p "${BASECAMP}/log"
  fi
  local size="$(du $LOGFILE | awk '{ print $1 }')"
  # truncate log file if its longer than 250Mi
  if [ $size -gt $((250 * 1<<10)) ]; then
    truncate -s 0 "$LOGFILE"
  fi
}

to_logs() {
  local cmd="$@"
  $cmd | tee -a "${LOGFILE}"
}

in-term() {
  local name="$(basename "$(readlink -f /usr/bin/x-terminal-emulator)")"
  case "$name" in
    mlterm)
      x-terminal-emulator -e $*
      ;;
    gnome-terminal.wrapper|gnome-terminal)
      x-terminal-emulator -- $*
      ;;
    alacritty)
      x-terminal-emulator --command sh -c "$*"
      ;;
    *)
      log error "Don't know how to run terminal \"$name\""
      ;;
  esac
}

notify() {
  notify-send --app-name='backup.sh' --urgency=normal "$@"
}

log() {
  local level="$1"
  shift
  local d="$(date -Is)"
  echo "[${d} $level] $*" | tee -a "${LOGFILE}"
}

flags=(
  --archive
  --recursive
  --perms
  --owner
  --group
  --times
  --links
  --whole-file
  # --delete-excluded
  --exclude='*/node_modules/'
)

check_logfile

MACHINE_ID="$(cat /etc/machine-id)"
OS="$(. /etc/os-release && echo "$ID")"
HNAME="$(hostname)"

host="$(ssh -G backup-server | awk '/^hostname/ { print $2 }')"
port="$(ssh -G backup-server | awk '/^port/ { print $2 }')"
if [ "${host}" = "backup-server" ]; then
  log error "Failed to find 'backup-server' in ~/.ssh/config"
  exit 1
fi
if ! nc -z "$host" "$port"; then
  log error "can't reach backup server $host:$port"
  exit 1
fi

DST="/mnt/big-boi-0/backups/${HNAME}-${OS}-${MACHINE_ID}/"

#if ! ssh backup-server "mkdir -p '${DST}'" 2>&1; then
#  log error "failed to create backup dir ${DST}"
#fi

log info "starting rsync ${flags[@]} --verbose ${HOME} backup-server:${DST}"
rsync \
	--rsync-path "mkdir -p ${DST} && rsync" \
  "${flags[@]}" --verbose \
  --exclude-from <(sed -E "s/^\//${LOGNAME}\//g" "${BASECAMP}/backup.exclude") \
  "$HOME" \
  "backup-server:${DST}" 2>&1 | tee -a "${LOGFILE}"

log info 'done'
action="$(notify-send --app-name='backup.sh' --urgency=critical \
  'Backup Job Done' \
  "backup finished" \
  --action=logs="Open logs" \
  --action=dismiss="Dismiss")"
case "$action" in
  logs)
    in-term less +G "${LOGFILE}"
    ;;
  dismiss)
    ;;
  "")
    ;;
  *)
    echo "Error: unknown action \"$action\""
    ;;
esac
