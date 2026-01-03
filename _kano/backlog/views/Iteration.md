# Iteration View

```dataview
table id, type, state, priority
from "_kano/backlog/items"
where iteration != null and state != "Done" and state != "Dropped"
sort iteration asc, priority asc
```
