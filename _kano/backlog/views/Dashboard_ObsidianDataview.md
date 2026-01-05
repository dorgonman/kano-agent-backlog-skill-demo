# Dashboard (Obsidian Dataview)

This is the Dataview-based dashboard example. It requires the Obsidian Dataview plugin.

Done/Dropped items are hidden by default (view-level archive).

## Index-aware generated dashboards (optional)

If you maintain a SQLite index, prefer generating Markdown dashboards via skill scripts so they are
auditable and can fall back to file scan when the DB is missing/stale:

- `python skills/kano-agent-backlog-skill/scripts/backlog/refresh_dashboards.py --backlog-root _kano/backlog --agent <agent-name>`

In Obsidian, you can embed the generated dashboards:

- ![[Dashboard_PlainMarkdown_New.md]]
- ![[Dashboard_PlainMarkdown_Active.md]]
- ![[Dashboard_PlainMarkdown_Done.md]]

## Epics

```dataview
table id, state, priority, iteration
from "_kano/backlog/items"
where type = "Epic" and state != "Done" and state != "Dropped"
sort created asc
```

## Features

```dataview
table id, state, priority, parent
from "_kano/backlog/items"
where type = "Feature" and state != "Done" and state != "Dropped"
sort priority asc
```

## UserStories

```dataview
table id, state, priority, parent
from "_kano/backlog/items"
where type = "UserStory" and state != "Done" and state != "Dropped"
sort priority asc
```

## Tasks / Bugs

```dataview
table id, type, state, priority, parent
from "_kano/backlog/items"
where (type = "Task" or type = "Bug") and state != "Done" and state != "Dropped"
sort type asc, priority asc
```

## Ready / InProgress

```dataview
table id, type, state, priority, parent
from "_kano/backlog/items"
where state = "Ready" or state = "InProgress"
sort type asc, priority asc
```

## Blocked

```dataview
table id, type, state, priority, parent
from "_kano/backlog/items"
where state = "Blocked"
sort priority asc
```
