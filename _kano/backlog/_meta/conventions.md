# Conventions

## File naming

- `<ID>_<slug>.md`
- Slug: ASCII, hyphen-separated
- IDs:
  - `KABSD-EPIC-`
  - `KABSD-FTR-`
  - `KABSD-USR-`
  - `KABSD-TSK-`
  - `KABSD-BUG-`
- Prefix derivation:
  - Source: `config/profile.env` -> `PROJECT_NAME`.
  - Split on non-alphanumeric separators and camel-case boundaries, take first letters.
  - If only one letter, use the first letter plus the next consonant (A/E/I/O/U skipped).
  - If still short, use the first two letters.
  - Uppercase the result (example: `kano-agent-backlog-skill-demo` -> `KABSD`).
- Store items by type under `_kano/backlog/items/<type>/<bucket>/`.
- Bucket names use the lower bound of each 100 range:
  - `0000`, `0100`, `0200`, ...
- For Epic, create an adjacent `<ID>_<slug>.index.md`.

## Worklog (append-only)

```
YYYY-MM-DD HH:MM [agent=<agent-id>] <message>
```

> **Important**: Always use your real agent identity (e.g. `antigravity`, `claude`), do not use `codex` unless that is your name.

## Obsidian links (recommended)

Frontmatter `parent` maintains hierarchy, but Obsidian needs wikilinks in the
body to build forward/back links and Graph edges. Use a simple `## Links`
section and list related items with `[[...]]`.

Example:

```
## Links
- Parent: [[_kano/backlog/items/userstories/0000/KABSD-USR-0001_plan-before-code|KABSD-USR-0001]]
- Relates: [[_kano/backlog/items/features/0000/KABSD-FTR-0001_local-backlog-system|KABSD-FTR-0001]]
- Decision: [[_kano/backlog/decisions/ADR-0001_backlog-structure-and-moc|ADR-0001]]
```

## Immutable fields

- `id`, `type`, `created` must not be changed after creation.

