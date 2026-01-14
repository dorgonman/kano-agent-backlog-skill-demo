# LLM Analysis Prompt (pm)

You are writing a short *analysis* section for a project status report.

**Persona focus**: pm (scope, risks, dependencies, prioritization signals, and decision points)

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

# Product Manager Snapshot Report: product:kano-commit-convention-skill

**Scope:** product:kano-commit-convention-skill
**VCS:** branch=main, revno=92, hash=8d7bd8d9591d105c6ac45f2feb5e9b33c7b20beb, dirty=true, provider=git

## Feature Delivery Status

Overview of feature implementation based on repository evidence.

### Done / In Review



### In Progress / Partial



### Not Started / Missing


## Known Risks (Stubs)
The following items have explicit code markers indicating incomplete work:



---

## Instructions

Generate the analysis section based ONLY on the report above. Do not add facts not present in the report.
Output should be ready to paste into the Report_pm_LLM.md template.
