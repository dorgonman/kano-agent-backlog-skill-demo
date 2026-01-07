---
id: KABSD-TSK-0124
uid: 019b8f52-9f4a-754d-8d3a-0124-research
type: Task
title: 'Research: Comparative Performance and Deployment of SQLite-Vec vs FAISS vs
  HNSWlib'
state: Proposed
priority: P3
parent: KABSD-USR-0015
area: research
iteration: 0.0.2
tags:
- embedding
- research
- benchmarking
created: 2026-01-07
updated: 2026-01-07
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks:
  - KABSD-TSK-0092@019b9473
  blocked_by: []
decisions:
- ADR-0009
---

# Context

We need to decide on the specific library for Route B (Sidecar) or verify if Route A (SQLite-vec) is viable for multi-platform local deployment.

# Goal

Evaluate the three routes (A, B, C) with small prototypes to confirm the best path for the Kano platform.

# Approach

1.  **Route A Prototype**: Attempt to load `sqlite-vec` in a Python environment on Windows and Linux. Document the "wheel" availability and load complexity.
2.  **Route B Prototype**: Test `hnswlib` vs `faiss-cpu`. Evaluate installation size and query speed for ~1000 items.
3.  **Cross-Platform Check**: Verify if these libraries require C++ compilers on the target machine or if pre-built binaries are reliable.
4.  **Philosophical Audit**: Confirm how "Derived Data Rebuild" works for each (e.g., how to incremental update a FAISS index).

# Acceptance Criteria

- A report (or update to ADR-0009) comparing the options based on real-world prototype results.
- Recommendation on the "Default" vector library for the project.

# Risks / Dependencies

- Native binary installs might fail in some restricted environments.

# Worklog

2026-01-07 23:10 [agent=antigravity] Created for comparative research as requested by user.
