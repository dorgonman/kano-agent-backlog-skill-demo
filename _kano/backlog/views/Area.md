# Area View (Obsidian Dataview)

```dataview
table id, type, state, priority, iteration
from "_kano/backlog/items"
where area != null and state != "Done" and state != "Dropped"
group by area
```

