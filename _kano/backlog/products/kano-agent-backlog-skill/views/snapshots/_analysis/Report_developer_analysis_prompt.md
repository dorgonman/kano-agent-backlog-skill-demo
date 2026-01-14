# LLM Analysis Prompt (developer)

You are writing a short *analysis* section for a project status report.

**Persona focus**: developer (technical progress, blockers, concrete next steps, and verification commands)

## Strict rules

1) **ONLY use facts that appear in the provided report content.** Do not invent items, states, counts, or commands.
2) If information is missing, say "Unknown from the report" and suggest what to capture in backlog to make it known.
3) Output **MUST** be Markdown.
4) Keep it concise (max ~200 lines).

## Required sections

Use these exact headings:

### Key Observations
### Risks / Unknowns
### Recommendations (Actionable)

## Report content (SSOT)

---
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

---

## Instructions

Generate the analysis section based ONLY on the report above. Do not add facts not present in the report.
Output should be ready to paste into the Report_developer_LLM.md template.
