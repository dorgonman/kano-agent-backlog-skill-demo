# CLAUDE

<!-- kano-agent-backlog-skill:start -->
## Backlog workflow (kano-agent-backlog-skill)
- Skill entrypoint: `skills/kano-agent-backlog-skill/SKILL.md`
- Backlog root: `_kano/backlog_sandbox/_tmp_tests/guide_test_backlog`
- Before coding, create/update backlog items and meet the Ready gate.
- Worklog is append-only; record decisions and state changes.
- Prefer running the `kano` CLI so actions are auditable (and dashboards stay current):
  - `python skills/kano-agent-backlog-skill/scripts/kano backlog init --product <name> --agent <agent-name>`
  - `python skills/kano-agent-backlog-skill/scripts/kano item create|update-state ... --agent <agent-name> [--product <name>]`
  - `python skills/kano-agent-backlog-skill/scripts/kano view refresh --agent <agent-name> --product <name>`
- Dashboards auto-refresh after item changes by default (`views.auto_refresh=true`); use `--no-refresh` or set it to `false` if needed.
<!-- kano-agent-backlog-skill:end -->

