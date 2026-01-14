<!-- kano:build
vcs.provider: git
vcs.branch: main
vcs.revno: 91
vcs.hash: c6e4b2fc0aa4a2f4a09c542c588d80978235eea8
vcs.dirty: true
-->

# Snapshot Report: product:kano-agent-backlog-skill

**Scope:** product:kano-agent-backlog-skill
**VCS Branch:** main
**VCS RevNo:** 91
**VCS Hash:** c6e4b2fc0aa4a2f4a09c542c588d80978235eea8
**VCS Dirty:** true

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
- **backlog.Repo Snapshot + Evidence-driven Reports**: done
- **backlog.Reproducible docs metadata (VCS-agnostic; remove timestamps)**: done

## Stubs & TODOs

Found 6 items.
- [NotImplementedError] tests/test_snapshot.py:136 - oops')", encoding="utf-8
- [TODO] src/kano_backlog_ops/adr.py:183 - Implement
- [NotImplementedError] src/kano_backlog_ops/adr.py:184 - list_adrs not yet implemented
- [TODO] src/kano_backlog_ops/snapshot.py:265 - Integrate with doctor commands
- [NotImplementedError] src/kano_backlog_cli/commands/config_cmd.py:53 - config export now requires explicit --out path
- [TODO] src/kano_backlog_cli/commands/snapshot.py:200 - recursive print

## Health Checks

- ✅ prerequisites: Python prerequisites check skipped (stub)

## CLI Surface

Command: kano
