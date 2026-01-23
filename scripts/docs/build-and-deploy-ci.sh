#!/bin/bash
set -euo pipefail

# CI-specific build and deploy script for GitHub Actions
# Combines build and deploy steps with automatic push for CI automation
# For local use, prefer the individual numbered scripts for better control

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

echo "Building Quartz site..."

# Step 3: Build site (npm ci and build)
cd _ws/src/quartz
npm ci
npx quartz build --directory ../../build/content --output ../../build/public
cd "$REPO_ROOT"

echo "Deploying to gh-pages..."

# Step 4 & 5: Deploy and push (combined for CI)
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

git commit -m "Deploy docs site from ${GITHUB_REPOSITORY}@${GITHUB_SHA}"
git push origin gh-pages

echo "Deployment completed successfully!"