#!/bin/bash
set -euo pipefail

# Push committed changes to remote gh-pages branch
# Run after deploy-to-gh-pages.sh to actually push to GitHub
#
# Usage: 
#   05-push-remote.sh [DEPLOY_DIR]
#   If no arguments provided, auto-detect paths for local usage

# Parse arguments or auto-detect paths
if [ $# -eq 1 ]; then
  # Parameterized mode: use provided path
  DEPLOY_DIR="$1"
  echo "Using provided path: $DEPLOY_DIR"
else
  # Local mode: auto-detect repository root
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
  DEPLOY_DIR="$REPO_ROOT/_ws/deploy/gh-pages"
  echo "Auto-detected path: $DEPLOY_DIR"
fi

# Validate workspace structure
if [ ! -d "$DEPLOY_DIR/.git" ]; then
  echo "Error: Deploy git repository not found: $DEPLOY_DIR/.git"
  exit 1
fi

echo "Pushing to remote gh-pages branch..."

cd "$DEPLOY_DIR"

# Check if there are commits to push
if git diff --quiet HEAD origin/gh-pages 2>/dev/null; then
  echo "No changes to push."
  exit 0
fi

# Push to remote
git push origin gh-pages

echo "Successfully pushed to gh-pages branch!"
echo "Documentation site should be available at:"
echo "https://dorgonman.github.io/kano-agent-backlog-skill/"