#!/usr/bin/env bash
set -euo pipefail
# set -x # Enable debug tracing


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# Explicitly construct the command array to echo it for debugging
# Inject default ports (4096/8443) before "$@" so they can be overridden by user args
CMD=("${SCRIPT_DIR}/../oc-kano-backlog-server.sh" --port 4096 --ts-https 8443 "$@" --tailnet --host 127.0.0.1 --auth none)

exec "${CMD[@]}"

