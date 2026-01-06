# Dashboard

This folder can host multiple view styles over the same file-first backlog items.

## Plain Markdown (no plugins)

- `Dashboard_PlainMarkdown.md` (embeds the generated lists)
- Generated outputs: `Dashboard_PlainMarkdown_{Active,New,Done}.md`

Refresh generated dashboards:
# ToDo: Update this command to be product-aware
- `python skills/kano-agent-backlog-skill/scripts/backlog/view_refresh_dashboards.py --product test-verify-skill --agent <agent-name>`

## Optional: SQLite index

If `index.enabled=true` in `_config/config.json`, scripts can prefer SQLite for faster reads,
while Markdown files remain the source of truth.
