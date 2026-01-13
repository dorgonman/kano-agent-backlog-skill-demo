---
id: KABSD-FTR-0037
uid: 019bb336-c221-7203-93e2-6e88b9ce7fa3
type: Feature
title: "Topic Lifecycle and Materials Buffer System"
state: Done
priority: P2
parent: null
area: topic
iteration: backlog
tags: []
created: 2026-01-13
updated: 2026-01-13
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

The backlog skill needs to address the issues of "frequent context switching within the same chat" and "scattered task exploration processes that cannot be fully captured in workitems".

Current implementation:
- **Topic** (`.cache/worksets/topics/<topic>/`): Used only for cross-item grouping + simple notes.
- **Workset** (`.cache/worksets/items/<ITEM_ID>/`): Per-item working memory.

Repositioning required:
- **Topic** should be a "dynamically generated buffer / filter (like a subtask, but not entering the ticketing system)".
- **Materials** (raw buffer) should be attached under Topic, collecting code snippets refs, links, extracts, logs.
- Merge the current per-item Workset concept into Topic materials.

Metaphor: Minions (collector agents) collect raw materials → Strategist (synthesizer) digests them into a brief → Once facts are established, write back to workitem/ADR.

# Goal

1. Reposition Topic as "task exploration buffer + distilled brief".
2. Add `materials/` under Topic as a raw data collection area.
3. Implement Topic Lifecycle: Collect → Distill → Publish → Close/Cleanup.
4. Support Snippet refs structure (reference-based priority to avoid massive copy-paste).
5. Merge existing per-item Workset into Topic materials.

# Non-Goals

- No coordinator/dispatcher (General mechanism).
- No cloud shared backend (HTTP/MCP/DB server).
- No graph RAG (can be combined later).

# Approach

## Directory Structure (Option B: New path, brief.md can be version controlled)

```
_kano/backlog/topics/<topic>/
  manifest.json          # topic definition and refs (items/docs/snippets refs)
  brief.md               # distilled briefing (shareable, write-back ready)
  materials/             # raw collected stuff (cache, not version controlled)
    clips/               # code snippet refs + optional cached text
    links/               # urls / notes
    extracts/            # extracted paragraphs
    logs/                # build logs / command outputs
  synthesis/             # optional intermediate drafts
  publish/               # prepared write-backs (patches)
```

## Snippet refs Format

```json
{
  "type": "snippet",
  "repo": "local",
  "revision": "abc123",
  "file": "src/config.py",
  "lines": [42, 58],
  "hash": "sha256:...",
  "cached_text": "..."
}
```

## Topic Lifecycle (3 Gates)

1. **Gate A: Collect** — Put raw data into materials/ with provenance.
2. **Gate B: Distill** — Generate brief.md (Facts, Unknowns, Proposed Actions, Decision Candidates).
3. **Gate C: Publish** — Produce deterministic patch to write back to workitem/ADR.

## Brief Template

```markdown
# Topic Brief: <name>
Generated: <timestamp>

## Facts
- [ ] <fact> — [source](ref)

## Unknowns / Risks
- [ ] <unknown>

## Proposed Actions
- [ ] <action> → <workitem ref or "new ticket needed">

## Decision Candidates
- [ ] <decision> → <ADR ref or draft>
```

## CLI Commands (MVP)

- `topic create <name>`
- `topic switch <name>`
- `topic add --item <ID> / --doc <path> / --snippet <ref>`
- `topic list / topic show <name>`
- `topic distill <name>` → Generate brief.md
- `topic publish <name>` → Generate patch + optional apply
- `topic close <name>`
- `topic cleanup --ttl-days N`

## Migration Strategy

- Existing per-item worksets in `.cache/worksets/items/` will be gradually migrated to topic materials.
- Existing `.cache/worksets/topics/` will migrate to `_kano/backlog/topics/`.

# Alternatives

- Option A: Keep using `.cache/worksets/topics/`, but brief.md cannot be version controlled.
- Do not merge Workset: Keep per-item independence, but concepts overlap and cause confusion.

# Acceptance Criteria

- [ ] Can locally create topic, collect materials, generate brief, write back patch, archive, and TTL cleanup.
- [ ] brief and publish patch outputs are deterministic (same input rules → same structure output).
- [ ] snippet refs format is fixed and can be referenced/traced.
- [ ] .gitignore/cache rules are clear: raw materials are not version controlled by default.
- [ ] Existing topic/workset tests still pass (or have corresponding migration).

# Risks / Dependencies

- Existing per-item workset CLI/ops need refactoring or deprecation.
- Need to decide rules for brief.md version control (auto vs manual).
- Snippet refs revision dependency on git; need fallback for non-git repos.

# Worklog

2026-01-13 01:17 [agent=copilot] Created item
2026-01-13 01:18 [agent=copilot] Filled Ready gate: Context, Goal, Approach, Acceptance Criteria, Risks
2026-01-13 02:05 [agent=antigravity] Update state to Done. Verified implementation in `kano_backlog_cli.commands.topic` and `kano_backlog_ops.topic`.
2026-01-13 01:18 [agent=copilot] Filled Ready gate: Context, Goal, Approach, Acceptance Criteria, Risks
