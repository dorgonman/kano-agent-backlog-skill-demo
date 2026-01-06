---
id: KABSD-FTR-0009
uid: 019b90cc-9aaa-71f9-805d-38e9f86be842
type: Feature
title: "Backlog Artifact System"
state: InProgress
priority: P2
parent: KABSD-EPIC-0001
area: infra
iteration: null
tags: []
created: 2026-01-06
updated: 2026-01-06
owner: antigravity
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

Agent needs a place to store collected files (web pages, images, PDFs) and generated artifacts (diagrams, code snippets) that are directly related to a backlog item.
Currently, items are flat Markdown files. We need a strategy for managing these associated binary/large files.

# Decision

**Use Centralized Artifact Root (Option B)**.

- **Root Path**: `_kano/backlog/artifacts/`
- **Structure**: `_kano/backlog/artifacts/<ItemID>/`
- **Example**: `_kano/backlog/artifacts/KABSD-FTR-0009/design-mockup.png`

**Rationale**:
- Keeps `items` directory focused on text/metadata.
- Allows separate Git Large File Storage (LFS) policy for `artifacts/`.
- Simplifies `.gitignore` rules.

# Approach

1. **Standardize Path**: All artifacts for a given item `ID` reside in `_kano/backlog/artifacts/<ID>/`.
2. **Helper Scripts**:
   - `attach_artifact.py`: Copy file to artifact folder and append link to item worklog/body.
   - `open_artifacts.py`: Open the artifact folder for an item.
3. **Link Format**: Use relative links in Markdown: `[Design](.../../../artifacts/KABSD-FTR-0009/design.png)` or define a sweet path alias if possible (complexity). For now, standard relative links.

# Alternatives

## Option A: Co-located Bundles (Rejected)
- Rejected to keep the primary backlog text-based and lightweight for git operations.

# Goal

Define a standard folder structure and naming convention for item artifacts.

# Worklog

2026-01-06 11:53 [agent=antigravity] Starting implementation of artifact system tasks.

2026-01-06 11:55 [agent=antigravity] Testing artifact attachment.
- Artifact: [test_artifact.txt](/_kano/backlog/artifacts/KABSD-FTR-0009/test_artifact.txt)
2026-01-06 11:59 [agent=antigravity] Retrying artifact attachment with relative path fix.
- Artifact: [test_artifact.txt](../../../artifacts/KABSD-FTR-0009/test_artifact.txt)
2026-01-06 12:14 [agent=antigravity] Configured Git LFS for artifacts directory.
