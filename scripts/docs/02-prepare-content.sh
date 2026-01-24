#!/bin/bash
set -euo pipefail

# Enhanced content preparation with YAML-based configuration
# Supports content mapping, navigation structure, and automatic index generation

# Parse arguments or auto-detect paths
if [ $# -eq 4 ]; then
  REPO_ROOT="$1"
  DEMO_DIR="$2"
  SKILL_DIR="$3"
  BUILD_DIR="$4"
  echo "Using provided paths (CI mode)"
else
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
  DEMO_DIR="$REPO_ROOT/_ws/src/demo"
  SKILL_DIR="$REPO_ROOT/_ws/src/skill"
  BUILD_DIR="$REPO_ROOT/_ws/build"
  echo "Auto-detected paths (local mode)"
fi

mkdir -p "$BUILD_DIR/content"

# Clean previous build artifacts
echo "Cleaning previous build artifacts..."
rm -rf "$BUILD_DIR/content"/*
rm -rf "$BUILD_DIR/public"/*

# Process demo content with YAML config
if [ -d "$DEMO_DIR" ] && [ -f "$REPO_ROOT/docs/publish.config.yml" ]; then
  echo "Processing demo content with YAML config..."
  python "$SCRIPT_DIR/help/process_yaml_config.py" "$DEMO_DIR" "$BUILD_DIR/content" "$REPO_ROOT/docs/publish.config.yml"
fi

# Generate CLI and API docs
echo "Generating CLI documentation..."
mkdir -p "$BUILD_DIR/content/cli"

if command -v kano-backlog >/dev/null 2>&1; then
  echo "# CLI Reference" > "$BUILD_DIR/content/cli/index.md"
  echo "" >> "$BUILD_DIR/content/cli/index.md"
  echo "## kano-backlog" >> "$BUILD_DIR/content/cli/index.md"
  echo '```' >> "$BUILD_DIR/content/cli/index.md"
  kano-backlog --help >> "$BUILD_DIR/content/cli/index.md" 2>/dev/null || echo "Command not available" >> "$BUILD_DIR/content/cli/index.md"
  echo '```' >> "$BUILD_DIR/content/cli/index.md"
fi

echo "Enhanced content preparation completed successfully"