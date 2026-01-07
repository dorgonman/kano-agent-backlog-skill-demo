---
id: KABSD-TSK-0113
uid: 019b980d-d557-7575-9cac-f3e1d5ed4e86
type: Task
title: "Evaluate Docker packaging and runtime split (server vs data)"
state: Proposed
priority: P2
parent: KABSD-FTR-0018
area: infrastructure
iteration: null
tags: ["cloud", "docker", "deployment"]
created: 2026-01-07
updated: 2026-01-07
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
---

# Context

If we want a repeatable “cloud acceleration” environment, Docker (and likely docker compose) becomes the default distribution mechanism. At the same time, we must keep the server runtime separable from the data it operates on:

- Server container image should be disposable.
- Data should live in bind mounts / volumes or external DB services.
- The model must still support local-first operation and Git/files SSOT where applicable.

# Goal

- Define a minimal Docker/Compose layout for server mode.
- Define the server/data separation boundaries (what is inside the image vs mounted).
- Specify operational workflows: start/stop, config injection, logs, backups, and upgrades.

# Non-Goals

- A production-grade Kubernetes deployment.
- Full CI/CD automation.
- Hardening for public internet exposure.

# Approach

1. Draft a “compose-first” design that supports:
  - server container
  - optional DB service container (Postgres or MySQL) OR external DB
  - bind-mounted backlog root for file-first mode
2. Enumerate environment/config needs:
  - path to backlog root
  - DB connection settings
  - read-only vs read-write mode
3. Define upgrade/migration story:
  - schema migration hooks (leveraging the existing migration framework)
  - compatibility expectations across server versions
4. Identify pitfalls for Windows/macOS/Linux (file watch semantics, path mapping, permissions).

# Alternatives

- Run server directly on host (no containers) and use Docker only for DB.
- Package as a single binary/container that embeds both server and DB (less separation).

# Acceptance Criteria

- A proposed `docker compose` topology is described in this Task.
- A clear split is defined: image contents vs mounted/managed data.
- A documented “local dev” workflow exists (commands, env vars, expected ports).
- Upgrade/migration considerations are explicitly called out.

# Risks / Dependencies

- Cross-platform filesystem and permission differences can break mounts.
- File watchers in containers can be unreliable depending on host/FS.
- Network exposure implies auth/log redaction requirements.

# Worklog

2026-01-07 18:43 [agent=copilot] Created for containerization and operational workflow evaluation.
