#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
WRAPPER="${SCRIPT_DIR}/.opencode/scripts/quickstart.sh"
if [[ ! -f "$WRAPPER" ]]; then
  echo "ERROR: expected wrapper not found: $WRAPPER" >&2
  exit 2
fi

exec "$WRAPPER" "$@"
