---
id: KO-TSK-0005
uid: 019c0f2b-87bf-7387-ad2d-d35791d55326
type: Task
title: "Create unified OpenCode dependency management scripts"
state: Done
priority: P2
parent: null
area: general
iteration: backlog
tags: []
created: 2026-01-30
updated: 2026-01-30
owner: None
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
---

# Context

The kano-opencode-quickstart repository had separate scripts for installing dependencies (`prerequisite.sh`) and updating them (`update-opencode.sh`). These scripts had inconsistent naming, lacked a unified interface, and had several bugs that prevented proper updates to the latest versions.

# Goal

Create a unified family of dependency management scripts with consistent naming (`opencode-deps-*` prefix) that can:
1. Install OpenCode CLI, oh-my-opencode, and repo-local plugins
2. Update all components to their latest versions
3. Check current environment status
4. Support dry-run mode for previewing changes
5. Work correctly on both Unix/Linux/macOS and Windows platforms

# Non-Goals

- Managing dependencies for other projects (this is specific to kano-opencode-quickstart)
- Creating a general-purpose package manager
- Supporting version pinning or rollback functionality

# Approach

1. Create a core manager script (`opencode-deps-manager.sh` / `.ps1`) with three actions:
   - `install`: Install dependencies from package.json (first-time setup)
   - `update`: Update all dependencies to latest versions
   - `status`: Show current environment and versions

2. Create convenience wrapper scripts:
   - `opencode-deps-install.sh` / `.ps1`: Wrapper for install action
   - `opencode-deps-update.sh` / `.ps1`: Wrapper for update action

3. Use `"latest"` tag in `.opencode/package.json` for automatic updates:
   ```json
   {
     "dependencies": {
       "@opencode-ai/plugin": "latest"
     }
   }
   ```

4. Fix identified bugs:
   - Use `opencode-ai` package name instead of `opencode`
   - Use `bun install -g <package>@latest` instead of `bun update -g` to avoid caching issues
   - Ensure repo-local plugins update correctly with `bun update`

5. Update documentation (README.md, UPDATE.md, QUICKREF.md, MIGRATION.md)

# Alternatives

1. **Keep separate scripts**: Rejected - leads to inconsistent interfaces and harder maintenance
2. **Use fixed versions in package.json**: Rejected - requires manual version updates
3. **Use semver ranges (^)**: Rejected - may introduce unexpected changes; `latest` is simpler for a quickstart repo

# Acceptance Criteria

- [x] Core manager script supports install/update/status actions
- [x] Wrapper scripts provide convenient shortcuts
- [x] All scripts support --dry-run flag
- [x] Scripts work on both Unix and Windows platforms
- [x] OpenCode CLI updates correctly (using `opencode-ai` package name)
- [x] oh-my-opencode updates to latest version (3.1.8+)
- [x] Repo-local plugins update correctly
- [x] Documentation is complete and accurate
- [x] Migration guide provided for users of old scripts

# Risks / Dependencies

**Risks:**
- `bun update -g` caching issues may affect other global packages
- `"latest"` tag may introduce breaking changes in dependencies

**Dependencies:**
- Requires `bun` to be installed and on PATH
- Requires `opencode` CLI to be installed (for update operations)

**Mitigation:**
- Use `bun install -g <package>@latest` to bypass caching
- Provide dry-run mode to preview changes before applying
- Lock exact versions in bun.lock for reproducibility

# Worklog

2026-01-30 21:50 [agent=kiro] Created item
2026-01-30 22:00 [agent=kiro] [model=Claude Sonnet 4.5] Completed implementation with bug fixes

## Bugs Discovered and Fixed

### Bug 1: Incorrect Package Name for OpenCode CLI
**Issue**: Scripts used `bun update -g opencode` which resulted in 404 error
**Root Cause**: OpenCode's npm package name is `opencode-ai`, not `opencode`
**Fix**: Changed all references to use `opencode-ai`
**Files Modified**: All manager and update scripts

### Bug 2: bun update -g Caching Issue
**Issue**: `bun update -g oh-my-opencode` only updated to 2.14.0 instead of latest 3.1.8
**Root Cause**: `bun update -g` uses cached package metadata and doesn't fetch latest from npm registry
**Fix**: Changed to use `bun install -g <package>@latest` which forces fresh lookup
**Files Modified**: All manager and update scripts
**Verification**: oh-my-opencode successfully updated from 2.14.0 to 3.1.8

### Bug 3: Repo-local Plugin Version Pinning
**Issue**: `@opencode-ai/plugin` stayed at 1.1.34 even after running update script
**Root Cause**: package.json had fixed version `"1.1.34"` without semver range, so `bun update` didn't update it
**Initial Fix Attempt**: Used `bun add @opencode-ai/plugin@latest --exact` to force update
**Final Solution**: Changed package.json to use `"latest"` tag instead of specific version
**Rationale**: Simpler approach - `bun update` automatically fetches latest when package.json uses `"latest"`
**Files Modified**: 
- `.opencode/package.json`: Changed from `"1.1.34"` to `"latest"`
- All update scripts: Simplified to just run `bun update` (no extra `bun add` needed)

## Implementation Details

**Created Files:**
- `scripts/opencode-deps-manager.sh` - Core manager (Unix)
- `scripts/opencode-deps-install.sh` - Install wrapper (Unix)
- `scripts/opencode-deps-update.sh` - Update wrapper (Unix)
- `scripts/windows/opencode-deps-manager.ps1` - Core manager (Windows)
- `scripts/windows/opencode-deps-install.ps1` - Install wrapper (Windows)
- `scripts/windows/opencode-deps-update.ps1` - Update wrapper (Windows)
- `scripts/UPDATE.md` - Comprehensive usage guide
- `scripts/MIGRATION.md` - Migration guide from old scripts
- `scripts/QUICKREF.md` - Quick reference card

**Modified Files:**
- `README.md` - Updated dependency management section
- `.opencode/package.json` - Changed to use `"latest"` tag

**Preserved Files (for backward compatibility):**
- `scripts/prerequisite.sh` - Still functional
- `scripts/update-opencode.sh` - Still functional
- Windows equivalents

## Final Versions Achieved
- OpenCode CLI: 1.1.44 (updated from 1.1.34)
- oh-my-opencode: 3.1.8 (updated from 2.13.2)
- @opencode-ai/plugin: 1.1.44 (updated from 1.1.34)

## Key Design Decisions

1. **Use `"latest"` tag**: Simplest approach for a quickstart repo that should stay current
2. **Unified prefix**: All scripts use `opencode-deps-*` to indicate they're part of the same family
3. **Wrapper scripts**: Provide convenient shortcuts while keeping core logic in manager
4. **Dry-run support**: Allow users to preview changes before applying
5. **Backward compatibility**: Keep old scripts functional to avoid breaking existing workflows
2026-01-30 21:51 [agent=kiro] State -> Done.
