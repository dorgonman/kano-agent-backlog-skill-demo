#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd -P)"

ENSURE_SH="${SCRIPT_DIR}/ensure-kano-opencode-quickstart.sh"
if [[ -f "$ENSURE_SH" ]]; then
  source "$ENSURE_SH"
  ensure_kano_opencode_quickstart "$REPO_ROOT" >/dev/null
fi

cd "$REPO_ROOT"
exec opencode attach localhost:4096
