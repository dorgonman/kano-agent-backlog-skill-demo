#!/bin/bash
set -euo pipefail

# Documentation preparation script for Quartz static site generator
# Collects and filters documentation from multiple repositories using manifest-based selection
# 
# Usage: Run from repository root where _ws/ directory exists
# Expected structure:
#   _ws/demo/     - Demo repository content
#   _ws/skill/    - Skill repository content  
#   _ws/content/  - Output directory (created by this script)

# Validate workspace structure
if [ ! -d "_ws" ]; then
  echo "Error: _ws directory not found. Run from repository root with _ws/ structure."
  echo "Use scripts/test-docs-prepare.sh for local testing."
  exit 1
fi

mkdir -p _ws/build/content

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
if [ -d "_ws/src/demo" ] && [ -f "_ws/src/demo/docs/publish.manifest" ]; then
  copy_with_manifest "_ws/src/demo" "_ws/build/content/demo" "_ws/src/demo/docs/publish.manifest"
fi

# Copy skill content with manifest  
if [ -d "_ws/src/skill" ] && [ -f "_ws/src/skill/docs/publish.manifest" ]; then
  copy_with_manifest "_ws/src/skill" "_ws/build/content/skill" "_ws/src/skill/docs/publish.manifest"
fi

# Fallback: copy main files if no manifest
if [ -f "_ws/src/skill/README.md" ]; then
  echo "Setting up landing page..."
  cp "_ws/src/skill/README.md" "_ws/build/content/index.md"
fi

if [ -f "_ws/src/skill/SKILL.md" ]; then
  echo "Copying SKILL.md..."
  cp "_ws/src/skill/SKILL.md" "_ws/build/content/skill-guide.md"
fi

echo "Documentation preparation completed successfully"