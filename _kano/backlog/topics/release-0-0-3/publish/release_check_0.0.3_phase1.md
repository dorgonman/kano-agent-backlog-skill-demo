# Release Check (phase1)

- version: 0.0.3
- generated_at: 2026-02-03T14:22:22.950766Z
- result: FAIL

## Checks

- [FAIL] version:README: mismatch (expected=0.0.3, actual=0.0.2)
  details: D:\_work\_Kano\kano-agent-backlog-skill-demo\README.md
- [PASS] version:file:D:/_work/_Kano/kano-agent-backlog-skill-demo/skills/kano-agent-backlog-skill/VERSION: ok (0.0.3)
- [PASS] version:pyproject:D:/_work/_Kano/kano-agent-backlog-skill-demo/skills/kano-agent-backlog-skill/pyproject.toml: ok
- [PASS] changelog:D:/_work/_Kano/kano-agent-backlog-skill-demo/skills/kano-agent-backlog-skill/CHANGELOG.md: ok
- [PASS] 0.0.2:topic-templates: template engine + ops + CLI flags
  details: core=src/kano_backlog_core/template.py; ops=src/kano_backlog_ops/template.py; cli=src/kano_backlog_cli/commands/topic.py
- [PASS] 0.0.2:topic-cross-references: manifest.related_topics + add/remove results
  details: ops=src/kano_backlog_ops/topic.py
- [PASS] 0.0.2:topic-snapshots: snapshot models + restore result
  details: ops=src/kano_backlog_ops/topic.py
- [PASS] 0.0.2:topic-merge-split: merge/split + dry-run plan types
  details: ops=src/kano_backlog_ops/topic.py
- [PASS] 0.0.2:topic-distill-seed-item-rendering: human-readable seed listing + uid mapping comment
  details: ops=src/kano_backlog_ops/topic.py
- [PASS] 0.0.2:attach-artifact-product-layout: CLI flags + ops resolution candidate path
  details: cli=src/kano_backlog_cli/commands/workitem.py; ops=src/kano_backlog_ops/artifacts.py
