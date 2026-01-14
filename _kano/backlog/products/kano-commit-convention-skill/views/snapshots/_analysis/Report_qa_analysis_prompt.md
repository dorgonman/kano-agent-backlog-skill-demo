# LLM Analysis Prompt (qa)

You are writing a short *analysis* section for a project status report.

**Persona focus**: qa (potential bugs, test ideas, verification checklist, and regression risks)

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

# QA Snapshot Report: product:kano-commit-convention-skill

**Scope:** product:kano-commit-convention-skill
**VCS:** branch=main, revno=92, hash=8d7bd8d9591d105c6ac45f2feb5e9b33c7b20beb, dirty=true, provider=git

## Testability & Evidence

Features that report "Done" status and their associated evidence.



## CLI Surface (Test Scope)
The following command structure is exposed in the CLI and requires testing:

**Root:** `kano` (Full CLI Help Output (Recursive parsing TODO))

_(Note: Recursive tree listing would go here in fully expanded report)_

## Health Check
Environment health status:

| Check | Passed | Message |
|-------|--------|---------|

| prerequisites | True | Python prerequisites check skipped (stub) |


---

## Instructions

Generate the analysis section based ONLY on the report above. Do not add facts not present in the report.
Output should be ready to paste into the Report_qa_LLM.md template.
