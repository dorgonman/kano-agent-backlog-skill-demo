---
area: tooling
created: '2026-01-14'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-BUG-0003
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P1
state: Done
tags:
- snapshot
- template
- report
title: Snapshot reports render raw template blocks (nested each/if/unless)
type: Bug
uid: 019bb860-07df-72d0-88c4-0a297107c1c5
updated: '2026-01-14'
---

# Context

Snapshot report outputs under `views/snapshots/` are currently not usable for demo because the generated Markdown contains raw template directives (Handlebars-style) instead of rendered content.

Examples (generated files):
- `views/snapshots/snapshot.report_developer.20260114T004523.md` contains `{{#each ...}}` blocks and prints whole dicts as strings.
- `views/snapshots/snapshot.report_pm.20260114T004527.md` leaves stray `{{/each}}` and empty sections.
- `views/snapshots/snapshot.report_qa.20260114T004531.md` leaves `{{#unless evidence_refs}}` unrendered.

Root cause:
- `kano_backlog_ops.template_engine.TemplateEngine` uses a naive regex that cannot handle nested `{{#each}}` blocks and does not implement `{{#unless}}`.
- Snapshot report templates also reference `{{scope}}`, but the render context only provides `meta.scope`.

# Goal

Snapshot report generation renders templates fully and deterministically (no raw `{{...}}` blocks), producing demo-ready Markdown for developer/pm/qa.

# Approach

1. Replace the regex-based loop rendering with a small parser that supports nested blocks for:
   - `{{#each <path>}} ... {{/each}}`
   - `{{#if <path>}} ... {{/if}}`
   - `{{#if (eq <path> "<literal>")}} ... {{/if}}`
   - `{{#unless <path>}} ... {{/unless}}`
2. Keep variable replacement and dot/bracket path access (`cli_tree.[0].name`).
3. Update snapshot report command to include `scope` at top-level in the template context (aliasing `meta.scope`).
4. Add unit tests for nested each + unless to prevent regressions.

# Acceptance Criteria

- Generated snapshot report Markdown contains no unresolved `{{#...}}` / `{{/...}}` blocks.
- Nested loops render correctly (capabilities -> evidence_refs).
- `unless` renders when list is empty.
- `{{scope}}` is populated for snapshot reports.
- Existing templates render without modification.

# Risks / Dependencies

- Risk: template engine changes could break existing templates. Mitigation: unit tests cover current templates + nested cases.

# Worklog

2026-01-14 01:20 [agent=codex-cli] Created item
2026-01-14 01:21 [agent=codex-cli] [model=gpt-5.2] State: Proposed → Ready: Ready: captured repro files, root cause (template engine nesting/unless), and deterministic acceptance criteria.
2026-01-14 01:21 [agent=codex-cli] [model=gpt-5.2] State: Ready → InProgress: Start: fix snapshot template rendering and regenerate demo snapshot reports.
2026-01-14 01:42 [agent=codex-cli] [model=gpt-5.2] State: InProgress → Done: Done: implemented nested block support (each/if/unless) in TemplateEngine, fixed snapshot report context for scope, regenerated demo snapshot report files, and added tests.