---
id: KCCS-USR-0017
uid: 019b98c3-6e3a-7f1c-8980-f4e03aa3f3f5
type: Story
title: "Multi-language support for linter messages"
state: Proposed
priority: P3
parent: KCCS-FTR-0002
area: general
iteration: null
tags: [i18n]
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
KCCS is used in international teams. Error messages should be translatable to support non-English developers or specific team cultures.

# Goal
Refactor `linter.py` to support multiple languages for validation error messages.

# Approach
- Create a `locales/` directory or a dictionary-based translation map.
- Support a `language` setting in `kcc.json`.
- Implement `en` (default) and `zh` (Chinese) translations.

# Acceptance Criteria
- [ ] Linter returns localized messages based on configuration.
- [ ] Users can add new languages via a simple JSON/dict map.

2026-01-08 13:25 [agent=antigravity] Created for Sprint 5 planning.
