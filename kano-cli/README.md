# kano-cli (MVP)

Minimal CLI facade over kano-backlog-core.

- Commands: `item read`, `state transition`, `worklog append`
- Output: plain (default) or `--format json`
- Local import fallback: automatically adds `kano-backlog-core/src` to PYTHONPATH if not installed

## Quick start

From repo root:

```bash
# Option A: run via module (no install)
python -m kano_cli.cli --help

# Example: read an item
python -m kano_cli.cli item read KABSD-FTR-0019 --format json

# Example: transition state (dry run is not implemented; this writes)
python -m kano_cli.cli state transition KABSD-TSK-0118 --action review --agent copilot --message "Reviewing"
```

