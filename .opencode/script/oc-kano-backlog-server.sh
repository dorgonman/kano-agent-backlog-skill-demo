#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------------------
# oc-kano-backlog-server
# Start/stop an OpenCode server for this repo (optionally exposed via Tailscale Serve).
#
# Quickstarts live under: .opencode/script/quickstart/
# ------------------------------------------------------------------------------

HOST="127.0.0.1"
PORT="4096"
AUTH_MODE="auto" # auto|basic|none
PASSWORD_ENV="OPENCODE_SERVER_PASSWORD"

TAILNET="0"
TS_HTTPS_PORT="8443"
BG="0"
SERVICE="0"
STOP="0"
STATUS="0"

usage() {
  cat <<EOF
Usage:
  $(basename "$0") [options]
  $(basename "$0") --tailnet [options]
  $(basename "$0") --stop
  $(basename "$0") --status

Options:
  --host <ip>         Bind OpenCode to this host (default: 127.0.0.1).
  --port <port>       Bind OpenCode to this port (default: 4096).
  --auth <mode>       auto|basic|none (default: auto).
  --password-env <E>  Password env var used for basic auth (default: OPENCODE_SERVER_PASSWORD).

  --bg                Run OpenCode in background (pid: .opencode/run/opencode-serve.pid).
  --service           Keep the launcher process alive (for systemd/Windows service usage).
  --tailnet           Expose localhost:<port> via 'tailscale serve' within your tailnet.
                      Implies --bg and requires --host 127.0.0.1/localhost.
  --ts-https <port>   Tailscale HTTPS port (default: 8443).

  --stop              Stop background OpenCode server and reset tailscale serve.
  --status            Show tailscale serve status.

Examples:
  # Local-only (no auth, safe default)
  $(basename "$0")

  # Tailnet-only access (recommended)
  $(basename "$0") --tailnet --port 4096

  # LAN access (requires basic auth)
  $(basename "$0") --host 0.0.0.0 --auth basic --port 4096
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host) HOST="${2:-}"; [[ -n "$HOST" ]] || { echo "ERROR: --host requires a value." >&2; exit 2; }; shift 2;;
    --port) PORT="${2:-}"; [[ -n "$PORT" ]] || { echo "ERROR: --port requires a value." >&2; exit 2; }; shift 2;;
    --auth) AUTH_MODE="${2:-}"; [[ -n "$AUTH_MODE" ]] || { echo "ERROR: --auth requires a value." >&2; exit 2; }; shift 2;;
    --no-auth) AUTH_MODE="none"; shift;;
    --password-env) PASSWORD_ENV="${2:-}"; [[ -n "$PASSWORD_ENV" ]] || { echo "ERROR: --password-env requires a value." >&2; exit 2; }; shift 2;;
    --bg) BG="1"; shift;;
    --service) SERVICE="1"; shift;;
    --tailnet) TAILNET="1"; shift;;
    --ts-https) TS_HTTPS_PORT="${2:-}"; [[ -n "$TS_HTTPS_PORT" ]] || { echo "ERROR: --ts-https requires a value." >&2; exit 2; }; shift 2;;
    --stop) STOP="1"; shift;;
    --status) STATUS="1"; shift;;
    -h|--help) usage; exit 0;;
    *) echo "ERROR: Unknown argument: $1" >&2; usage >&2; exit 2;;
  esac
done

is_loopback_host() {
  case "$1" in
    127.0.0.1|localhost|::1) return 0 ;;
    *) return 1 ;;
  esac
}

have_cmd() { command -v "$1" >/dev/null 2>&1; }

resolve_bun_cmd() {
  if have_cmd bun; then
    printf "%s\n" "bun"
    return 0
  fi

  # Prefer explicit BUN_INSTALL if present.
  if [[ -n "${BUN_INSTALL:-}" ]]; then
    if [[ -x "${BUN_INSTALL}/bin/bun" ]]; then
      printf "%s\n" "${BUN_INSTALL}/bin/bun"
      return 0
    fi
    if [[ -x "${BUN_INSTALL}/bin/bun.exe" ]]; then
      printf "%s\n" "${BUN_INSTALL}/bin/bun.exe"
      return 0
    fi
  fi

  # Repo-local bun (used by Windows service env).
  if [[ -n "${REPO_ROOT:-}" ]]; then
    if [[ -x "${REPO_ROOT}/.opencode/.bun/bin/bun" ]]; then
      printf "%s\n" "${REPO_ROOT}/.opencode/.bun/bin/bun"
      return 0
    fi
    if [[ -x "${REPO_ROOT}/.opencode/.bun/bin/bun.exe" ]]; then
      printf "%s\n" "${REPO_ROOT}/.opencode/.bun/bin/bun.exe"
      return 0
    fi
  fi

  # Windows (Git Bash) common bun installs.
  if [[ -n "${USERPROFILE:-}" ]]; then
    local bun_win="${USERPROFILE}\\.bun\\bin\\bun.exe"
    if [[ -f "$bun_win" ]] && have_cmd cygpath; then
      local bun_u=""
      bun_u="$(cygpath -u "$bun_win" 2>/dev/null || true)"
      if [[ -n "$bun_u" ]] && [[ -x "$bun_u" ]]; then
        printf "%s\n" "$bun_u"
        return 0
      fi
    fi
  fi

  if [[ -n "${USERNAME:-}" ]]; then
    local bun_gb="/c/Users/${USERNAME}/.bun/bin/bun.exe"
    if [[ -x "$bun_gb" ]]; then
      printf "%s\n" "$bun_gb"
      return 0
    fi
    local bun_gb2="/c/Users/${USERNAME}/.bun/bin/bun"
    if [[ -x "$bun_gb2" ]]; then
      printf "%s\n" "$bun_gb2"
      return 0
    fi
  fi

  return 1
}

resolve_tailscale_cmd() {
  if have_cmd tailscale; then
    printf "%s\n" "tailscale"
    return 0
  fi

  # Windows Git Bash common installs
  if [[ -x "/c/Program Files/Tailscale/tailscale.exe" ]]; then
    printf "%s\n" "/c/Program Files/Tailscale/tailscale.exe"
    return 0
  fi

  if [[ -x "/c/Program Files (x86)/Tailscale/tailscale.exe" ]]; then
    printf "%s\n" "/c/Program Files (x86)/Tailscale/tailscale.exe"
    return 0
  fi

  return 1
}

resolve_repo_root() {
  local script_path="${BASH_SOURCE[0]}"
  if have_cmd realpath; then
    script_path="$(realpath "$script_path")"
  elif have_cmd python3; then
    script_path="$(python3 -c 'import os,sys;print(os.path.realpath(sys.argv[1]))' "$script_path")"
  fi

  local script_dir
  script_dir="$(cd "$(dirname "$script_path")" && pwd -P)"
  printf "%s\n" "$(cd "$script_dir/../.." && pwd -P)"
}

REPO_ROOT="$(resolve_repo_root)"
if [[ ! -d "$REPO_ROOT/.opencode" ]]; then
  echo "ERROR: Cannot find repo root (.opencode missing): $REPO_ROOT" >&2
  exit 2
fi

RUN_DIR="${REPO_ROOT}/.opencode/run"
LOG_DIR="${REPO_ROOT}/.opencode/logs"
OPENCODE_PID_FILE="${RUN_DIR}/opencode-serve.pid"
mkdir -p "$RUN_DIR" "$LOG_DIR"

require_opencode() {
  if ! have_cmd opencode; then
    echo "ERROR: 'opencode' not found in PATH." >&2
    echo "Hint: Install opencode on this machine, or adjust PATH." >&2
    exit 2
  fi
}

require_bun_for_ui() {
  # OpenCode UI plugins may require Bun to install assets (e.g. oh-my-opencode).
  # If Bun is missing, the browser can show BunInstallFailedError.
  if resolve_bun_cmd >/dev/null 2>&1; then
    return 0
  fi

  echo "ERROR: 'bun' not found; OpenCode UI may fail to load (BunInstallFailedError)." >&2
  echo "Hint : Install Bun (bun.sh) and ensure bun.exe is on PATH for the service/user." >&2
  echo "Hint : Repo helper scripts:" >&2
  echo "       - bash scripts/prerequisite.sh install" >&2
  echo "       - powershell -ExecutionPolicy Bypass -File scripts\\prerequisite.ps1 install" >&2
  return 2
}

ensure_basic_auth_password() {
  if [[ -n "${!PASSWORD_ENV:-}" ]]; then
    return 0
  fi

  if [[ ! -t 0 ]]; then
    echo "ERROR: ${PASSWORD_ENV} is not set and stdin is not a TTY." >&2
    echo "Set it like: ${PASSWORD_ENV}=xxx $(basename "$0") --auth basic ..." >&2
    exit 2
  fi

  echo "WARN: ${PASSWORD_ENV} is not set; prompting for a password." >&2

  local pw=""
  if have_cmd stty; then
    printf "Enter server password (input hidden): " >&2
    stty -echo
    read -r pw
    stty echo
    printf "\n" >&2
  else
    read -r -p "Enter server password: " pw >&2
  fi

  if [[ -z "$pw" ]]; then
    echo "ERROR: Empty password is not allowed." >&2
    exit 2
  fi

  export "${PASSWORD_ENV}=$pw"
  unset pw
}

start_opencode() {
  require_opencode
  require_bun_for_ui

  # Restart semantics: stop any previous --bg instance started by this script.
  stop_opencode_only
  stop_opencode_on_port_if_any

  echo "INFO: RepoRoot : $REPO_ROOT" >&2
  echo "INFO: Bind     : http://${HOST}:${PORT}" >&2
  if [[ "$AUTH_MODE" == "basic" ]]; then
    echo "INFO: Auth     : basic (${PASSWORD_ENV})" >&2
  else
    echo "INFO: Auth     : none" >&2
  fi

  cd "$REPO_ROOT"

  if [[ "$BG" == "1" ]]; then
    nohup opencode serve --hostname "$HOST" --port "$PORT" \
      > "${LOG_DIR}/opencode-stdout.log" \
      2> "${LOG_DIR}/opencode-stderr.log" &
    echo $! > "$OPENCODE_PID_FILE"
    echo "OK: opencode server started in background (pid=$(cat "$OPENCODE_PID_FILE"))" >&2
  else
    exec opencode serve --hostname "$HOST" --port "$PORT"
  fi
}

configure_tailscale_serve() {
  local ts_cmd=""
  ts_cmd="$(resolve_tailscale_cmd || true)"
  if [[ -z "$ts_cmd" ]]; then
    echo "ERROR: 'tailscale' CLI not found; cannot use --tailnet." >&2
    echo "Hint : Ensure tailscale.exe is installed and available in PATH." >&2
    return 2
  fi

  echo "INFO: Checking Tailscale daemon/login..." >&2
  if ! "$ts_cmd" status >/dev/null 2>&1; then
    echo "ERROR: Tailscale is not ready (daemon not running or not logged in)." >&2
    echo "Hint : Run 'tailscale up' (or open the Tailscale app and sign in), then retry." >&2
    return 2
  fi

  echo "INFO: Configuring: tailscale serve --bg --https=${TS_HTTPS_PORT} localhost:${PORT}" >&2
  # Do not redirect output: on some platforms this can be the only clue (e.g. login prompt/UAC).
  "$ts_cmd" serve --bg --https="${TS_HTTPS_PORT}" "localhost:${PORT}"
  echo "OK: tailscale serve configured." >&2
  "$ts_cmd" serve status || true
}

stop_all() {
  stop_opencode_only
  reset_tailscale_serve
}

stop_opencode_only() {
  if [[ -f "$OPENCODE_PID_FILE" ]]; then
    local pid=""
    pid="$(cat "$OPENCODE_PID_FILE" 2>/dev/null || true)"
    if [[ -n "$pid" ]] && kill -0 "$pid" >/dev/null 2>&1; then
      kill "$pid" || true
      echo "OK: stopped opencode server (pid=$pid)" >&2
    fi
    rm -f "$OPENCODE_PID_FILE"
  else
    return 0
  fi
}

stop_opencode_on_port_if_any() {
  # When opencode is started outside these scripts, the pid file is missing.
  # If the port is occupied by an opencode process, stop it to keep "restart" idempotent.
  if [[ "${OS:-}" != "Windows_NT" ]]; then
    return 0
  fi

  if ! have_cmd powershell.exe; then
    return 0
  fi

  local pid=""
  pid="$(
    powershell.exe -NoProfile -Command "\
      \$p=${PORT}; \
      \$c=Get-NetTCPConnection -LocalPort \$p -State Listen -ErrorAction SilentlyContinue \
        | Select-Object -First 1 -ExpandProperty OwningProcess; \
      if(\$c){Write-Output \$c}" 2>/dev/null | tr -d '\r' || true
  )"
  [[ -n "$pid" ]] || return 0

  local pname=""
  pname="$(
    powershell.exe -NoProfile -Command "\
      try { (Get-Process -Id $pid -ErrorAction Stop).ProcessName } catch { '' }" 2>/dev/null \
      | tr -d '\r' || true
  )"
  local cmdline=""
  cmdline="$(
    powershell.exe -NoProfile -Command "\
      try { (Get-CimInstance Win32_Process -Filter \"ProcessId=$pid\").CommandLine } catch { '' }" 2>/dev/null \
      | tr -d '\r' || true
  )"

  if [[ "$pname" =~ [Oo][Pp][Ee][Nn][Cc][Oo][Dd][Ee] ]] || [[ "$cmdline" =~ [Oo][Pp][Ee][Nn][Cc][Oo][Dd][Ee] ]]; then
    powershell.exe -NoProfile -Command "\
      try { Stop-Process -Id $pid -Force -ErrorAction Stop; \
        'OK: stopped opencode listener on port ${PORT} (pid=$pid)' } \
      catch { 'WARN: failed to stop pid='+$pid+': '+$_.Exception.Message }" 2>/dev/null \
      | tr -d '\r' >&2 || true
  fi
}

reset_tailscale_serve() {
  local ts_cmd=""
  ts_cmd="$(resolve_tailscale_cmd || true)"
  if [[ -z "$ts_cmd" ]]; then
    return 0
  fi
  "$ts_cmd" serve reset >/dev/null 2>&1 || true
  echo "OK: tailscale serve reset" >&2
}

show_status() {
  local ts_cmd=""
  ts_cmd="$(resolve_tailscale_cmd || true)"
  if [[ -z "$ts_cmd" ]]; then
    echo "INFO: tailscale CLI not found." >&2
    return 0
  fi
  "$ts_cmd" serve status || true
}

if [[ "$STATUS" == "1" ]]; then
  show_status
  exit 0
fi

if [[ "$STOP" == "1" ]]; then
  stop_all
  exit 0
fi

case "$AUTH_MODE" in
  auto|basic|none) ;;
  *) echo "ERROR: --auth must be auto|basic|none (got: $AUTH_MODE)" >&2; exit 2;;
esac

if [[ "$TAILNET" == "1" ]]; then
  if ! is_loopback_host "$HOST"; then
    echo "ERROR: --tailnet requires --host 127.0.0.1/localhost (got: $HOST)" >&2
    exit 2
  fi
  if [[ "$BG" != "1" ]]; then
    BG="1"
    echo "INFO: --tailnet implies --bg (running server in background)." >&2
  fi
fi

if [[ "$AUTH_MODE" == "auto" ]]; then
  if is_loopback_host "$HOST"; then
    AUTH_MODE="none"
  else
    AUTH_MODE="basic"
  fi
fi

if [[ "$AUTH_MODE" == "none" ]]; then
  unset "${PASSWORD_ENV}" || true
else
  ensure_basic_auth_password
fi

start_opencode
if [[ "$TAILNET" == "1" ]]; then
  # Ensure routing is refreshed on restart.
  reset_tailscale_serve
  configure_tailscale_serve
fi

if [[ "$SERVICE" == "1" ]]; then
  if [[ ! -f "$OPENCODE_PID_FILE" ]]; then
    echo "ERROR: expected pid file not found: $OPENCODE_PID_FILE" >&2
    exit 2
  fi

  SERVICE_PID="$(cat "$OPENCODE_PID_FILE" 2>/dev/null || true)"
  if [[ -z "$SERVICE_PID" ]]; then
    echo "ERROR: empty pid file: $OPENCODE_PID_FILE" >&2
    exit 2
  fi

  cleanup() {
    stop_all
  }
  trap cleanup INT TERM

  echo "INFO: service mode enabled; waiting on opencode pid=$SERVICE_PID" >&2
  while kill -0 "$SERVICE_PID" >/dev/null 2>&1; do
    sleep 2
  done
  echo "INFO: opencode process exited; stopping tailscale serve." >&2
  cleanup
fi
