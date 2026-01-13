# Developer Snapshot Report: 

**Generated:** 2026-01-14T00:45:36.021188
**Git SHA:** 9620a822e9420a251a441fbf7116f51f69c046d2

## Implementation Status (Capabilities)

This section maps backlog features to their implementation evidence.

| Feature | Status | Evidence |
|---------|--------|----------|
 |
{{/each}}


## Technical Debt & Stubs

This section lists known incomplete implementations (TODOs, FIXMEs, NotImplementedError).

| Type | Location | Message | Ticket |
|------|----------|---------|--------|

| NotImplementedError | `skills/kano-agent-backlog-skill/tests/test_snapshot.py:101` | oops')", encoding="utf-8 |  |

| TODO | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/adr.py:183` | Implement |  |

| NotImplementedError | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/adr.py:184` | list_adrs not yet implemented |  |

| TODO | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/snapshot.py:249` | Integrate with doctor commands |  |

| TODO | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/workitem.py:333` | Implement parent sync |  |

| TODO | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/workitem.py:334` | Implement dashboard refresh |  |

| TODO | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/workitem.py:464` | Implement |  |

| NotImplementedError | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/workitem.py:465` | list_items not yet implemented |  |

| TODO | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/workitem.py:489` | Implement - currently delegates to workitem_resolve_ref.py |  |

| NotImplementedError | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/workitem.py:490` | get_item not yet implemented - use workitem_resolve_ref.py |  |

| NotImplementedError | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/workset.py:1266` | get_next_item renamed to get_next_action |  |

| NotImplementedError | `skills/kano-agent-backlog-skill/src/kano_backlog_ops/workset.py:1271` | promote_item renamed to promote_deliverables |  |

| NotImplementedError | `skills/kano-agent-backlog-skill/src/kano_backlog_cli/commands/config_cmd.py:53` | config export now requires explicit --out path |  |

| TODO | `skills/kano-agent-backlog-skill/src/kano_backlog_cli/commands/snapshot.py:169` | recursive print |  |


## CLI Surface

**Root Command:** kano

> [!NOTE]
> All status claims above are backed by repo evidence. `partial` status indicates presence of stubs or work-in-progress markers linked to the feature.
