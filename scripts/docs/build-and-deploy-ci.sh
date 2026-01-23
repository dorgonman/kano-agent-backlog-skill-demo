#!/bin/bash
set -euo pipefail

# CI-specific build and deploy script for GitHub Actions
# Combines build and deploy steps with automatic push for CI automation
# For local use, prefer the individual numbered scripts for better control
#
# Usage: 
#   build-and-deploy-ci.sh [REPO_ROOT] [QUARTZ_DIR] [BUILD_DIR] [DEPLOY_DIR] [CONFIG_FILE]
#   If no arguments provided, auto-detect paths for local usage

# Parse arguments or auto-detect paths
if [ $# -eq 5 ]; then
  # CI mode: use provided paths
  REPO_ROOT="$1"
  QUARTZ_DIR="$2"
  BUILD_DIR="$3"
  DEPLOY_DIR="$4"
  CONFIG_FILE="$5"
  echo "Using provided paths (CI mode)"
else
  # Local mode: auto-detect repository root
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
  QUARTZ_DIR="$REPO_ROOT/_ws/src/quartz"
  BUILD_DIR="$REPO_ROOT/_ws/build"
  DEPLOY_DIR="$REPO_ROOT/_ws/deploy/gh-pages"
  CONFIG_FILE="$SCRIPT_DIR/quartz.config.ts"
  echo "Auto-detected paths (local mode)"
fi

echo "Repository root: $REPO_ROOT"
echo "Quartz directory: $QUARTZ_DIR"
echo "Build directory: $BUILD_DIR"
echo "Deploy directory: $DEPLOY_DIR"
echo "Config file: $CONFIG_FILE"

echo "Building Quartz site..."

# Step 3: Build site (npm ci and build)
cd "$QUARTZ_DIR"
npm ci

# Apply custom configuration
echo "Applying custom Quartz configuration..."
cp "$CONFIG_FILE" ./quartz.config.ts

# Install tokyo-night theme
echo "Installing tokyo-night theme..."
npm install --save-dev shiki-themes

# Build static site
echo "Building static site..."
CONTENT_DIR="$BUILD_DIR/content"
OUTPUT_DIR="$BUILD_DIR/public"
echo "Content directory: $CONTENT_DIR"
echo "Output directory: $OUTPUT_DIR"
npx quartz build --directory "$CONTENT_DIR" --output "$OUTPUT_DIR"

echo "Deploying to gh-pages..."

# Step 4 & 5: Deploy and push (combined for CI)
# Clear target directory (preserve .git)
find "$DEPLOY_DIR" -mindepth 1 -maxdepth 1 ! -name ".git" -exec rm -rf {} +

# Copy built site to deployment target
cp -r "$OUTPUT_DIR"/* "$DEPLOY_DIR/"

# Configure git and commit changes
cd "$DEPLOY_DIR"
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

git add -A
if git diff --cached --quiet; then
  echo "No changes to deploy."
  exit 0
fi

# Use GitHub context if available, otherwise generic message
if [ -n "${GITHUB_SHA:-}" ]; then
  git commit -m "Deploy docs site from GitHub Actions (${GITHUB_SHA})"
else
  git commit -m "Deploy docs site from local build"
fi

git push origin gh-pages

echo "Deployment completed successfully!"