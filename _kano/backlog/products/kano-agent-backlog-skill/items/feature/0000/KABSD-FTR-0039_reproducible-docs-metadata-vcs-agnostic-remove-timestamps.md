---
area: core
created: '2026-01-14'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0039
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P1
state: InProgress
tags: []
title: Reproducible docs metadata (VCS-agnostic; remove timestamps)
type: Feature
uid: 019bb820-d303-773d-8b56-c31e7d4d0746
updated: '2026-01-14'
---

# Context

Currently README / Summary / Views generation writes timestamps (e.g., generated_at = now()), causing:

- Content unchanged but still produces diff noise
- Difficult to claim "same repo state → same output" reproducibility
- When doing traceability / dispatcher evaluation later, document changes don't represent capability changes, which is misleading

Goal: Remove timestamps, use version control state (VCS state) metadata instead, with fields not tied to Git (since Git is just one implementation).

# Goal

- In --reproducible mode (or by default), completely avoid writing timestamps to content
- Use explicit VCS abstract fields to record version state: branch / revno / hash / dirty
- Same data state (same hash + same inputs) re-running generator -> consistent output (avoid non-deterministic fields)

# Non-Goals

- No cloud build number / CI auto-increment version numbers
- Don't require all environments to have VCS (when no VCS, honestly mark as unknown)

# Approach

## Proposed Metadata Spec (VCS-agnostic)

Add fixed-format metadata block to generated documents (recommend HTML comment so it doesn't affect rendering; fixed order):

```html
<!-- kano:build
vcs.provider: <string|unknown>
vcs.branch: <string|unknown>
vcs.revno: <string|unknown>
vcs.hash: <string|unknown>
vcs.dirty: <true|false|unknown>
-->
```

Field definitions (abstract concepts; avoid parsing/overloading):
- `vcs.provider`: Detected VCS type (e.g., git / p4 / svn / none / unknown)
- `vcs.branch`: Human context hint (mutable pointer; not used as identity)
  - Git: branch name or HEAD (detached)
  - Perforce: stream (or client/workspace) as you define
  - SVN: branch/path (e.g., relative URL)
- `vcs.revno`: Human-friendly revision number
  - Git: commit count on HEAD (monotonic-ish within the repo; not a tag)
  - Perforce: changelist number
  - SVN: revision number
- `vcs.hash`: Collision-resistant identity
  - Git: full commit hash
  - Perforce/SVN: derived stable hash (e.g., sha1 of server+revno / uuid+revno)
- `vcs.dirty`: Whether workspace is clean (true if uncommitted/unshelved/unadded changes; unknown if can't determine)

Core rule: Prohibit using timestamps as a fallback. No VCS means unknown; do not pretend to be deterministic.

## Implementation Architecture

1) **VCS Abstraction Layer**
   - Modules: `kano_backlog_ops/vcs.py` and `kano_backlog_core/vcs/*`
   - `VcsMeta` fields: provider, branch, revno, hash, dirty
   - Adapters/detection should be best-effort and never fail hard when tools are missing.

2) **Generators Unified VCS Meta Usage**
   - Replace all places writing `generated_at` with:
     - Get `VcsMeta`
     - Output block according to `--meta-mode`
     - `--reproducible` forces no timestamp

3) **Reproducibility Details**
   - metadata block field order fixed
   - newline/spacing fixed
   - don't write now/time/random in content

## CLI / Behavior Requirements

Add (or reuse) modes for all commands generating README/Summary/View:

- `--reproducible`: Prohibit writing runtime timestamp; if VCS unavailable output unknown (no time substitute)
- `--meta-mode [none|min|full]`:
  - `none`: Don't write metadata block
  - `min`: Write provider + branch + revno + hash + dirty
  - `full`: Same as `min` for now (reserved for future provider-specific expansions)

Default recommendations:
- Default no timestamps (equivalent to reproducible)
- Default meta-mode=min

# Alternatives

- Keep timestamps but add `--reproducible` flag: Would cause inconsistent default behavior
- Only support Git: Doesn't meet VCS-agnostic goal
- Use JSON metadata: HTML comment is less intrusive to markdown rendering

# Acceptance Criteria

- [ ] All README/Summary/View generation output contains no timestamps under --reproducible
- [ ] Output includes VCS-agnostic metadata block conforming to spec (vcs.* fields)
- [ ] VCS adapter abstraction layer exists (at least git + null; others best-effort)
- [ ] Tests:
  - [ ] Non-VCS environment: fields are unknown and no timestamp introduced
  - [ ] Git repo fixture: branch/revno/hash/dirty correctly populated
- [ ] Documentation updates (SKILL/README): Explain reproducible definition and metadata field semantics (don't mention Git-specific tags)
- [ ] Same repo hash re-running generation -> content has no meaningless diff
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
2026-01-14 02:05 [agent=developer] [model=unknown] Auto parent sync: child KABSD-TSK-0202 -> InProgress; parent -> InProgress.