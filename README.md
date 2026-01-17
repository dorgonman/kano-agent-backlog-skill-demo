# kano-agent-backlog-skill-demo

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![AI Agent Skills](https://img.shields.io/badge/AI-Agent%20Skills-brightgreen.svg)](https://github.com/topics/ai-agent)
[![Multi-Agent](https://img.shields.io/badge/Multi--Agent-Collaboration-orange.svg)](https://github.com/topics/multi-agent)

> **AI Agent Skills** for **Spec-Driven Agentic Programming** | File-based backlog management | Multi-agent collaboration | Local-first architecture

⚠️ **VERSION 0.0.1 - INITIAL RELEASE** ⚠️

This is the **initial 0.0.1 release** of the **kano-agent-backlog-skill-demo** - an experimental local-first, file-based backlog management system for AI agent collaboration.

**IMPORTANT DISCLAIMERS:**
- 🚧 **Rapid Development**: System architecture is changing frequently
- ⚡ **Breaking Changes**: APIs, file formats, and workflows may change without notice
- 🔬 **Experimental**: Many features are incomplete or unstable
- ❌ **No Guarantees**: No stability, compatibility, or support guarantees
- 📝 **Documentation Lag**: Documentation may not reflect current implementation

**What's New in 0.0.1:**
- ✅ Core backlog item management (Epic, Feature, UserStory, Task, Bug)
- ✅ Workset execution cache for per-item context
- ✅ Topic-based context switching and grouping
- ✅ Code snippet collection in topic materials
- ✅ Deterministic brief generation from materials
- ✅ ADR (Architecture Decision Record) support
- ✅ Multi-agent coordination (Canonical + Adapters architecture)
- ✅ Native support for Copilot, Codex, Claude, and Goose
- ✅ CLI commands for all core operations
- ✅ Property-based testing with Hypothesis
- 🚧 SQLite indexing (experimental)
- 🚧 Embedding search (experimental)

## Overview

**Current Status: Version 0.0.1 - Initial Release**

This repository demonstrates an evolving approach to transform agent collaboration into a durable, auditable backlog system. The core concept is to persist planning, decisions, and work items as structured markdown files rather than losing context in chat conversations.

**What's Working in 0.0.1:**
- ✅ Markdown-based work item storage with frontmatter metadata
- ✅ CLI scripts for item creation, state transitions, and worklog management
- ✅ Workset execution cache for per-item context isolation
- ✅ Topic-based context switching with code snippet collection
- ✅ Deterministic brief generation from collected materials
- ✅ Plain markdown and Obsidian Dataview dashboard generation
- ✅ Multi-agent coordination through shared backlog
- ✅ ADR (Architecture Decision Record) workflow
- ✅ Property-based testing with Hypothesis

**What's Unstable/Incomplete:**
- ⚠️ File formats and schemas (may change)
- ⚠️ CLI interfaces and commands (evolving)
- ⚠️ Configuration system (in flux)
- ⚠️ SQLite indexing (experimental)
- ⚠️ Embedding search (experimental)
- ⚠️ Documentation accuracy (catching up)

## Key Features

- **Local-first backlog**: All work items stored as markdown files with frontmatter metadata
- **Hierarchical work items**: Epic → Feature → User Story → Task/Bug
- **Append-only worklog**: Auditable decision trail for each work item
- **Architecture Decision Records (ADRs)**: Capture significant technical decisions
- **Workset execution cache**: Per-item working context with plan, notes, and deliverables to prevent agent drift
- **Topic-based context switching**: Group related items and documents for rapid focus area changes
- **Code snippet collection**: Capture and organize code references in topic materials
- **Deterministic distillation**: Generate briefs from collected materials for consistent context loading
- **Multiple views**: Obsidian Dataview dashboards and plain markdown reports
- **Multi-product support**: Organize backlogs for different products/projects
- **Multi-agent coordination**: Canonical + Adapters layout for shared backlog
- **Broad compatibility**: Support for Copilot, Codex, Claude, Goose, and Antigravity
- **🚧 WIP: Optional SQLite index** - Fast queries while keeping files as source of truth
- **🚧 WIP: Embedding search** - Local semantic search for backlog items (experimental)

## Repository Structure

```
├── _kano/backlog/              # Main backlog directory (system of record)
├── skills/                     # Canonical sources (git submodules or local)
│   ├── kano-agent-backlog-skill/         # **CANONICAL** (single source of truth)
│   └── kano-commit-convention-skill/
├── .github/skills/             # GitHub Copilot adapters
├── .codex/skills/              # OpenAI Codex adapters
├── .claude/skills/             # Anthropic Claude adapters
├── .goose/skills/              # Goose adapters
├── .agent/skills/              # Google Antigravity adapters
├── AGENTS.md                   # Universal guidelines and workflow rules
├── CLAUDE.md                   # Claude Code root adapter (points to AGENTS.md)
└── README.md                   # This file
```

## Multi-Agent Architecture: Canonical + Adapters

This repository uses a **"canonical source + adapters"** layout to maintain a single source of truth while supporting mission-critical directories for different agents.

- **Canonical Source**: Full documentation and logic stay in `skills/<skill-name>/SKILL.md`.
- **Adapters**: Lightweight "thin wrappers" exist in agent-specific folders (like `.github/skills/` or `.claude/skills/`) that point back to the canonical source via links or `@` references.
- **Universal Rules**: [AGENTS.md](AGENTS.md) defines project-wide workflow rules and discipline for all agents.
- **Entry Points**: 
  - **Claude Code**: Uses [CLAUDE.md](CLAUDE.md) as a root entrance to [AGENTS.md](AGENTS.md).
  - **Other Agents**: Use their respective `.folder/skills/` adapters.

*See [AGENTS.md](AGENTS.md) for detailed workflow enforcement rules.*

## Skill Architecture: Self-Contained Design

- All source code (domain library + CLI) lives under `src/` 
- All dependencies are unified in `pyproject.toml`
- The entire `skills/kano-agent-backlog-skill/` directory can be copied to any project (or used as a git submodule)
- No external dependencies on `kano-backlog-core` or `kano-cli` projects

This follows the "Self-contained skill stance" principle defined in [AGENTS.md](AGENTS.md): keep all automation and tools needed to use the skill within the skill directory itself, avoiding scattered dependencies.

## Getting Started (Experimental)

⚠️ **WARNING**: This is designed for AI agent automation, not manual operation.

### Prerequisites

- AI agent with file system access (Amazon Kiro, Claude, ChatGPT, Cursor, Windsurf, etc.)
- Python 3.10+ (required by `skills/kano-agent-backlog-skill/pyproject.toml`)
- Git (for version control and submodules)
- **Patience**: Expect things to break or change

### Quick Start

**1. Clone the repository:**
```bash
git clone https://github.com/dorgonman/kano-agent-backlog-skill-demo.git
cd kano-agent-backlog-skill-demo
```

**2. Initialize submodules:**
```bash
git submodule update --init --recursive
```

**3. Install the skill:**
```bash
python -m pip install -e skills/kano-agent-backlog-skill
```

**4. Verify installation:**
```bash
kano --help
```

**5. Explore the demo backlog:**
```bash
# List work items
kano item list --product kano-agent-backlog-skill

# View dashboard
kano view refresh --product kano-agent-backlog-skill --agent demo

# List topics
kano topic list

# List worksets
kano workset list
```

### Optional: Dev Dependencies

For development or embedding search features:
```bash
python -m pip install -e "skills/kano-agent-backlog-skill[dev]"
```

Note: FAISS and sentence-transformers may require platform-specific installation.

### Prerequisite install (recommended)

Install the skill (and its CLI dependencies) into your environment once:

```powershell
python -m pip install -e skills/kano-agent-backlog-skill
```

Optional dev/embedding dependencies can be added with extras:

```powershell
python -m pip install -e "skills/kano-agent-backlog-skill[dev]"
# Install FAISS / sentence-transformers manually per platform before running embedding workflows.
```

### Verify Installation

After installation, verify the CLI is available:

```bash
kano --help
kano workset --help
kano topic --help
```

### Agent-First Setup

**Instead of manual installation, ask your AI agent to:**

```
"Please help me set up the kano-agent-backlog-skill demo. 
Initialize the backlog structure, and show me what work items exist."
```

**The agent should automatically:**
1. Initialize submodules if needed
2. Explore the backlog structure
3. Show you available work items
4. Generate current dashboard views

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

The agent automatically maintains views under product roots (e.g. `_kano/backlog/products/<product>/views/`):
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

## Workset and Topic Features

The backlog system includes two powerful features for managing agent execution context and preventing drift during complex work sessions.

### Worksets: Per-Item Execution Cache

Worksets provide a focused, per-item execution context that prevents agent drift during task work. Each workset is a materialized cache bundle stored in `_kano/backlog/.cache/worksets/items/<item-id>/` containing:

- **plan.md**: Checklist template derived from acceptance criteria
- **notes.md**: Working notes with `Decision:` markers for ADR promotion
- **deliverables/**: Staging area for work artifacts before promotion
- **meta.json**: Metadata including agent, timestamps, TTL, and source references

#### Workset Commands

**Initialize a workset:**
```bash
kano workset init --item TASK-0042 --agent my-agent --ttl-hours 72
```

**Get next action from plan:**
```bash
kano workset next --item TASK-0042
```

This command is the workset's "keep me on track" primitive:
- It reads the workset's `plan.md` (a checklist derived from the item's Acceptance Criteria).
- It returns the *first unchecked* checkbox item (`- [ ] ...`).
- If everything is checked, it prints a completion message.

It does not automatically mark anything as done; you check items off in `plan.md` as you complete them, then run `kano workset next` again to get the next step. Use `--format json` if you want structured output for tooling/agent automation.

**Refresh from canonical files:**
```bash
kano workset refresh --item TASK-0042 --agent my-agent
```

**Promote deliverables to canonical artifacts:**
```bash
kano workset promote --item TASK-0042 --agent my-agent
# Dry run to preview
kano workset promote --item TASK-0042 --agent my-agent --dry-run
```

**Detect ADR candidates in notes:**
```bash
kano workset detect-adr --item TASK-0042
```

**List all worksets:**
```bash
kano workset list
```

**Cleanup expired worksets:**
```bash
kano workset cleanup --ttl-hours 72
# Dry run to preview
kano workset cleanup --ttl-hours 72 --dry-run
```

#### Agent Workflow with Worksets

**Ask your agent:**
```
"Initialize a workset for TASK-0042 and show me the next action to take."
```

**The agent will:**
1. Create a workset directory with plan, notes, and deliverables
2. Parse acceptance criteria into a checklist in plan.md
3. Track progress through the checklist
4. Capture decisions with `Decision:` markers in notes.md
5. Stage work artifacts in deliverables/
6. Promote deliverables back to canonical artifacts when done

**Example conversation:**
```
User: "Start working on TASK-0042"
Agent: "I'll initialize a workset and begin. The first step is..."

User: "What's next?"
Agent: "According to the plan, the next unchecked step is..."

User: "I've completed the implementation"
Agent: "Great! I'll promote the deliverables to the canonical artifacts directory."
```

### Topics: Context Switching and Grouping

Topics provide a higher-level grouping mechanism for related items and documents, enabling rapid context switching when focus areas change during a conversation.

Current implementation (see `_kano/backlog/products/kano-agent-backlog-skill/items/task/0100/KABSD-TSK-0190_topic-lifecycle-materials-buffer-workset-merge.md`) stores topics in `_kano/backlog/topics/<topic>/` so the deterministic `brief.md` can be shared/reviewed in-repo, while keeping the per-agent active-topic pointer in cache.

- **manifest.json**: Topic metadata, seed items, pinned documents
- **brief.md**: Deterministic distilled summary (generated from manifest + materials index)
- **synthesis/**: Working outputs for distillation (derived)
- **publish/**: Prepared write-backs / patch skeletons (derived)
- **materials/**: Raw collected materials (snippets, links, extracts, logs)
  - **clips/**: Code snippet references with line ranges
  - **links/**: External document references
  - **extracts/**: Cached text extracts
  - **logs/**: Optional collected logs

Notes:
- Raw materials are treated as cache: by default this repo ignores `_kano/backlog/topics/**/materials/` via `.gitignore`.
- Active topic for an agent is stored under `_kano/backlog/.cache/worksets/active_topic.<agent>.txt`.

#### Topic Commands

**Create a topic:**
```bash
kano topic create auth-refactor --agent my-agent
```

**Add items to topic:**
```bash
kano topic add auth-refactor --item TASK-0042
kano topic add auth-refactor --item TASK-0043
```

**Pin documents for context:**
```bash
kano topic pin auth-refactor --doc _kano/backlog/decisions/ADR-0005-auth-strategy.md
```

**Add code snippets to materials:**
```bash
kano topic add-snippet auth-refactor --file src/auth.py --start 10 --end 25
```

**Distill materials into brief:**
```bash
kano topic distill auth-refactor
```

**Switch active topic:**
```bash
kano topic switch auth-refactor --agent my-agent
```

**Export context bundle:**
```bash
kano topic export-context auth-refactor --format markdown
kano topic export-context auth-refactor --format json
```

**List all topics:**
```bash
kano topic list --agent my-agent
```

**Close a topic (enables TTL cleanup):**
```bash
kano topic close auth-refactor --agent my-agent
```

**Cleanup closed topics:**
```bash
kano topic cleanup --ttl-days 14 --apply
# Dry run to preview
kano topic cleanup --ttl-days 14
```

#### Agent Workflow with Topics

**Ask your agent:**
```
"Create a topic for the authentication refactor work and add the related tasks."
```

**The agent will:**
1. Create a topic directory with manifest and materials structure
2. Add related backlog items to the topic's seed_items
3. Pin relevant ADRs and design documents
4. Collect code snippets into materials/clips/
5. Generate a distilled brief from collected materials
6. Switch to the topic when you change focus
7. Export context bundles for loading into working memory

**Example conversation:**
```
User: "I'm switching to work on the payment flow"
Agent: "I'll create a topic and gather the relevant context..."
Agent: "Topic 'payment-flow' created with 3 tasks and 2 ADRs. Here's the brief..."

User: "Show me the authentication work"
Agent: "Switching to topic 'auth-refactor'... Here are the 5 tasks and relevant code snippets..."
```

#### Topic Lifecycle

1. **Create**: Initialize topic with manifest
2. **Collect**: Add items, pin documents, collect code snippets
3. **Distill**: Generate deterministic brief from materials
4. **Switch**: Change active topic for context switching
5. **Export**: Generate context bundles for agent consumption
6. **Close**: Mark topic as closed when work is complete
7. **Cleanup**: Remove raw materials after TTL (brief.md persists)

### Worksets vs Topics

| Feature | Worksets | Topics |
|---------|----------|--------|
| **Scope** | Single item | Multiple items + documents |
| **Purpose** | Execution cache | Context grouping |
| **Lifetime** | Task duration | Work area duration |
| **Content** | Plan, notes, deliverables | Items, docs, snippets, brief |
| **Use Case** | Prevent drift during task | Switch focus areas |
| **Storage** | `.cache/worksets/items/` | `topics/<topic>/` (materials ignored; active pointer in `.cache/`) |

## Configuration

Backlog configuration is in `_kano/backlog/_config/` (product-specific) or `_kano/backlog/_shared/` (shared settings).

## Contributing (Pre-Alpha)

**Current Status**: This is version 0.0.1 - an experimental demo repository in rapid development.

**Before Contributing:**
- Expect frequent breaking changes
- Check recent commits for current state
- Understand this is experimental software
- No stability guarantees

**How to Contribute:**
1. Open issues for bugs/suggestions
2. Discuss major changes before implementing
3. Expect your contributions may be refactored heavily
4. Focus on core concepts rather than implementation details

For the main skill development, see [kano-agent-backlog-skill](https://github.com/dorgonman/kano-agent-backlog-skill) (also experimental).

## Roadmap

**Version 0.0.1 (Current):**
- ✅ Core backlog management
- ✅ Workset and topic features
- ✅ Multi-agent collaboration patterns
- ✅ CLI commands
- ✅ Property-based testing

**Future Versions:**
- 🔮 Stable file format schema
- 🔮 Enhanced SQLite indexing
- 🔮 Production-ready embedding search
- 🔮 Web UI for backlog visualization
- 🔮 Git integration for version control
- 🔮 Export/import for backlog migration
- 🔮 Plugin system for custom workflows
- 🔮 Performance optimizations

**Note**: Roadmap is subject to change based on experimentation and feedback.

## License

MIT

See the individual skill repositories for license information.

## Learn More

- **Skill Documentation**: `skills/kano-agent-backlog-skill/SKILL.md` (after initializing submodules)
- **Agent Guidelines**: [AGENTS.md](AGENTS.md)
- **Example Backlogs**: Explore `_kano/backlog/products/` for real-world examples
- **ADR Directory**: `_kano/backlog/decisions/` for architectural decisions

## Troubleshooting

**Backlog not found:**
- Ensure you're in the repository root
- Check `_kano/backlog/` directory exists
- Initialize a product: `kano admin backlog init --product my-product --agent my-agent`

**Agent asks for help:**
- Point agent to `AGENTS.md` for guidelines
- Reference `skills/kano-agent-backlog-skill/SKILL.md` for detailed instructions
- Show agent the example backlogs in `_kano/backlog/products/`

## Frequently Asked Questions

**Q: Is this production-ready?**
A: No. This is version 0.0.1 - experimental software. Use at your own risk.

**Q: Can I use this for my project?**
A: Yes, but expect breaking changes. Copy the skill directory or use as a git submodule.

**Q: How do I migrate my existing backlog?**
A: Migration tools are not yet available. Manual conversion required.

**Q: Does this work with [my favorite agent]?**
A: It should work with any agent that has file system access and can run CLI commands. Tested with Amazon Kiro, Claude, Cursor, Windsurf, and others.

**Q: Why file-based instead of a database?**
A: Files are human-readable, version-controllable, and don't require a server. Optional SQLite indexes provide query performance without lock-in.

**Q: Can multiple agents work on the same backlog simultaneously?**
A: Yes, but coordination is manual. File conflicts may occur. Use git for version control and conflict resolution.

## Philosophy

This experimental demo explores a "backlog-first" approach where:

- **Planning before coding**: Work items are created and refined before implementation begins
- **Durable context**: Planning and decisions persist in files, not lost in chat conversations
- **Auditable trail**: Every change is logged with timestamps and agent identity
- **Recoverable state**: Any agent can pick up where another left off
- **Human-readable source of truth**: Markdown files are the canonical source, not databases
- **Optional indexes**: SQLite and embedding indexes enable powerful queries without lock-in
- **Multi-agent coordination**: Shared backlog enables multiple agents to collaborate effectively
- **Context isolation**: Worksets prevent drift during complex tasks
- **Rapid context switching**: Topics enable quick focus area changes

**Version 0.0.1 Status**: These principles are being tested and refined. Implementation is evolving but demonstrates the core concepts in action. The `_kano/backlog/` directory contains real-world examples of this philosophy applied to the development of the system itself.

### Dual-Readability Design (Topic & Snapshot)

A key challenge in modern development is that **Humans struggle with focus** (hard to jump between contexts) while **Agents struggle with collaboration** (hard to share implicit context).

This project checks every artifact against a **Dual-Readability Principle**:
1. **Human-Readable**: High-level summaries, clear checklists, and "manager-friendly" reports (e.g., `brief.md`, `Report_pm.md`) so humans can make rapid decisions without reading code.
2. **Agent-Readable**: Structural precision, file paths, line numbers, and explicit "Next Step" markers (e.g., `manifest.json`, `stub_inventory`) so agents can act without hallucinating.

**Topics** and **Snapshots** are the concrete implementation of this philosophy:
* **Topics**: Allow humans to "load" a focus area mentally in seconds, while giving Agents a precise list of files and snippets to load into their context window.
* **Snapshots**: Give humans a trustable "State of the Union", while giving Agents a literal checklist of `TODO`s and `NotImplementedErrors` to attack next.

### The Agent Semantic Memory Model

To help Agents (and humans) navigate the complexity of software development, this project maps its features to the standard cognitive memory model:

| Memory Type | Equivalent | Purpose | Lifespan | Analogy |
|:---:|:---:|---|---|---|
| **Short-Term**<br>(Working Memory) | **Workset** | **Execution State**<br>Prevents drift during a single task. Contains the immediate plan, scratchpad notes, and temp files. | **Hours**<br>(Task duration) | The "scratchpad" or "RAM" cleared after use. |
| **Medium-Term**<br>(Contextual) | **Topic** | **Focus Scope**<br>Groups related files, specs, and definitions for a feature. Allows rapid context switching. | **Days/Weeks**<br>(Feature duration) | The "project folder" on your desk. |
| **Long-Term**<br>(Semantic) | **ADR & Canonical** | **Institutional Knowledge**<br>Immutable decisions (ADRs) and the source code itself. The "Soul" of the project. | **Permanent**<br>(Project duration) | The "library archives" or "textbooks". |

**Why this matters**:
* Agents often "forget" instructions (Short-term failure). -> **Solution**: Worksets force them to read a `plan.md`.
* Agents often "hallucinate" unrelated files (Medium-term failure). -> **Solution**: Topics bind them to a specific `manifest.json`.
* Agents often "overwrite" architectural rules (Long-term failure). -> **Solution**: ADRs provide immutable constraints.

## Built with Multi-Agent Collaboration

This project is itself a demonstration of multi-agent collaboration in action. The codebase has been developed through iterative collaboration with multiple AI coding assistants, each bringing unique strengths to the development process:

- **Codex** - Early prototyping and concept exploration
- **GitHub Copilot** - Code completion, suggestions, and inline assistance
- **Google Antigravity** - Alternative perspectives and design discussions
- **Amazon Q** - AWS infrastructure guidance and cloud architecture
- **Amazon Kiro** - Primary development agent and implementation
- **Cursor** - Inline editing, refactoring, and code navigation
- **Windsurf** - Additional development support and testing
- **OpenCode** - Testing, validation, and quality assurance

### How Multi-Agent Collaboration Works

The backlog system you see here was used to coordinate work across these agents, proving the concept through real-world usage:

1. **Shared Backlog**: All agents work from the same file-based backlog in `_kano/backlog/`
2. **Worklog Trail**: Every decision and state change is recorded in append-only worklogs
3. **ADR Documentation**: Architectural decisions are captured in `_kano/backlog/decisions/`
4. **Context Switching**: Topics enable agents to quickly load relevant context for different work areas
5. **Workset Isolation**: Per-item worksets prevent agents from drifting during complex tasks

### Agent Collaboration Patterns

**Sequential Handoff:**
```
Agent A: Creates Epic and Feature items
Agent B: Breaks down into User Stories
Agent C: Implements Tasks with worksets
Agent D: Reviews and updates worklogs
```

**Parallel Work:**
```
Agent A: Works on TASK-0042 (auth module)
Agent B: Works on TASK-0043 (payment module)
Both: Update shared backlog independently
Both: Coordinate through ADRs and worklogs
```

**Context Switching:**
```
Agent: Switches from "auth-refactor" topic to "payment-flow" topic
Agent: Loads new context bundle with relevant items and documents
Agent: Continues work with full context of new focus area
```

### Why This Matters

Traditional agent collaboration loses context in chat conversations. This system demonstrates:

- **Durable Context**: Planning and decisions persist in files, not chat
- **Auditable Trail**: Every change is logged with timestamps and agent identity
- **Recoverable State**: Any agent can pick up where another left off
- **Scalable Coordination**: Multiple agents can work on different areas simultaneously
- **Human Oversight**: Humans can review, approve, or redirect at any checkpoint

Every feature, decision, and trade-off in this codebase is documented in the `_kano/backlog/` directory - a living example of the "backlog-first" philosophy in action.
