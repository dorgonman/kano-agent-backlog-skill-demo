# Topic Notes: config-cache-effective-artifacts

## Overview

{Brief description of this topic's focus area}

## Related Items

{Notes about the items in this topic}

## Key Decisions

{Important decisions related to this topic}

## Open Questions

- {questions to resolve}
## Decision 2026-02-03
- Create two artifacts:
  - stable: project/product effective config (no topic/workset), written to project_root/.kano/cache/effective_backlog_config.toml
  - runtime: includes topic/workset/CLI overrides, written to project_root/.kano/cache/effective_runtime_backlog_config.toml
- Runtime artifact is written only when overrides are present; it overwrites the same file each run.
- Add metadata: source file paths + mtimes + merge inputs used (product/profile/topic/workset).
- Implement mtime-based cache for effective config merge.

