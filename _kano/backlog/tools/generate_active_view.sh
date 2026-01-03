#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

cmd=(
  python
  "$REPO_ROOT/_kano/backlog/tools/generate_view.py"
  --groups "New,InProgress"
  --title "Active Work"
  --output "$REPO_ROOT/_kano/backlog/views/Active.md"
)

echo "[CMD] ${cmd[*]}"
"${cmd[@]}"
