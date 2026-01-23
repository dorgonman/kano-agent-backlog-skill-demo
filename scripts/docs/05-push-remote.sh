#!/bin/bash
set -euo pipefail

# Push committed changes to remote gh-pages branch
# Run after deploy-to-gh-pages.sh to actually push to GitHub

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

# Validate workspace structure
if [ ! -d "_ws/deploy/gh-pages/.git" ]; then
  echo "Error: _ws/deploy/gh-pages git repository not found. Run 04-deploy-local.sh first."
  exit 1
fi

echo "Pushing to remote gh-pages branch..."

cd _ws/deploy/gh-pages

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