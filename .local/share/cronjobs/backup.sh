#!/usr/bin/bash

set -euo pipefail

if [ -z "${LOGNAME:-}" ]; then
  INCRON=false
  LOGNAME="$USER"
elif [ -n "${SYSTEMD_EXEC_PID:-}" ]; then
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

mkdir -p "$(dirname "${LOGFILE}")"
touch "$LOGFILE"

check_logfile() {
  if [ ! -d "${BASECAMP}/log" ]; then
    mkdir -p "${BASECAMP}/log"
  fi
  local size
  size="$(du "$LOGFILE" | awk '{ print $1 }')"
  # truncate log file if its longer than 250Mi
  if [ "$size" -gt $((250 * 1<<10)) ]; then
    truncate -s 0 "$LOGFILE"
  fi
}

to_logs() {
  local cmd
  cmd="$*"
  $cmd | tee -a "${LOGFILE}"
}

in-term() {
  local name
  name="$(basename "$(readlink -f /usr/bin/x-terminal-emulator)")"
  case "$name" in
    mlterm)
      x-terminal-emulator -e "$*"
      ;;
    gnome-terminal.wrapper|gnome-terminal)
      x-terminal-emulator -- "$*"
      ;;
    alacritty)
      x-terminal-emulator --command sh -c "$*"
      ;;
    *)
      log error "Don't know how to run terminal \"$name\""
      ;;
  esac
}

ncwait() {
  if [ $# -lt 2 ]; then
    echo "Usage: wait <host> <port> [timeout_seconds] [interval_seconds]"
    exit 1
  fi
  local HOST="$1"
  local PORT="$2"
  local TIMEOUT="${3:-60}"      # Default timeout: 60 seconds
  local INTERVAL="${4:-5}"      # Default check interval: 5 seconds
  local current_time elapsed start_time
  start_time=$(date +%s)
  while true; do
    nc -zv -w 1 "$HOST" "$PORT" >/dev/null 2>&1
    local nc_exit_code=$?
    if [ $nc_exit_code -eq 0 ]; then
      return 0
    fi
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))
    if [ $elapsed -ge "$TIMEOUT" ]; then
      return 1
    fi
    sleep "$INTERVAL"
  done
}

notify() {
  notify-send --app-name='backup.sh' --urgency=normal "$@"
}

notify_options() {
  action="$(notify-send --app-name='backup.sh' --urgency=critical \
    --action=logs="Open logs" \
    --action=disable="Disable backups" \
    --action=dismiss="Dismiss" "$@")"
  case "$action" in
    logs)
      in-term less +G "${LOGFILE}"
      ;;
    dismiss)
      ;;
    disable)
      systemctl --user stop backup.timer
      ;;
    "")
      ;;
    *)
      echo "Error: unknown action \"$action\""
      ;;
  esac
}

log() {
  local level="$1"
  shift
  local d
  d="$(date -Is)"
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
  --delete-excluded
  --exclude='*/node_modules/'
)

check_logfile

MACHINE_ID="$(cat /etc/machine-id)"
OS="$(. /etc/os-release && echo "$ID")"
HNAME="$(command -v hostname >/dev/null && hostname || cat /etc/hostname)"

host="$(ssh -G backup-server | awk '/^hostname/ { print $2 }')"
port="$(ssh -G backup-server | awk '/^port/ { print $2 }')"
if [ "${host}" = "backup-server" ]; then
  log error "Failed to find 'backup-server' in ~/.ssh/config"
  notify_options 'Backup Failed' 'Could not find "backup-server" host in ~/.ssh/config'
  exit 1
fi
if ! ncwait "$host" "$port"; then
  log error "can't reach backup server $host:$port"
  exit 1
fi

DST="/mnt/big-boi-0/backups/${HNAME}-${OS}-${MACHINE_ID}/"

#if ! ssh backup-server "mkdir -p '${DST}'" 2>&1; then
#  log error "failed to create backup dir ${DST}"
#fi

run_rsync() {
	log info "starting rsync $*"
	rsync "$@"
}

# log info "starting rsync ${flags[*]} --verbose ${HOME} backup-server:${DST}"
run_rsync \
	--rsync-path "mkdir -p ${DST} && rsync" \
  "${flags[@]}" \
	--verbose \
	--one-file-system \
  --exclude-from <(sed -E "s/^\//${LOGNAME}\//g" "${BASECAMP}/backup.exclude") \
  "$HOME" \
  "backup-server:${DST}" 2>&1 | tee -a "${LOGFILE}"

log info 'done'
# notify_options 'Backup Job Done' --expire-time=5000

# vim: ft=bash sw=2 ts=2
