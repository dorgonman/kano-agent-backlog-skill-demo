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

## File Structure

### Main Scripts
| Script | Purpose | Dependencies |
|--------|---------|-------------|
| `01-setup-workspace.sh` | Clone repositories and setup workspace | Git |
| `02-prepare-content.sh` | Process YAML config and prepare content | 01 |
| `03-build-site.sh` | Build static site with Quartz | 02, Node.js 22 |
| `04-deploy-local.sh` | Deploy to local gh-pages branch | 03 |
| `05-push-remote.sh` | Push changes to remote GitHub | 04 |
| `build-and-deploy.sh` | **Main script** - runs all steps | All above |

### Configuration Files
| File | Purpose |
|------|---------|
| `config/build.json` | Build parameters (Quartz version, repos, deployment) |
| `config/quartz.config.ts` | Quartz theme and plugin configuration |
| `config/mkdocs.yml` | MkDocs API documentation preprocessing |
| `docs/publish.config.yml` | Content mapping and navigation structure |

### Helper Tools
| File | Purpose |
|------|---------|
| `help/process_yaml_config.py` | YAML configuration processor and index generator |

## Content Publishing System

### YAML-Based Configuration

Content publishing is now controlled by `docs/publish.config.yml` which defines:

```yaml
navigation:
  Demo:
    title: "Demo & Examples"
    items:
      - source: "README.md"
        target: "demo/index.md"
        title: "Demo Overview"
  
  ADR:
    title: "Architecture Decisions"
    items:
      - source: "_kano/backlog/products/*/decisions/**/*.md"
        target: "adr/"
        title_from_frontmatter: "title"
```

### GitHub Pages Compatibility

- **Flattened Structure**: Deep paths automatically flattened to avoid GitHub Pages routing issues
- **Navigation Indexes**: Auto-generated index pages for each content section
- **Direct Access**: All content accessible via clean URLs

## Usage

### Quick Start (Recommended)

```bash
# Run complete pipeline
./scripts/docs/build-and-deploy.sh
```

### CI Mode

```bash
# Skip workspace setup (for GitHub Actions)
./scripts/docs/build-and-deploy.sh --ci
```

### Step-by-Step Execution

```bash
# 1. Setup workspace
./scripts/docs/01-setup-workspace.sh

# 2. Prepare content with YAML config
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

## Prerequisites

- **Git**: For repository cloning
- **Node.js 22**: For Quartz build process
- **Python 3**: For YAML configuration processing
- **GitHub Access**: For pushing to remote repository

## Configuration

### Build Configuration (`config/build.json`)

```json
{
  "quartz": {
    "version": "v4.4.0",
    "repository": "https://github.com/jackyzha0/quartz.git"
  },
  "repositories": {
    "skill": "https://github.com/dorgonman/kano-agent-backlog-skill.git"
  },
  "deployment": {
    "site_url": "https://dorgonman.github.io/kano-agent-backlog-skill/",
    "branch": "gh-pages"
  }
}
```

### Content Mapping (`docs/publish.config.yml`)

Defines how source files map to website structure:
- **Navigation sections**: Demo, Skill, ADR, Examples, References
- **File mappings**: Source patterns to target paths
- **Index generation**: Automatic navigation page creation
- **GitHub Pages optimization**: Flattened URLs for compatibility

## GitHub Actions Integration

The CI pipeline uses `--ci` mode which:
1. Assumes workspace is already setup by GitHub Actions checkout steps
2. Uses explicit paths for all operations
3. Automatically pushes to remote gh-pages branch

### Workflow Structure

```yaml
steps:
  - name: Checkout repos (Demo, Quartz, Skill, gh-pages)
  - name: Setup Node.js
  - name: Build and deploy
    run: ./scripts/docs/build-and-deploy.sh --ci
```

## Troubleshooting

### Common Issues

**Workspace not found:**
```bash
Error: _ws directory not found
```
→ Run `01-setup-workspace.sh` first

**YAML config not found:**
```bash
Warning: Config docs/publish.config.yml not found
```
→ Ensure `docs/publish.config.yml` exists in demo repo

**Python dependencies:**
```bash
ModuleNotFoundError: No module named 'yaml'
```
→ Install PyYAML: `pip install PyYAML`

### Debug Mode

Add debug output to any script:
```bash
set -x  # Enable debug mode
./scripts/docs/build-and-deploy.sh
```

## Development

### Local Testing

1. Run `build-and-deploy.sh` to build complete site
2. Serve locally: `cd _ws/build/public && python -m http.server 8000`
3. View at: `http://localhost:8000`

### Content Updates

1. Modify `docs/publish.config.yml` to control published content
2. Update documentation in source repositories
3. Run pipeline to rebuild and deploy

### Adding New Content Sections

1. Add new navigation section to `docs/publish.config.yml`
2. Define source patterns and target paths
3. Run content preparation to generate indexes

## Security Notes

- Scripts clone public repositories only
- No sensitive credentials in scripts
- GitHub token required for CI deployment
- Local scripts commit but don't auto-push (manual verification step)