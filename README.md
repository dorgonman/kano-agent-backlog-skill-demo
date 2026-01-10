# kano-agent-backlog-skill-demo

⚠️ **PRE-ALPHA SOFTWARE - EXPERIMENTAL STAGE** ⚠️

This is a **pre-alpha demonstration** of the **kano-agent-backlog-skill** - an experimental local-first, file-based backlog management system for AI agent collaboration.

**IMPORTANT DISCLAIMERS:**
- 🚧 **Rapid Development**: System architecture is changing frequently
- ⚡ **Breaking Changes**: APIs, file formats, and workflows may change without notice
- 🔬 **Experimental**: Many features are incomplete or unstable
- ❌ **No Guarantees**: No stability, compatibility, or support guarantees
- 📝 **Documentation Lag**: Documentation may not reflect current implementation

## Overview

**Current Status: Pre-Alpha Experimentation**

This repository demonstrates an evolving approach to transform agent collaboration into a durable, auditable backlog system. The core concept is to persist planning, decisions, and work items as structured markdown files rather than losing context in chat conversations.

**What's Working (Subject to Change):**
- Basic markdown-based work item storage
- Simple CLI scripts for item creation
- Plain markdown dashboard generation

**What's Unstable/Incomplete:**
- File formats and schemas
- CLI interfaces and commands
- Configuration system
- Integration workflows
- Documentation accuracy

## Key Features

- **Local-first backlog**: All work items stored as markdown files with frontmatter metadata
- **Hierarchical work items**: Epic → Feature → User Story → Task/Bug
- **Append-only worklog**: Auditable decision trail for each work item
- **Architecture Decision Records (ADRs)**: Capture significant technical decisions
- **Multiple views**: Obsidian Dataview dashboards and plain markdown reports
- **Multi-product support**: Organize backlogs for different products/projects
- **🚧 WIP: Optional SQLite index** - Fast queries while keeping files as source of truth
- **🚧 WIP: Embedding search** - Local semantic search for backlog items (experimental)

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

## Getting Started (Experimental)

⚠️ **WARNING**: This is designed for AI agent automation, not manual operation.

### Prerequisites

- AI agent with file system access (Claude, ChatGPT, etc.)
- Python 3.10+ (required by `skills/kano-agent-backlog-skill/pyproject.toml`)
- Git (for version control)
- **Patience**: Expect things to break or change

### Prerequisite install (recommended)

To avoid wasting tokens on ad-hoc installs when a script fails, run the repo bootstrap installer once:

```powershell
python skills/kano-agent-backlog-skill/scripts/bootstrap/install_prereqs.py
```

Optional (heavy / platform-dependent) embedding search deps:

```powershell
python skills/kano-agent-backlog-skill/scripts/bootstrap/install_prereqs.py --with-embeddings
```

### Agent-First Setup

**Instead of manual installation, ask your AI agent to:**

```
"Please help me set up the kano-agent-backlog-skill demo. Clone the repo, 
initialize the backlog structure, and show me what work items exist."
```

**The agent should automatically:**
1. Clone the repository
2. Initialize submodules if needed
3. Explore the backlog structure
4. Show you available work items
5. Generate current dashboard views

**If something breaks, just ask:**
```
"The backlog setup failed. Please check what went wrong and fix it."
```

## Agent Workflow (Chat-Driven)

**This system is designed for conversational agent interaction, not manual commands.**

### Starting a New Work Session

**Ask your agent:**
```
"Please check the backlog and pick a ready task for me to work on. 
Create the work item if needed and start working on it."
```

**The agent should:**
1. Scan available work items
2. Find or create a suitable task
3. Update the item to "InProgress"
4. Begin implementation
5. Log decisions in the worklog

### Creating New Work Items

**Instead of manual scripts, just say:**
```
"I need to add a new feature for user authentication. 
Please create the appropriate backlog items and start planning."
```

**Or for bugs:**
```
"There's a bug in the login system - users can't reset passwords. 
Please create a bug item and investigate the issue."
```

### Checking Progress

**Ask for status updates:**
```
"Show me the current backlog status and what's in progress."
```

**Or:**
```
"What work items are ready to be picked up?"
```

### Completing Work

**When done:**
```
"I've finished the authentication feature. Please update the backlog 
and mark the work item as complete."
```

⚠️ **Note**: Script interfaces change frequently. Let the agent handle the technical details.

## Backlog Discipline

This demo follows these principles:

- **English for all content**: Context, Goal, Approach, Worklog entries
- **Ready gate enforcement**: Tasks/Bugs must have all required fields before starting
- **Append-only Worklog**: Never rewrite history; append new entries
- **Controlled volume**: Only open items for actual code/design changes
- **Sized work items**: Tasks/Bugs should fit in one focused session
- **ADRs for trade-offs**: Only create ADRs when there's a real architectural decision

## Viewing the Backlog

**Ask your agent to show you the current state:**

```
"Please show me the current backlog dashboard and highlight 
what needs attention."
```

**Or for specific views:**
```
"What work items are currently in progress?"
"Show me all completed work from this week."
"What new tasks are ready to be picked up?"
```

### Generated Views (Agent-Managed)

The agent automatically maintains views in `_kano/backlog/views/`:
- Active work dashboard
- New items queue  
- Completed work history

### Obsidian Integration (Optional)

**If you use Obsidian, ask:**
```
"Please set up this backlog for Obsidian Dataview integration."
```

## Work Item Types

- **Epic**: Large initiative spanning multiple features (e.g., "Milestone 0.0.1")
- **Feature**: Cohesive capability (e.g., "Local-first backlog system")
- **User Story**: User-facing functionality (e.g., "Plan before code")
- **Task**: Technical work item (e.g., "Add test script")
- **Bug**: Defect to be fixed

## Configuration

Backlog configuration is in `_kano/backlog/_config/` (product-specific) or `_kano/backlog/_shared/` (shared settings).

## Contributing (Pre-Alpha)

**Current Status**: This is an experimental demo repository in rapid development.

**Before Contributing:**
- Expect frequent breaking changes
- Check recent commits for current state
- Understand this is pre-alpha software
- No stability guarantees

**How to Contribute:**
1. Open issues for bugs/suggestions
2. Discuss major changes before implementing
3. Expect your contributions may be refactored heavily
4. Focus on core concepts rather than implementation details

For the main skill development, see [kano-agent-backlog-skill](https://github.com/dorgonman/kano-agent-backlog-skill) (also pre-alpha).

## License

See the individual skill repositories for license information.

## Learn More

- **Skill Documentation**: `skills/kano-agent-backlog-skill/SKILL.md` (after initializing submodules)
- **Agent Guidelines**: [AGENTS.md](AGENTS.md)
- **Quick Reference**: [CLAUDE.md](CLAUDE.md)
- **Example Backlogs**: Explore `_kano/backlog/products/` for real-world examples

## Philosophy (Evolving)

This experimental demo explores a "backlog-first" approach where:
- Planning happens before coding (when it works)
- Decisions are recorded and auditable (format changing)
- Context is preserved in files, not lost in chat (structure evolving)
- Human-readable markdown is the source of truth (schema unstable)
- Optional indexes enable powerful queries without lock-in (implementation changing)

**Note**: These principles are being tested and refined. Implementation may not always match the philosophy during this experimental phase.
