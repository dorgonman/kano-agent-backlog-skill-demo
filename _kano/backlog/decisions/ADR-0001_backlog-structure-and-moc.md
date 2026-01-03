---
id: ADR-0001
title: "Backlog structure: per-type folders and Obsidian MOC"
status: Proposed
date: 2026-01-02
related_items: [KABSD-TSK-0001]
supersedes: null
superseded_by: null
---

# Decision

Adopt per-type folders for backlog items and use Obsidian-style MOC (manual links),
with Dataview as a supplemental auto list. Keep index files at the Epic level
only to reduce file count. Bucket items by ID range (per 100) under each type
to reduce large folder sizes.

# Context

The backlog system needs to be readable without heavy tooling and should render
clearly in Obsidian. DataviewJS was not reliable in the current setup.

# Links

- Related: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0001_project-backlog-skill|KABSD-TSK-0001 Create project-backlog skill]]

# Options Considered

1) Flat `items/` folder + DataviewJS-only index
2) Per-type folders + DataviewJS index
3) Per-type folders + manual MOC links + Dataview (non-JS) lists

# Pros / Cons

- Option 1: simple path; but JS rendering was unreliable.
- Option 2: clearer organization; still depends on DataviewJS.
- Option 3: stable MOC links (Graph-friendly) and optional Dataview lists; slightly more manual upkeep.

# Consequences

- Epic index files must be updated when items move or are renamed.
- Feature/UserStory rely on Epic MOC links instead of their own index files.
- Item files live under `_kano/backlog/items/<type>/<bucket>/` to avoid large directories.
- Graph view will reflect MOC link structure.

# Follow-ups

- Keep `skills/kano-agent-backlog-skill/SKILL.md` aligned with this structure.

