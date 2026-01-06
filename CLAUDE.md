# CLAUDE

<!-- kano-agent-backlog-skill:start -->
## Backlog workflow (kano-agent-backlog-skill)
- Skill entrypoint: `skills/kano-agent-backlog-skill/SKILL.md`
- Backlog root: `_kano/backlog`
- Before coding, create/update backlog items and meet the Ready gate.
- Worklog is append-only; record decisions and state changes.
- Prefer running the skill scripts so actions are auditable (and dashboards stay current):
  - `python skills/kano-agent-backlog-skill/scripts/backlog/create_item.py --agent <agent-name> ...`
  - `python skills/kano-agent-backlog-skill/scripts/backlog/update_state.py --agent <agent-name> ...`
  - `python skills/kano-agent-backlog-skill/scripts/backlog/refresh_dashboards.py --agent <agent-name> --backlog-root _kano/backlog`
<!-- kano-agent-backlog-skill:end -->
