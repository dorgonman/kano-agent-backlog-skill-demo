#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd -P)"

ENSURE_SH="${SCRIPT_DIR}/ensure-kano-opencode-quickstart.sh"
if [[ ! -f "$ENSURE_SH" ]]; then
  echo "ERROR: missing ensure script: $ENSURE_SH" >&2
  exit 2
fi

source "$ENSURE_SH"
QUICKSTART_ROOT="$(ensure_kano_opencode_quickstart "$REPO_ROOT")"

OPENCODE_QUICKSTART="${QUICKSTART_ROOT}/quickstart.sh"
if [[ ! -f "$OPENCODE_QUICKSTART" ]]; then
  echo "ERROR: cannot find kano-opencode-quickstart quickstart.sh at: $OPENCODE_QUICKSTART" >&2
  exit 2
fi

exec "$OPENCODE_QUICKSTART" "$REPO_ROOT" "$@"
