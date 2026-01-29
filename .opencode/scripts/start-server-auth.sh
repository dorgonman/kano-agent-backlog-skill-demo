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

TARGET="${QUICKSTART_ROOT}/scripts/start-server-auth.sh"
if [[ ! -f "$TARGET" ]]; then
  echo "ERROR: cannot find start-server-auth.sh at: $TARGET" >&2
  exit 2
fi

exec "$TARGET" --workspace "$REPO_ROOT" "$@"
