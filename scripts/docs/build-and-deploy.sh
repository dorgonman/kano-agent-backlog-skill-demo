#!/bin/bash
set -euo pipefail

# Main deployment script - runs all documentation deployment steps in sequence
# This script orchestrates the complete local documentation build and deployment process

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$REPO_ROOT"

echo "=== Documentation Deployment Pipeline ==="
echo "Repository root: $REPO_ROOT"
echo ""

# Step 1: Setup workspace
echo "Step 1: Setting up workspace..."
"$SCRIPT_DIR/01-setup-workspace.sh"
echo ""

# Step 2: Prepare content
echo "Step 2: Preparing documentation content..."
"$SCRIPT_DIR/02-prepare-content.sh"
echo ""

# Step 3: Build site
echo "Step 3: Building Quartz site..."
"$SCRIPT_DIR/03-build-site.sh"
echo ""

# Step 4: Deploy locally
echo "Step 4: Deploying to local gh-pages branch..."
"$SCRIPT_DIR/04-deploy-local.sh"
echo ""

# Step 5: Push to remote
echo "Step 5: Pushing to remote gh-pages branch..."
"$SCRIPT_DIR/05-push-remote.sh"
echo ""

echo "=== Deployment Complete ==="
echo ""
echo "Documentation site deployed successfully!"
echo "Site URL: https://dorgonman.github.io/kano-agent-backlog-skill/"
echo ""
echo "To clean up workspace: rm -rf _ws"