#!/bin/bash
set -euo pipefail

# Deploy built site to skill repo gh-pages branch
# Run after build-quartz-site.sh to deploy the documentation

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

# Validate workspace structure
if [ ! -d "_ws/build/public" ]; then
  echo "Error: _ws/build/public directory not found. Run 03-build-site.sh first."
  exit 1
fi

# Clone skill repo gh-pages branch if not exists
if [ ! -d "_ws/deploy/gh-pages" ]; then
  echo "Setting up gh-pages branch..."
  mkdir -p _ws/deploy
  
  # Try to clone existing gh-pages branch, if it doesn't exist, create it
  if git ls-remote --heads https://github.com/dorgonman/kano-agent-backlog-skill.git gh-pages | grep -q gh-pages; then
    echo "Cloning existing gh-pages branch..."
    git clone --branch gh-pages https://github.com/dorgonman/kano-agent-backlog-skill.git _ws/deploy/gh-pages
  else
    echo "Creating new gh-pages branch..."
    git clone https://github.com/dorgonman/kano-agent-backlog-skill.git _ws/deploy/gh-pages
    cd _ws/deploy/gh-pages
    git checkout --orphan gh-pages
    git rm -rf .
    echo "# Documentation Site" > README.md
    git add README.md
    git config user.name "docs-bot"
    git config user.email "docs-bot@users.noreply.github.com"
    git commit -m "Initial gh-pages branch"
    cd "$REPO_ROOT"
  fi
fi

echo "Deploying to gh-pages branch..."

# Clear target directory (preserve .git)
find _ws/deploy/gh-pages -mindepth 1 -maxdepth 1 ! -name ".git" -exec rm -rf {} +

# Copy built site to deployment target
rsync -av "_ws/build/public/" "_ws/deploy/gh-pages/"

# Configure git and commit changes
cd _ws/deploy/gh-pages
git config user.name "docs-bot"
git config user.email "docs-bot@users.noreply.github.com"

git add -A
if git diff --cached --quiet; then
  echo "No changes to deploy."
  exit 0
fi

# Use current commit hash if available
if [ -d "../../src/demo/.git" ]; then
  COMMIT_HASH=$(cd ../../src/demo && git rev-parse HEAD)
  git commit -m "Deploy docs site from local build (${COMMIT_HASH})"
else
  git commit -m "Deploy docs site from local build"
fi

echo "Changes committed. To push to remote:"
echo "  cd _ws/deploy/gh-pages && git push origin gh-pages"
echo ""
echo "Or run: ./scripts/docs/05-push-remote.sh"