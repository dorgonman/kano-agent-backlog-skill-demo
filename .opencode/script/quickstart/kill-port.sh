#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-}"
FORCE="${2:-}"

usage() {
  cat <<EOF
Usage:
  $(basename "$0") <port> [--force]

Examples:
  $(basename "$0") 4096
  $(basename "$0") 4096 --force
EOF
}

if [[ -z "${PORT}" ]] || [[ "${PORT}" == "-h" ]] || [[ "${PORT}" == "--help" ]]; then
  usage
  exit 2
fi

is_windows_shell() {
  case "$(uname -s 2>/dev/null || true)" in
    MINGW*|MSYS*|CYGWIN*) return 0 ;;
    *) return 1 ;;
  esac
}

confirm_or_exit() {
  local prompt="$1"
  if [[ "${FORCE}" == "--force" ]]; then
    return 0
  fi

  read -r -p "${prompt} [y/N] " ans
  if [[ ! "${ans}" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
  fi
}

kill_pids_unix() {
  local pids="$1"
  [[ -n "${pids}" ]] || return 0

  # Try graceful first.
  kill ${pids} 2>/dev/null || true
  sleep 0.5

  # Still alive? Force.
  for pid in ${pids}; do
    if kill -0 "${pid}" >/dev/null 2>&1; then
      kill -9 "${pid}" 2>/dev/null || true
    fi
  done
}

kill_pids_windows() {
  local pids="$1"
  [[ -n "${pids}" ]] || return 0

  for pid in ${pids}; do
    # /F is force; Windows doesn't have a great cross-shell "graceful" equivalent.
    taskkill //PID "${pid}" //F >/dev/null 2>&1 || taskkill /PID "${pid}" /F >/dev/null 2>&1 || true
  done
}

if is_windows_shell; then
  # Windows netstat output (Git Bash/MSYS) often has CRLF.
  pids="$(netstat -ano 2>/dev/null | tr -d '\r' | awk -v p=":${PORT}" '$1 ~ /^TCP$/ && $2 ~ p && $4 == "LISTENING" {print $5}' | sort -u | tr '\n' ' ' | xargs echo -n 2>/dev/null || true)"

  if [[ -z "${pids}" ]]; then
    echo "No LISTENING process found on port ${PORT}."
    exit 0
  fi

  echo "Listening PIDs on port ${PORT}: ${pids}"
  for pid in ${pids}; do
    tasklist //FI "PID eq ${pid}" 2>/dev/null || tasklist /FI "PID eq ${pid}" 2>/dev/null || true
  done

  confirm_or_exit "Kill these PIDs on port ${PORT}?"
  kill_pids_windows "${pids}"
  echo "Done."
  exit 0
fi

# Unix / WSL / macOS / Linux.
if command -v lsof >/dev/null 2>&1; then
  pids="$(lsof -tiTCP:"${PORT}" -sTCP:LISTEN 2>/dev/null || true)"
  if [[ -z "${pids}" ]]; then
    echo "No LISTENING process found on port ${PORT}."
    exit 0
  fi

  echo "Listening PIDs on port ${PORT}: ${pids}"
  lsof -n -P -iTCP:"${PORT}" -sTCP:LISTEN 2>/dev/null || true

  confirm_or_exit "Kill these PIDs on port ${PORT}?"
  kill_pids_unix "${pids}"
  echo "Done."
  exit 0
fi

if command -v fuser >/dev/null 2>&1; then
  # fuser prints PIDs on stdout; some distros require sudo to see process names, but PIDs usually work.
  pids="$(fuser -n tcp "${PORT}" 2>/dev/null | tr -s ' ' | xargs echo -n 2>/dev/null || true)"
  if [[ -z "${pids}" ]]; then
    echo "No LISTENING process found on port ${PORT}."
    exit 0
  fi

  echo "Listening PIDs on port ${PORT}: ${pids}"
  confirm_or_exit "Kill these PIDs on port ${PORT}?"
  kill_pids_unix "${pids}"
  echo "Done."
  exit 0
fi

echo "ERROR: Could not find a tool to resolve PIDs (need 'lsof' or 'fuser')." >&2
exit 1
