# Dashboard (Obsidian Bases)

This is a plugin-free dashboard recipe using Obsidian **Bases** (core feature).

Goal: cover the same "table-style" dashboard use cases as Dataview, while keeping:
- Items in `_kano/backlog/items/**`
- Decisions in `_kano/backlog/decisions/**`
- Tree navigation via Epic `.index.md` MOC files + wikilinks (Bases is not a tree renderer)

## Prereqs

- Obsidian version that includes Bases.
- Your items use frontmatter fields like: `id`, `type`, `title`, `state`, `priority`, `parent`, `area`, `iteration`, `created`, `updated`.

## Recommended approach

Bases currently works best as "one Base per table". To mirror the Dataview Dashboard sections, create multiple Bases that all point to the same folder, but use different filters.

Common Base settings (for all sections):
- Source folder: `_kano/backlog/items`
- Columns: `id`, `type`, `title`, `state`, `priority`, `parent`, `area`, `iteration`, `updated`
- Default sorting: `priority` asc (or `created` asc for Epics)

### Base: Epics

Filter:
- `type` equals `Epic`
- `state` is not `Done`
- `state` is not `Dropped`

Sort:
- `created` asc

### Base: Features

Filter:
- `type` equals `Feature`
- `state` is not `Done`
- `state` is not `Dropped`

Sort:
- `priority` asc

### Base: UserStories

Filter:
- `type` equals `UserStory`
- `state` is not `Done`
- `state` is not `Dropped`

Sort:
- `priority` asc

### Base: Tasks + Bugs

Filter:
- `type` is one of `Task`, `Bug`
- `state` is not `Done`
- `state` is not `Dropped`

Sort:
- `type` asc, then `priority` asc

### Base: Ready + InProgress

Filter:
- `state` is one of `Ready`, `InProgress`

Sort:
- `type` asc, then `priority` asc

### Base: Blocked

Filter:
- `state` equals `Blocked`

Sort:
- `priority` asc

## Notes

- If you want a zero-UI, shareable artifact, use the generator:
  - `python _kano/backlog/tools/generate_view.py --groups "New,InProgress" --title "Active Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_Active.md`
- For hierarchy browsing, use the Epic MOC:
  - `_kano/backlog/items/epics/**/<ID>_<slug>.index.md`
