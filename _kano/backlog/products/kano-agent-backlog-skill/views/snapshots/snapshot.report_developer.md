<!-- kano:build
vcs.provider: git
vcs.branch: main
vcs.revno: 92
vcs.hash: 8d7bd8d9591d105c6ac45f2feb5e9b33c7b20beb
vcs.dirty: true
-->

# Developer Snapshot Report: repo

**Scope:** repo
**VCS:** branch=main, revno=92, hash=8d7bd8d9591d105c6ac45f2feb5e9b33c7b20beb, dirty=true, provider=git

## Implementation Status (Capabilities)

This section maps backlog features to their implementation evidence.

| Feature | Status | Evidence |
|---------|--------|----------|



## Technical Debt & Stubs

This section lists known incomplete implementations (TODOs, FIXMEs, NotImplementedError).

| Type | Location | Message | Ticket |
|------|----------|---------|--------|

| NotImplementedError | `skills/kano-agent-backlog-skill/tests/test_snapshot.py:136` | oops')", encoding="utf-8 |  |

| TODO | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/adr.py:183` | Implement |  |

| NotImplementedError | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/adr.py:184` | list_adrs not yet implemented |  |

| TODO | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/snapshot.py:265` | Integrate with doctor commands |  |

| NotImplementedError | `skills/kano-agent-backlog-skill/src/kano_backlog_cli/commands/config_cmd.py:53` | config export now requires explicit --out path |  |

| TODO | `skills/kano-agent-backlog-skill/src/kano_backlog_cli/commands/snapshot.py:200` | recursive print |  |


## CLI Surface

**Root Command:** kano

> [!NOTE]
> All status claims above are backed by repo evidence. `partial` status indicates presence of stubs or work-in-progress markers linked to the feature.
