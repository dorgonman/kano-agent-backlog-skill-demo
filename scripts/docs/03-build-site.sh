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

# Apply custom configuration
echo "Applying custom Quartz configuration..."
cp "$REPO_ROOT/scripts/docs/quartz.config.ts" ./quartz.config.ts

# Install tokyo-night theme
echo "Installing tokyo-night theme..."
npm install --save-dev shiki-themes

# Build static site
echo "Building static site..."
CONTENT_DIR="$(cd ../../build/content && pwd)"
OUTPUT_DIR="$(cd ../../build && pwd)/public"
echo "Content directory: $CONTENT_DIR"
echo "Output directory: $OUTPUT_DIR"
npx quartz build --directory "$CONTENT_DIR" --output "$OUTPUT_DIR"

cd "$REPO_ROOT"
echo "Build completed successfully!"
echo "Static site available in: _ws/build/public/"