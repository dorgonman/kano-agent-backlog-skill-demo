# KABSD-FTR-0031 — Model Attribution Verification

Goal: verify that Markdown Worklog entries record `[model=VALUE]` deterministically, default to `[model=unknown]` when unavailable, and emit a warning when the model is not provided (do not guess).

Prereqs:
- Choose an agent id for the audit trail (replace `<AGENT>` below).
- Use product `kano-agent-backlog-skill`.

Steps (PowerShell):

1) Create a temporary Task and capture its id:

`python skills/kano-agent-backlog-skill/scripts/kano-backlog workitem create --product kano-agent-backlog-skill --type task --title "model tagging verification" --agent <AGENT> --format json`

2) Append a Worklog entry WITHOUT providing a model:

`python skills/kano-agent-backlog-skill/scripts/kano-backlog worklog append <NEW_ID> --product kano-agent-backlog-skill --agent <AGENT> --message "check default"`

Expected:
- CLI prints a warning about missing model.
- The new Worklog line includes `[model=unknown]`.

3) Append again WITH model via environment variable:

`$env:KANO_AGENT_MODEL='claude-sonnet-4.5'`
`python skills/kano-agent-backlog-skill/scripts/kano-backlog worklog append <NEW_ID> --product kano-agent-backlog-skill --agent <AGENT> --message "check env model"`

Expected:
- No missing-model warning.
- The new Worklog line includes `[model=claude-sonnet-4.5]`.

4) Update state WITH explicit `--model`:

`python skills/kano-agent-backlog-skill/scripts/kano-backlog workitem update-state <NEW_ID> --product kano-agent-backlog-skill --agent <AGENT> --state Done --model claude-sonnet-4.5`

Expected:
- The state-change Worklog line includes `[model=claude-sonnet-4.5]`.

5) Run a state transition WITH explicit `--model`:

`python skills/kano-agent-backlog-skill/scripts/kano-backlog state transition <NEW_ID> --product kano-agent-backlog-skill --agent <AGENT> --action block --model claude-sonnet-4.5`

Expected:
- The transition Worklog line includes `[model=claude-sonnet-4.5]`.

6) Cleanup (keep history, mark item Dropped):

`python skills/kano-agent-backlog-skill/scripts/kano-backlog workitem update-state <NEW_ID> --product kano-agent-backlog-skill --agent <AGENT> --state Dropped --model claude-sonnet-4.5`

