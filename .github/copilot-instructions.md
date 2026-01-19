# Copilot Commit Guidance

Backlog system: kano-backlog (not Jira). Never use `jira#` in commit messages.

- Use Kano backlog IDs directly (e.g., `KABSD-TSK-0146`, `KABSD-TSK-0147`).
- Do not add any `jira#` or `JIRA:` prefix — Jira is not used in this repo.
- Preferred commit title format:
  - `KABSD-TSK-0146: <short summary>`
  - Multiple items: `KABSD-TSK-0146 KABSD-TSK-0147: <short summary>`
- If no backlog ID applies, keep the subject concise and skip any external tracker markers.

Examples (good):
- `KABSD-TSK-0261: tighten topic slug max length`
- `KABSD-TSK-0261 KABSD-TSK-0257: shared state + filename policy`

Examples (bad — reject):
- `jira#KABSD-TSK-0261`
- `JIRA: KABSD-TSK-0261`
