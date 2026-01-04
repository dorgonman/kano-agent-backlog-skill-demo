# Dashboard (Obsidian Dataview)

This is the Dataview-based dashboard example. It requires the Obsidian Dataview plugin.

Done/Dropped items are hidden by default except in the Done Work section.

## New Work

```dataview
table id, type, state, priority, parent
from "_kano/backlog/items"
where (state = "Proposed" or state = "Planned" or state = "Ready")
sort priority asc, updated desc
```

## InProgress Work

```dataview
table id, type, state, priority, parent
from "_kano/backlog/items"
where (state = "InProgress" or state = "Review" or state = "Blocked")
sort priority asc, updated desc
```

## Done Work

```dataview
table id, type, state, priority, parent
from "_kano/backlog/items"
where (state = "Done" or state = "Dropped")
sort updated desc
```

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
