# Documentation Deployment Scripts

This directory contains scripts for building and deploying the official documentation website using Quartz static site generator and GitHub Pages.

## Architecture

### Workspace Structure

```
_ws/
├── src/           # Source repositories
│   ├── demo/      # Demo repo (current repo clone)
│   ├── quartz/    # Quartz v4.4.0 engine
│   └── skill/     # Skill repo source
├── build/         # Generated artifacts
│   ├── content/   # Prepared content for Quartz
│   └── public/    # Built static site
└── deploy/        # Deployment targets
    └── gh-pages/  # Skill repo gh-pages branch
```

### Pipeline Flow

```
Source Repos → Content Preparation → Quartz Build → Deployment
     ↓               ↓                    ↓            ↓
  _ws/src/    →  _ws/build/content  →  _ws/build/public  →  _ws/deploy/gh-pages
```

## Scripts Overview

| Script | Purpose | Dependencies |
|--------|---------|--------------|
| `01-setup-workspace.sh` | Clone repositories and setup workspace | Git |
| `02-prepare-content.sh` | Filter and prepare documentation content | 01 |
| `03-build-site.sh` | Build static site with Quartz | 02, Node.js 22 |
| `04-deploy-local.sh` | Deploy to local gh-pages branch | 03 |
| `05-push-remote.sh` | Push changes to remote GitHub | 04 |
| `build-and-deploy.sh` | **Main script** - runs all steps | All above |
| `build-and-deploy-ci.sh` | CI-only script for GitHub Actions | N/A |

## Usage

### Quick Start (Recommended)

```bash
# Run complete pipeline
./scripts/docs/build-and-deploy.sh
```

### Step-by-Step Execution

```bash
# 1. Setup workspace
./scripts/docs/01-setup-workspace.sh

# 2. Prepare content
./scripts/docs/02-prepare-content.sh

# 3. Build site
./scripts/docs/03-build-site.sh

# 4. Deploy locally
./scripts/docs/04-deploy-local.sh

# 5. Push to remote
./scripts/docs/05-push-remote.sh
```

### Cleanup

```bash
# Remove workspace
rm -rf _ws
```

## Content Filtering

Documentation content is filtered using `docs/publish.manifest` files:

```
# Core documentation
README.md
AGENTS.md
LICENSE

# Documentation directories
docs/**/*.md
docs/**/*.png

# Exclude patterns (prefix with !)
!docs/internal/
!docs/**/*-draft.md
```

## Prerequisites

- **Git**: For repository cloning
- **Node.js 22**: For Quartz build process
- **rsync**: For file synchronization
- **GitHub Access**: For pushing to remote repository

## GitHub Actions Integration

The CI pipeline uses `build-and-deploy-ci.sh` which:
1. Assumes workspace is already setup by GitHub Actions checkout steps
2. Combines build and deploy steps for automation
3. Automatically pushes to remote gh-pages branch

### Workflow Structure

```yaml
steps:
  - name: Checkout repos (Demo, Quartz, Skill, gh-pages)
  - name: Setup Node.js
  - name: Prepare content (02-prepare-content.sh)
  - name: Build and deploy (build-and-deploy-ci.sh)
```

## Troubleshooting

### Common Issues

**Workspace not found:**
```bash
Error: _ws directory not found
```
→ Run `01-setup-workspace.sh` first

**Content directory missing:**
```bash
Error: _ws/build/content directory not found
```
→ Run `02-prepare-content.sh` first

**Build artifacts missing:**
```bash
Error: _ws/build/public directory not found
```
→ Run `03-build-site.sh` first

**Git repository not found:**
```bash
Error: _ws/deploy/gh-pages git repository not found
```
→ Run `04-deploy-local.sh` first

### Debug Mode

Add debug output to any script:
```bash
set -x  # Enable debug mode
./scripts/docs/build-and-deploy.sh
```

## Configuration

### Repository URLs

Update repository URLs in `01-setup-workspace.sh`:
- Demo repo: Current repository (`.`)
- Quartz: `https://github.com/jackyzha0/quartz.git`
- Skill: `https://github.com/dorgonman/kano-agent-backlog-skill.git`

### Quartz Version

Pinned to `v4.4.0` for stability. Update in `01-setup-workspace.sh` if needed.

### Deployment Target

Site deploys to: `https://dorgonman.github.io/kano-agent-backlog-skill/`

## Development

### Local Testing

1. Run `build-and-deploy.sh` to build complete site
2. Serve locally: `cd _ws/build/public && python -m http.server 8000`
3. View at: `http://localhost:8000`

### Content Updates

1. Modify `docs/publish.manifest` to control published files
2. Update documentation in `docs/` directory
3. Run pipeline to rebuild and deploy

### Script Modifications

- All scripts use `REPO_ROOT` for consistent path resolution
- Paths are relative to repository root
- Error handling with `set -euo pipefail`
- Validation checks before each major operation

## Security Notes

- Scripts clone public repositories only
- No sensitive credentials in scripts
- GitHub token (`SKILL_REPO_TOKEN`) required for CI deployment
- Local scripts commit but don't auto-push (manual verification step)