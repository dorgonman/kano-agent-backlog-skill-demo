---
id: KABSD-FTR-0039
uid: 019bb820-d303-773d-8b56-c31e7d4d0746
type: Feature
title: "Reproducible docs metadata (VCS-agnostic; remove timestamps)"
state: Proposed
priority: P1
parent: null
area: core
iteration: backlog
tags: []
created: 2026-01-14
updated: 2026-01-14
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

Currently README / Summary / Views generation writes timestamps (e.g., generated_at = now()), causing:

- Content unchanged but still produces diff noise
- Difficult to claim "same repo state → same output" reproducibility
- When doing traceability / dispatcher evaluation later, document changes don't represent capability changes, which is misleading

Goal: Remove timestamps, use version control state (VCS state) metadata instead, with fields not tied to Git (since Git is just one implementation).

# Goal

- In --reproducible mode (or by default), completely avoid writing timestamps to content
- Use VCS abstract fields to record output corresponding version state: revision / ref / dirty / optional label
- Same data state (same revision + same input) re-running generator → consistent output (avoid non-deterministic fields)

# Non-Goals

- No cloud build number / CI auto-increment version numbers
- Don't require all environments to have VCS (when no VCS, honestly mark as unknown)

# Approach

## Proposed Metadata Spec (VCS-agnostic)

Add fixed-format metadata block to generated documents (recommend HTML comment, doesn't affect rendering; fixed order):

```html
<!-- kano:build
vcs.provider: <string|unknown>
vcs.revision: <string|unknown>
vcs.ref: <string|unknown>
vcs.label: <string|optional>
vcs.dirty: <true|false|unknown>
-->
```

Field definitions (abstract concepts):
- `vcs.provider`: Currently detected VCS type (e.g., git / p4 / svn / none / unknown)
- `vcs.revision`: canonical identity (value that can uniquely locate version state)
  - Git: commit hash
  - Perforce: changelist number (or changeset id)
  - SVN: revision number
- `vcs.ref`: Human context hint (mutable pointer, not used as identity)
  - Git: branch name or HEAD (detached)
  - Perforce: stream/client/workspace (as you define)
  - SVN: branch path
- `vcs.label`: Optional readable label (e.g., tag/describe/version name)
  - Git: describe (tag-based)
  - P4: label / changelist annotation (if any)
- `vcs.dirty`: Whether workspace is clean (true if uncommitted/unshelved/unadded changes; unknown if can't determine)

Core rule: Prohibit using timestamp as fallback. No VCS means unknown, don't pretend to be deterministic.

## Implementation Architecture

1) **VCS Abstraction Layer**
   - New module: `kano_backlog_core/vcs/` (or `kano_backlog_ops/vcs/`)
   - `base.py`: `class VcsAdapter(Protocol)` with `detect(repo_root) -> bool` and `get_metadata(repo_root) -> VcsMeta`
   - `git_adapter.py` (implement Git first, others on roadmap)
   - `null_adapter.py` (no VCS / unknown)
   - `VcsMeta` (dataclass) fields corresponding to spec: provider, revision, ref, label, dirty

2) **Generators Unified VCS Meta Usage**
   - Replace all places writing `generated_at` with:
     - Get VcsMeta from VcsAdapter
     - Output block according to `--meta-mode`
     - `--reproducible` forces no timestamp

3) **Reproducibility Details**
   - metadata block field order fixed
   - value format fixed (e.g., revision allows shortening but fixed length; or always full)
   - newline/spacing fixed
   - don't write now/time/random in content

## CLI / Behavior Requirements

Add (or reuse) modes for all commands generating README/Summary/View:

- `--reproducible`: Prohibit writing runtime timestamp, metadata block only allows above VCS fields, if VCS unavailable: output unknown, don't substitute with time
- `--meta-mode [none|min|full]` (optional but recommended):
  - `none`: Don't write metadata block
  - `min`: Only write vcs.revision + vcs.dirty + vcs.provider
  - `full`: Write all fields (revision/ref/label/dirty/provider)

Default recommendations:
- Default no timestamps (equivalent to reproducible)
- Default meta-mode=min (less noise but still traceable)

# Alternatives

- Keep timestamps but add `--reproducible` flag: Would cause inconsistent default behavior
- Only support Git: Doesn't meet VCS-agnostic goal
- Use JSON metadata: HTML comment is less intrusive to markdown rendering

# Acceptance Criteria

- [ ] All README/Summary/View generation output contains no timestamps under --reproducible
- [ ] Output includes VCS-agnostic metadata block conforming to spec (vcs.* fields)
- [ ] New VCS adapter abstraction layer (at least git + null)
- [ ] Tests:
  - [ ] Non-VCS environment: fields are unknown and no timestamp introduced
  - [ ] Git repo fixture: revision/ref/dirty correctly populated
- [ ] Documentation updates (SKILL/README): Explain reproducible definition and metadata field semantics (don't mention Git-specific fields)
- [ ] Same repo revision re-running generation → content has no meaningless diff
- [ ] metadata not tied to Git, extensible to P4/SVN
- [ ] When no VCS, honestly output unknown, don't sneak in timestamps

# Risks / Dependencies

- **Refactoring scope**: Need to refactor all existing generator code that writes timestamps
- **VCS abstraction design**: VCS abstraction layer design needs to consider future extensibility
- **Test coverage**: Testing coverage needs to include multiple VCS states (clean/dirty, different providers)
- **Edge cases**: Handling edge cases like shallow repos, detached HEAD, corrupted VCS state
- **Backward compatibility**: Existing tools/scripts that depend on timestamp fields may break
- **Performance**: VCS metadata detection might add overhead to generation commands
- **Cross-platform**: Git command execution and path handling across different OS
- **Dependencies**: May need to add VCS client dependencies or handle missing VCS tools gracefully

# Worklog

2026-01-14 00:11 [agent=developer] Created item
