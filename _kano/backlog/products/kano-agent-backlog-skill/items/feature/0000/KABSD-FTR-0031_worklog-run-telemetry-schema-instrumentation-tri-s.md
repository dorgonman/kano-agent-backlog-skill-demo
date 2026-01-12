---
area: tooling
created: '2026-01-11'
decisions: []
external: {}
id: KABSD-FTR-0031
iteration: null
links:
  blocked_by: []
  blocks:
  - KABSD-FTR-0032
  relates:
  - KABSD-FTR-0027
owner: null
parent: KABSD-EPIC-0004
priority: P1
state: Proposed
tags:
- worklog
- telemetry
- schema
- instrumentation
- tokens
title: Worklog run telemetry schema + instrumentation (tri-state tokens)
type: Feature
uid: 019baa90-dcaa-7096-8200-d40a2f2f5aac
updated: '2026-01-13'
---

# Context

We need structured, append-only telemetry for each agent task attempt/run so we can do local analytics and drive future dispatch/routing decisions. Today we only have free-text Worklog lines and tool audit JSONL, but no stable schema capturing model/time/tokens/outcome/retry for each attempt.

Key constraints:
- Local-first only (no server telemetry service).
- Append-only (JSONL is preferred).
- Must support tri-state token accounting: actual | estimated | unknown.
- Deterministic output (stable fields/order) to support diffing and reproducible scoring.

# Goal

Add a minimal Worklog Run Telemetry schema and write-path instrumentation so every run can emit a structured telemetry entry that downstream tooling can aggregate.

# Non-Goals

- Do not implement dispatcher scoring/routing in this ticket (separate ticket).
- Do not implement any cloud/remote telemetry service or UI dashboard.
- Do not require LLM APIs; telemetry must work with unknown/estimated usage.

# Approach

Schema (JSON/JSONL):
1. Introduce a run telemetry record (append-only JSONL) with a versioned schema.
2. Required fields:
   - agent.model (required), agent.provider (optional)
   - run.attempt_id (required)
   - run.attempt_index (required)
   - run.retry_count.same_model (required)
   - run.retry_count.reroute (required)
   - run.elapsed_ms.wall (required)
   - run.tokens.source (required: actual|estimated|unknown)
   - run.outcome (required: done|blocked|redo)
   - run.outcome_reason (optional but recommended)
3. Token fields:
   - If source=actual: include prompt/completion/total.
   - If source=estimated: include estimated_total + tokenizer.
   - If source=unknown: no token totals required (must not fail).

Instrumentation (write points):
4. Add a single write path in the kano CLI (or runner layer) that emits a telemetry record at task end.
5. Support external injection (env/config/args): provider, model, tokens.actual (if available), attempt_id, attempt_index, retry metadata.
6. Time metrics: require elapsed_ms.wall; optionally include elapsed_ms.llm and elapsed_ms.tools when measurable.

Validation/tooling:
7. Add a minimal validator (CLI subcommand or script) to validate JSONL records against the schema.

# Alternatives

1. Embed telemetry as structured lines inside Markdown Worklog
   - Pros: single file per item
   - Cons: hard to aggregate; parsing is fragile

2. Store telemetry only in SQLite
   - Pros: queryable
   - Cons: harder to audit/diff; adds migration complexity

3. Rely on provider-specific logs
   - Pros: no new schema
   - Cons: not local-first portable; cannot guarantee availability

# Acceptance Criteria

- A single telemetry entry can be written deterministically (stable schema/field ordering).
- tokens.source supports actual|estimated|unknown; unknown never breaks the pipeline.
- When usage is available, write actual token counts; otherwise write estimated/unknown.
- A minimal validator exists to validate telemetry JSONL records.

# Risks / Dependencies

- Risk: schema churn breaks downstream aggregators. Mitigation: versioned schema + backward compatibility rules.
- Risk: estimated token counts are misleading. Mitigation: mark source explicitly; never mix into capability score.
- Risk: logging sensitive content. Mitigation: store metadata only (no prompts/responses).

# Worklog

2026-01-11 08:59 [agent=codex-cli] Created Ticket A from request: define run telemetry schema + instrumentation requirements.
2026-01-11 09:00 [agent=codex-cli] Linked dependencies: blocks KABSD-FTR-0032.
2026-01-13 01:55 [agent=codex-cli] [model=unknown] Update: Implemented model attribution in Markdown Worklog write paths (task KABSD-TSK-0189 is Done). CLI records [model=VALUE] and defaults to [model=unknown] with a warning when neither --model nor env KANO_AGENT_MODEL/KANO_MODEL is available (do not guess). Verification (creates a temp task and cleans up): (1) python skills/kano-agent-backlog-skill/scripts/kano-backlog workitem create --product kano-agent-backlog-skill --type task --title "model tagging verification" --agent AGENT_ID --format json (capture NEW_ID) (2) python skills/kano-agent-backlog-skill/scripts/kano-backlog worklog append NEW_ID --product kano-agent-backlog-skill --agent AGENT_ID --message "check default" (expect warning + [model=unknown]) (3) set KANO_AGENT_MODEL=claude-sonnet-4.5 then run (2) again (expect [model=claude-sonnet-4.5], no warning) (4) python skills/kano-agent-backlog-skill/scripts/kano-backlog workitem update-state NEW_ID --state Done --agent AGENT_ID --product kano-agent-backlog-skill (expect worklog line includes [model=...]) (5) python skills/kano-agent-backlog-skill/scripts/kano-backlog state transition NEW_ID --action block --agent AGENT_ID --product kano-agent-backlog-skill (expect worklog line includes [model=...]) (6) cleanup: python skills/kano-agent-backlog-skill/scripts/kano-backlog workitem update-state NEW_ID --state Dropped --agent AGENT_ID --product kano-agent-backlog-skill
2026-01-13 02:01 [agent=codex-cli] Artifact attached: [KABSD-FTR-0031_model-attribution-verification.md](..\..\..\..\..\_shared\artifacts\KABSD-FTR-0031\KABSD-FTR-0031_model-attribution-verification.md) — Moved model-attribution verification steps to a shared artifact (to keep Worklog concise).
2026-01-13 02:02 [agent=codex-cli] [model=gpt-5.2] Correction: canonical model-attribution verification steps moved to the attached shared artifact (see latest Worklog link); the prior long inline command block is superseded.