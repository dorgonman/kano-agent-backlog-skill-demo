# Workset Evaluation Report

- Source item: `KABSD-TSK-0104`
- Date: 2026-01-07

## 1) What planning-with-files provides

Reference: https://github.com/OthmanAdi/planning-with-files/blob/master/planning-with-files/SKILL.md

### Concept: Working Memory on Disk

The idea is to keep short-term execution memory on disk so an agent can resume across sessions without drifting.

### 3-file pattern

| File | Purpose | Notes |
|------|---------|------|
| `task_plan.md` | checklist + execution steps | prevents drift |
| `notes.md` | research and findings | includes decisions |
| `deliverable.md` | draft output | promotes to final artifact |

### Strengths

- Lightweight: a few Markdown files
- Drift-resistant: forces the agent to re-read and update the plan
- Session-friendly: continues work without re-prompting everything

## 2) Kano backlog vs planning-with-files

### A) Workflow / governance

| Dimension | planning-with-files | Kano backlog |
|----------|----------------------|-------------|
| System of record | per-task files | canonical work items + ADRs |
| Hierarchy | none | Epic → Feature → UserStory → Task/Bug (process-dependent) |
| Decisions | embedded in notes | ADR + append-only Worklog |
| Enforcement | via skill prompt | Ready gate + scripts + audit logging |

### B) Data model

| Dimension | planning-with-files | Kano backlog |
|----------|----------------------|-------------|
| Storage | 3 Markdown files | YAML frontmatter + structured Markdown |
| Links | manual | `parent`, `links.blocks`, `links.blocked_by`, `decisions` |
| Index/search | none by default | optional SQLite/FTS/embeddings |

## 3) Gaps identified

Kano already covers:

- structured work items
- ADRs
- append-only Worklog
- scriptable automation + audit logs

But Kano benefits from an explicit execution cache:

- a lightweight checklist (`plan.md`)
- a place for research notes (`notes.md`)
- a draft deliverable area (`deliverables/`)

## 4) Proposal: Workset as a per-item local cache

### Requirements

- Workset is not the source of truth
- Git must ignore it
- Promotion back to canonical is explicit

### Suggested layout (per ADR-0011)

```text
_kano/backlog/.cache/worksets/<item-id>/
  meta.json
  plan.md
  notes.md
  deliverables/
```

### Promote rules

| Workset content | Promotion target |
|----------------|------------------|
| `Decision:` notes | ADR + item `decisions:` |
| progress / state | `workitem_update_state.py` + Worklog |
| `deliverables/*` | attachments/artifacts + Worklog summary |

## 5) Next steps

- Implement workset scripts: init / refresh / next / promote / cleanup
- Ensure directory layout is consistent across ADRs, docs, and script defaults
- Keep Workset derived and disposable (TTL cleanup)

---

End of report.
