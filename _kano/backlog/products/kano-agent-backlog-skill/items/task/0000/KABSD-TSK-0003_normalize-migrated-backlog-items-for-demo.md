---
id: KABSD-TSK-0003
uid: 019b8f52-9f56-7d82-b906-58ac048d6a39
type: Task
title: Normalize migrated backlog items for demo
state: Done
priority: P2
parent: KABSD-USR-0001
area: backlog
iteration: null
tags:
- cleanup
- backlog
- docs
created: 2026-01-04
updated: '2026-01-06'
owner: null
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

Backlog items were migrated from another project and still reference Quboto or
missing items. The demo needs consistent scope and links.

# Goal

Normalize the backlog so it reflects the kano-agent-backlog-skill demo and has
no stale links or unrelated project scope.

# Non-Goals

- Rebuild the entire Quboto backlog.
- Change historical Worklog entries (append-only).

# Approach

- Audit all items under `_kano/backlog/items/**`.
- Replace Quboto-specific text with demo-appropriate wording.
- Remove or stub links to missing items; keep only demo-relevant hierarchy.
- Update the Epic index to match the cleaned hierarchy.

# Links

- [[_kano/backlog/items/epic/0000/KABSD-EPIC-0001_kano-agent-backlog-skill-demo.md]]
- [[_kano/backlog/items/epic/0000/KABSD-EPIC-0001_kano-agent-backlog-skill-demo.index.md]]

# Alternatives

- Leave migrated items as-is and only create new demo items moving forward.

# Acceptance Criteria

- Demo-facing Epic/Feature/UserStory content no longer mentions Quboto (legacy notes retained).
- All wikilinks in Epic/Feature/UserStory resolve to existing files.
- The Epic index reflects the actual demo hierarchy.

# Risks / Dependencies

- Renaming files changes wikilinks and may require index updates.
# Worklog

2026-01-04 00:38 [agent=codex] Created task to normalize migrated backlog items for demo.
2026-01-04 00:41 [agent=codex] Started backlog rebuild; agent decides state transitions per repo rule.
2026-01-04 00:46 [agent=codex] Normalized demo backlog; Epic filename rename pending due to file lock.
2026-01-04 00:47 [agent=codex] Noted pending filename rename in acceptance criteria after lock issue.
2026-01-04 00:52 [agent=codex] Created new Epic/Index files with demo name; legacy filenames remain due to lock.
2026-01-04 00:57 [agent=codex] Clarified acceptance criteria wording for demo-facing items.
