# kano-agent-backlog-skill-demo

A demonstration repository showcasing the **kano-agent-backlog-skill** - a local-first, file-based backlog management system designed for AI agent collaboration.

## Overview

This repository demonstrates how to use the `kano-agent-backlog-skill` to transform agent collaboration into a durable, auditable backlog system. Instead of losing context in chat conversations, all planning, decisions, and work items are persisted as structured markdown files with an optional SQLite index for querying.

## Key Features

- **Local-first backlog**: All work items stored as markdown files with frontmatter metadata
- **Hierarchical work items**: Epic → Feature → User Story → Task/Bug
- **Append-only worklog**: Auditable decision trail for each work item
- **Architecture Decision Records (ADRs)**: Capture significant technical decisions
- **Multiple views**: Obsidian Dataview dashboards and plain markdown reports
- **Multi-product support**: Organize backlogs for different products/projects

## Repository Structure

```
├── _kano/backlog/              # Main backlog directory (system of record)
│   ├── products/               # Product-specific backlogs
│   │   ├── kano-agent-backlog-skill/     # Demo backlog for the skill itself
│   │   └── kano-commit-convention-skill/ # Demo backlog for commit conventions
│   ├── views/                  # Generated dashboard views
│   ├── artifacts/              # Work artifacts and reports
│   └── tools/                  # Project-specific tools
├── skills/                     # Reusable skills (git submodules or local)
│   ├── kano-agent-backlog-skill/         # **SELF-CONTAINED** backlog skill
│   │   ├── src/                # All Python source code (unified)
│   │   │   ├── kano_backlog_core/   # Domain library
│   │   │   └── kano_cli/            # CLI facade
│   │   ├── scripts/            # Automation and tooling
│   │   ├── templates/          # Item and ADR templates
│   │   ├── references/         # Reference documentation
│   │   └── pyproject.toml      # Unified project config
│   └── kano-commit-convention-skill/
├── AGENTS.md                   # Guidelines for AI agents
└── CLAUDE.md                   # Quick reference for backlog workflow
```

## Skill Architecture: Self-Contained Design

As of Jan 2026, `kano-agent-backlog-skill` has been **consolidated into a self-contained package**:

- All source code (domain library + CLI) lives under `src/` 
- All dependencies are unified in `pyproject.toml`
- The entire `skills/kano-agent-backlog-skill/` directory can be copied to any project (or used as a git submodule)
- No external dependencies on `kano-backlog-core` or `kano-cli` projects

This follows the "Self-contained skill stance" principle defined in [AGENTS.md](AGENTS.md): keep all automation and tools needed to use the skill within the skill directory itself, avoiding scattered dependencies.

## Getting Started

### Prerequisites

- Python 3.8+ (for skill scripts)
- Git (for version control and submodules)
- Optional: Obsidian (for Dataview dashboards)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/dorgonman/kano-agent-backlog-skill-demo.git
   cd kano-agent-backlog-skill-demo
   ```

2. **Initialize submodules**:
   ```bash
   git submodule update --init --recursive
   ```

3. **Explore the backlog**:
   ```bash
   # View work items
   ls _kano/backlog/products/kano-agent-backlog-skill/items/
   
   # View generated dashboards
   cat _kano/backlog/views/Dashboard_PlainMarkdown_Active.md
   ```

## Backlog Workflow

Before making any code changes, agents should:

1. **Create/update backlog items** in `_kano/backlog/products/<product-name>/items/`
2. **Meet the Ready gate** for Tasks/Bugs (Context, Goal, Approach, Acceptance Criteria, Risks/Dependencies must be non-empty)
3. **Record decisions** in the append-only Worklog
4. **Link ADRs** when architectural trade-offs are made

### Using Skill Scripts

The skill provides scripts for backlog management:

```bash
# Create a new work item
python skills/kano-agent-backlog-skill/scripts/backlog/create_item.py \
  --agent <agent-name> --type task --title "Your task title"

# Update item state
python skills/kano-agent-backlog-skill/scripts/backlog/update_state.py \
  --agent <agent-name> --item-id KABSD-TSK-0001 --state InProgress

# Refresh dashboards
python skills/kano-agent-backlog-skill/scripts/backlog/refresh_dashboards.py \
  --agent <agent-name> --backlog-root _kano/backlog
```

## Backlog Discipline

This demo follows these principles:

- **English for all content**: Context, Goal, Approach, Worklog entries
- **Ready gate enforcement**: Tasks/Bugs must have all required fields before starting
- **Append-only Worklog**: Never rewrite history; append new entries
- **Controlled volume**: Only open items for actual code/design changes
- **Sized work items**: Tasks/Bugs should fit in one focused session
- **ADRs for trade-offs**: Only create ADRs when there's a real architectural decision

## Viewing the Backlog

### Plain Markdown Views

Generated views are in `_kano/backlog/views/`:

- `Dashboard_PlainMarkdown_Active.md` - New and InProgress work
- `Dashboard_PlainMarkdown_New.md` - New work items
- `Dashboard_PlainMarkdown_Done.md` - Completed work

### Obsidian Dataview (Optional)

If you use Obsidian:
1. Open this repository as a vault
2. Install the Dataview plugin
3. View dynamic dashboards in `_kano/backlog/views/`

## Work Item Types

- **Epic**: Large initiative spanning multiple features (e.g., "Milestone 0.0.1")
- **Feature**: Cohesive capability (e.g., "Local-first backlog system")
- **User Story**: User-facing functionality (e.g., "Plan before code")
- **Task**: Technical work item (e.g., "Add test script")
- **Bug**: Defect to be fixed

## Configuration

Backlog configuration is in `_kano/backlog/_config/` (product-specific) or `_kano/backlog/_shared/` (shared settings).

## Contributing

This is a demo repository. For contributions to the skill itself, please see the [kano-agent-backlog-skill](https://github.com/dorgonman/kano-agent-backlog-skill) repository.

## License

See the individual skill repositories for license information.

## Learn More

- **Skill Documentation**: `skills/kano-agent-backlog-skill/SKILL.md` (after initializing submodules)
- **Agent Guidelines**: [AGENTS.md](AGENTS.md)
- **Quick Reference**: [CLAUDE.md](CLAUDE.md)
- **Example Backlogs**: Explore `_kano/backlog/products/` for real-world examples

## Philosophy

This demo embodies a "backlog-first" approach where:
- Planning happens before coding
- Decisions are recorded and auditable
- Context is preserved in files, not lost in chat
- Human-readable markdown is the source of truth
- Optional indexes enable powerful queries without lock-in