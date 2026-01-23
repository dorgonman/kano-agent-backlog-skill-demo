#!/bin/bash
set -euo pipefail

# Build Quartz site locally
# Run after docs-prepare-quartz.sh to build the static site

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

# Validate workspace structure
if [ ! -d "_ws/src/quartz" ]; then
  echo "Error: _ws/src/quartz directory not found. Run 01-setup-workspace.sh first."
  exit 1
fi

if [ ! -d "_ws/build/content" ]; then
  echo "Error: _ws/build/content directory not found. Run 02-prepare-content.sh first."
  exit 1
fi

echo "Building Quartz site..."

# Install dependencies
echo "Installing Quartz dependencies..."
cd _ws/src/quartz
npm ci

# Build static site
echo "Building static site..."
npx quartz build --directory ../../build/content --output ../../build/public

cd "$REPO_ROOT"
echo "Build completed successfully!"
echo "Static site available in: _ws/build/public/"