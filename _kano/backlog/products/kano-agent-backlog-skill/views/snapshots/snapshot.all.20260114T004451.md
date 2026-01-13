# Snapshot Report: product:kano-agent-backlog-skill

**Timestamp:** 2026-01-14T00:44:51.853352
**Git SHA:** 9620a822e9420a251a441fbf7116f51f69c046d2

## Capabilities

- **backlog.Ops Layer Test Feature**: missing
- **backlog.DEPRECATED duplicate (do not use): kano-agent-backlog-dispatcher**: missing
- **backlog.Local-first backlog system**: done
- **backlog.Agent tool invocation audit logging system**: done
- **backlog.Self-contained skill bootstrap and automation**: done
- **backlog.Backlog config system and process profiles**: done
- **backlog.Verify agent compliance**: done
- **backlog.Conflict Prevention Mechanism**: missing
- **backlog.Optional DB index and embedding/RAG pipeline**: done
- **backlog.Identifier strategy and ID resolver (ADR-0003)**: missing
- **backlog.Backlog Artifact System**: done
- **backlog.Monorepo Platform Migration**: done
- **backlog.Multi-product platform intelligence and governance**: partial
- **backlog.Optional cloud acceleration (PostgreSQL/MySQL + FastAPI + OpenAPI/Swagger UI)**: missing
- **backlog.Maintain Git/files as the single source of truth and sync cloud cache**: missing
- **backlog.Coordination Layer: Claim/Lease for Multi-Agent**: missing
- **backlog.Traceability: Commit Refs → Worklog Backfill**: done
- **backlog.Server mode (MCP/HTTP) + Docker + data backend separation**: missing
- **backlog.Refactor: kano-backlog-core + CLI/Server/GUI facades**: done
- **backlog.Multi-agent collaboration modes (local single repo / local multi repo via worktree / remote)**: done
- **backlog.VCS merge workflows and conflict resolution (Git/SVN/Perforce)**: missing
- **backlog.Backlog Quality Linter (Agent Discipline)**: done
- **backlog.Graph-assisted RAG planning and minimal implementation**: missing
- **backlog.Global config layers and URI compilation**: missing
- **backlog.Unified CLI for All Backlog Operations**: done
- **backlog.DEPRECATED duplicate (layout migration): kano-agent-backlog-dispatcher**: missing
- **backlog.kano-agent-backlog-dispatcher: complexity-aware, bid-driven task routing layer**: missing
- **backlog.Refactor kano-agent-backlog-skill scripts into a single CLI entry + library modules**: done
- **backlog.Configurable persona packs (beyond developer/pm/qa)**: missing
- **backlog.Configurable persona packs (beyond developer/pm/qa)**: missing
- **backlog.Worklog run telemetry schema + instrumentation (tri-state tokens)**: missing
- **backlog.Dispatcher scoring + routing using worklog telemetry (capability vs observability)**: missing
- **backlog.Demo Feature: Local-First Backlog Ops**: missing
- **backlog.Rename CLI and Python Packages to Skill-Scoped Names**: done
- **backlog.Restructure Command Tree with Consistent Domain Naming**: done
- **backlog.Document Kano Namespace Reservation for Umbrella CLI**: done
- **backlog.Topic Lifecycle and Materials Buffer System**: done
- **backlog.Reproducible docs metadata (VCS-agnostic; remove timestamps)**: missing

## Stubs & TODOs

Found 14 items.
- [NotImplementedError] skills/kano-agent-backlog-skill/tests/test_snapshot.py:101 - oops')", encoding="utf-8
- [TODO] skills/kano-agent-backlog-skill/src/kano_backlog_ops/adr.py:183 - Implement
- [NotImplementedError] skills/kano-agent-backlog-skill/src/kano_backlog_ops/adr.py:184 - list_adrs not yet implemented
- [TODO] skills/kano-agent-backlog-skill/src/kano_backlog_ops/snapshot.py:249 - Integrate with doctor commands
- [TODO] skills/kano-agent-backlog-skill/src/kano_backlog_ops/workitem.py:333 - Implement parent sync
- [TODO] skills/kano-agent-backlog-skill/src/kano_backlog_ops/workitem.py:334 - Implement dashboard refresh
- [TODO] skills/kano-agent-backlog-skill/src/kano_backlog_ops/workitem.py:464 - Implement
- [NotImplementedError] skills/kano-agent-backlog-skill/src/kano_backlog_ops/workitem.py:465 - list_items not yet implemented
- [TODO] skills/kano-agent-backlog-skill/src/kano_backlog_ops/workitem.py:489 - Implement - currently delegates to workitem_resolve_ref.py
- [NotImplementedError] skills/kano-agent-backlog-skill/src/kano_backlog_ops/workitem.py:490 - get_item not yet implemented - use workitem_resolve_ref.py
- [NotImplementedError] skills/kano-agent-backlog-skill/src/kano_backlog_ops/workset.py:1266 - get_next_item renamed to get_next_action
- [NotImplementedError] skills/kano-agent-backlog-skill/src/kano_backlog_ops/workset.py:1271 - promote_item renamed to promote_deliverables
- [NotImplementedError] skills/kano-agent-backlog-skill/src/kano_backlog_cli/commands/config_cmd.py:53 - config export now requires explicit --out path
- [TODO] skills/kano-agent-backlog-skill/src/kano_backlog_cli/commands/snapshot.py:169 - recursive print

## Health Checks

- ✅ prerequisites: Python prerequisites check skipped (stub)

## CLI Surface

Command: kano
