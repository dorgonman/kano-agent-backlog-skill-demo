---
id: KCCS-USR-0013
uid: 019b98c3-8a3a-7f1c-8980-f4e03aa3f3f7
type: Story
title: "Strict Validation for Breaking Change footer"
state: Proposed
priority: P2
parent: KCCS-FTR-0002
area: general
iteration: null
tags: [lint, strict]
created: 2026-01-08
updated: 2026-01-08
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
Currently, the linter only checks the first line. If a commit is marked as `[Breaking]`, it SHOULD contain a `BREAKING CHANGE:` section in the footer as per standard conventions (and KCC hints) to describe the impact.

# Goal
Enhance `linter.py` to optionally require a `BREAKING CHANGE:` footer if the subject contains the `[Breaking]` tag.

# Approach
- Parse the full commit message body.
- Look for the `BREAKING CHANGE:` or `BREAKING CHANGES:` footer.
- Return a descriptive error if missing.
- Add a configuration toggle `strict_breaking_check` in `kcc.json`.

# Acceptance Criteria
- [ ] Linter fails if `[Breaking]` is present but no footer description exists (when enabled).
- [ ] Linter passes if both are present.

2026-01-08 13:35 [agent=antigravity] Created for Sprint 6 planning.
