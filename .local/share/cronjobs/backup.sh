#!/usr/bin/bash

set -euo pipefail

if [ -z "${LOGNAME:-}" ]; then
  INCRON=false
  LOGNAME="$USER"
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

log() {
  local level="$1"
  shift
  echo "[$(date -Is) $level] $*"
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
  --delete-excluded
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

log info "starting rsync ${flags[@]} ${HOME} ${DST}"
rsync \
	--rsync-path "mkdir -p ${DST} && rsync" \
  "${flags[@]}" --verbose \
  --exclude-from <(sed -E "s/^\//${LOGNAME}\//g" "${BASECAMP}/backup.exclude") \
  "$HOME" \
  "backup-server:${DST}" 2>&1
log info 'done.'
