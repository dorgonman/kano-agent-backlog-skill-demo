<!-- kano:build
vcs.provider: git
vcs.revision: 19ae297c7c074aa739fdfd795fabecdf36c2211b
vcs.dirty: true
-->

# Developer Snapshot Report: repo

**Scope:** repo
**VCS Revision:** 19ae297c7c074aa739fdfd795fabecdf36c2211b (dirty=true, ref=main, provider=git, label=19ae297c)

## Implementation Status (Capabilities)

This section maps backlog features to their implementation evidence.

| Feature | Status | Evidence |
|---------|--------|----------|



## Technical Debt & Stubs

This section lists known incomplete implementations (TODOs, FIXMEs, NotImplementedError).

| Type | Location | Message | Ticket |
|------|----------|---------|--------|

| NotImplementedError | `skills/kano-agent-backlog-skill/tests/test_snapshot.py:135` | oops')", encoding="utf-8 |  |

| TODO | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/adr.py:183` | Implement |  |

| NotImplementedError | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/adr.py:184` | list_adrs not yet implemented |  |

| TODO | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/snapshot.py:257` | Integrate with doctor commands |  |

| NotImplementedError | `skills/kano-agent-backlog-skill/src/kano_backlog_cli/commands/config_cmd.py:53` | config export now requires explicit --out path |  |

| TODO | `skills/kano-agent-backlog-skill/src/kano_backlog_cli/commands/snapshot.py:198` | recursive print |  |


## CLI Surface

**Root Command:** kano

> [!NOTE]
> All status claims above are backed by repo evidence. `partial` status indicates presence of stubs or work-in-progress markers linked to the feature.
