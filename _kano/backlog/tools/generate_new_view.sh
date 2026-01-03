#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

cmd=(
  python
  "$REPO_ROOT/_kano/backlog/tools/generate_view.py"
  --groups "New"
  --title "New Work"
  --output "$REPO_ROOT/_kano/backlog/views/New.md"
)

echo "[CMD] ${cmd[*]}"
"${cmd[@]}"
