---
type: Index
for: KABSD-EPIC-0001
title: "Kano Agent Backlog Skill Demo Index"
updated: 2026-01-04
---

# MOC

- [[KABSD-FTR-0001_local-backlog-system|KABSD-FTR-0001 Local-first backlog system]]
  - [[KABSD-USR-0001_plan-before-code|KABSD-USR-0001 Plan work before coding]]
    - [[_kano/backlog/items/tasks/0000/KABSD-TSK-0001_project-backlog-skill|KABSD-TSK-0001 Create project-backlog skill]]
    - [[_kano/backlog/items/tasks/0000/KABSD-TSK-0002_create-obsidian-base-demo-views|KABSD-TSK-0002 Create Obsidian Base demo views]]
    - [[_kano/backlog/items/tasks/0000/KABSD-TSK-0003_normalize-migrated-backlog-items-for-demo|KABSD-TSK-0003 Normalize migrated backlog items for demo]]
- [[KABSD-FTR-0002_agent-tool-invocation-audit-logging-system|KABSD-FTR-0002 Agent tool invocation audit logging system]]
  - [[KABSD-USR-0002_capture-tool-invocations-with-redaction-and-replayable-commands|KABSD-USR-0002 Capture tool invocations with redaction and replayable commands]]
    - [[_kano/backlog/items/tasks/0000/KABSD-TSK-0006_define-audit-log-schema-and-redaction-rules|KABSD-TSK-0006 Define audit log schema and redaction rules]]
    - [[_kano/backlog/items/tasks/0000/KABSD-TSK-0007_prototype-tool-invocation-logger-with-redaction|KABSD-TSK-0007 Prototype tool invocation logger with redaction]]
  - [[KABSD-USR-0003_log-storage-rotation-and-retention-policy|KABSD-USR-0003 Log storage, rotation, and retention policy]]
    - [[_kano/backlog/items/tasks/0000/KABSD-TSK-0008_implement-log-rotation-and-retention|KABSD-TSK-0008 Implement log rotation and retention]]

## Auto list (Dataview)

```dataview
table id, state, priority
from "_kano/backlog/items/features"
where parent = "KABSD-EPIC-0001"
sort priority asc
```

