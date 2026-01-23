#!/bin/bash
set -euo pipefail

# Documentation preparation script for Quartz static site generator
# Collects and filters documentation from multiple repositories using manifest-based selection
# 
# Usage: 
#   02-prepare-content.sh [REPO_ROOT] [DEMO_DIR] [SKILL_DIR] [BUILD_DIR]
#   If no arguments provided, auto-detect paths for local usage

# Parse arguments or auto-detect paths
if [ $# -eq 4 ]; then
  # CI mode: use provided paths
  REPO_ROOT="$1"
  DEMO_DIR="$2"
  SKILL_DIR="$3"
  BUILD_DIR="$4"
  echo "Using provided paths (CI mode)"
else
  # Local mode: auto-detect repository root
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
  DEMO_DIR="$REPO_ROOT/_ws/src/demo"
  SKILL_DIR="$REPO_ROOT/_ws/src/skill"
  BUILD_DIR="$REPO_ROOT/_ws/build"
  echo "Auto-detected paths (local mode)"
fi

echo "Repository root: $REPO_ROOT"
echo "Demo directory: $DEMO_DIR"
echo "Skill directory: $SKILL_DIR"
echo "Build directory: $BUILD_DIR"

# Validate workspace structure
if [ ! -d "$DEMO_DIR" ] || [ ! -d "$SKILL_DIR" ]; then
  echo "Error: Required directories not found."
  echo "Demo dir exists: $([ -d "$DEMO_DIR" ] && echo 'yes' || echo 'no')"
  echo "Skill dir exists: $([ -d "$SKILL_DIR" ] && echo 'yes' || echo 'no')"
  exit 1
fi

mkdir -p "$BUILD_DIR/content"

# Function to copy files based on manifest
copy_with_manifest() {
  local source_dir="$1"
  local target_dir="$2" 
  local manifest_file="$3"
  
  if [ ! -f "$manifest_file" ]; then
    echo "Warning: Manifest $manifest_file not found, skipping $source_dir"
    return
  fi
  
  echo "Copying from $source_dir using manifest $manifest_file..."
  mkdir -p "$target_dir"
  
  # Process manifest line by line
  while IFS= read -r pattern || [ -n "$pattern" ]; do
    # Skip empty lines and comments
    [[ "$pattern" =~ ^[[:space:]]*$ ]] && continue
    [[ "$pattern" =~ ^[[:space:]]*# ]] && continue
    
    # Handle exclusion patterns (starting with !)
    if [[ "$pattern" =~ ^! ]]; then
      exclude_pattern="${pattern#!}"
      echo "  Excluding: $exclude_pattern"
      find "$target_dir" -path "*/$exclude_pattern" -delete 2>/dev/null || true
    else
      # Copy matching files
      echo "  Including: $pattern"
      (cd "$source_dir" && find . -path "./$pattern" -type f 2>/dev/null | while read -r file; do
        target_file="$target_dir/${file#./}"
        mkdir -p "$(dirname "$target_file")"
        cp "$file" "$target_file"
      done) || true
    fi
  done < "$manifest_file"
}

# Copy demo content with manifest
if [ -d "$DEMO_DIR" ] && [ -f "$DEMO_DIR/docs/publish.manifest" ]; then
  copy_with_manifest "$DEMO_DIR" "$BUILD_DIR/content/demo" "$DEMO_DIR/docs/publish.manifest"
fi

# Copy skill content with manifest  
if [ -d "$SKILL_DIR" ] && [ -f "$SKILL_DIR/docs/publish.manifest" ]; then
  copy_with_manifest "$SKILL_DIR" "$BUILD_DIR/content/skill" "$SKILL_DIR/docs/publish.manifest"
fi

# Fallback: copy main files if no manifest
if [ -f "$SKILL_DIR/README.md" ]; then
  echo "Setting up landing page..."
  # Add frontmatter with title to index.md
  {
    echo "---"
    echo "title: Kano Agent Backlog Skill"
    echo "---"
    echo ""
    cat "$SKILL_DIR/README.md"
  } > "$BUILD_DIR/content/index.md"
fi

if [ -f "$SKILL_DIR/SKILL.md" ]; then
  echo "Copying SKILL.md..."
  cp "$SKILL_DIR/SKILL.md" "$BUILD_DIR/content/skill-guide.md"
fi

echo "Documentation preparation completed successfully"