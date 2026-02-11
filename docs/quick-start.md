# Quick Start Guide

Get started with kano-agent-backlog-skill in 5-10 minutes. This guide walks you through installation, creating your first backlog, and managing work items.

## Prerequisites

- Python 3.8 or higher
- pip (Python package installer)
- SQLite (usually included with Python)

## Installation

Install kano-agent-backlog-skill using pip:

```bash
pip install kano-agent-backlog-skill
```

**Verify installation:**

```bash
kano-backlog --version
```

You should see the version number displayed (e.g., `0.1.0`).

**Check your environment:**

```bash
kano-backlog doctor
```

This command validates your environment and reports any issues. All checks should pass (✅) before proceeding.

## Initialize Your First Backlog

Create a new backlog in your project directory:

```bash
# Navigate to your project directory
cd /path/to/your/project

# Initialize a new backlog with a product name
kano-backlog backlog init --product my-project --agent your-name
```

This creates a `_kano/backlog/` directory structure with:
- `items/` - Work items (epics, features, tasks, bugs)
- `decisions/` - Architecture Decision Records (ADRs)
- `products/my-project/` - Product-specific views and configuration
- `_meta/` - Metadata and indexes

## Create Your First Work Item

Let's create a task to track some work:

```bash
kano-backlog item create \
  --type task \
  --title "Set up project documentation" \
  --product my-project \
  --agent your-name
```

**Output:**
```
Created task: MYPROJ-TSK-0001
File: _kano/backlog/items/task/0000/MYPROJ-TSK-0001_set-up-project-documentation.md
```

The CLI automatically:
- Assigns a unique ID (`MYPROJ-TSK-0001`)
- Creates a markdown file with frontmatter
- Initializes the item in `Proposed` state
- Adds a worklog entry

## View Your Items

List all items in your product:

```bash
kano-backlog item list --product my-project
```

**Output:**
```
MYPROJ-TSK-0001  Task       Proposed  Set up project documentation
```

**View a specific item:**

```bash
kano-backlog item show MYPROJ-TSK-0001
```

This displays the full item content including frontmatter and markdown body.

## Update Item State

Move your task through the workflow:

```bash
# Move to Planned state
kano-backlog item update-state \
  --id MYPROJ-TSK-0001 \
  --state Planned \
  --agent your-name

# Move to Ready state (requires all required fields to be filled)
kano-backlog item update-state \
  --id MYPROJ-TSK-0001 \
  --state Ready \
  --agent your-name

# Move to InProgress when you start work
kano-backlog item update-state \
  --id MYPROJ-TSK-0001 \
  --state InProgress \
  --agent your-name

# Move to Done when complete
kano-backlog item update-state \
  --id MYPROJ-TSK-0001 \
  --state Done \
  --agent your-name
```

Each state transition:
- Updates the `state` field in frontmatter
- Updates the `updated` timestamp
- Appends a worklog entry with timestamp and agent

**Valid state transitions:**
- `Proposed` → `Planned` or `Dropped`
- `Planned` → `Ready` or `Dropped`
- `Ready` → `InProgress` or `Blocked`
- `InProgress` → `Done` or `Blocked`
- `Blocked` → `InProgress`

## Edit Item Details

Items are stored as markdown files. You can edit them directly:

```bash
# Open the item file in your editor
code _kano/backlog/items/task/0000/MYPROJ-TSK-0001_set-up-project-documentation.md
```

**Required fields for Tasks/Bugs to reach Ready state:**
- `Context` - Background and motivation
- `Goal` - What you're trying to achieve
- `Approach` - How you plan to do it
- `Acceptance Criteria` - How you'll know it's done
- `Risks / Dependencies` - What could go wrong or what you depend on

Edit the markdown sections below the frontmatter, then save the file.

## Create Different Item Types

**Create an Epic (high-level initiative):**

```bash
kano-backlog item create \
  --type epic \
  --title "Improve documentation" \
  --product my-project \
  --agent your-name
```

**Create a Feature (user-facing capability):**

```bash
kano-backlog item create \
  --type feature \
  --title "Add quick start guide" \
  --product my-project \
  --agent your-name \
  --parent MYPROJ-EPC-0001
```

**Create a User Story:**

```bash
kano-backlog item create \
  --type user-story \
  --title "As a new user, I want a quick start guide" \
  --product my-project \
  --agent your-name \
  --parent MYPROJ-FTR-0001
```

**Create a Bug:**

```bash
kano-backlog item create \
  --type bug \
  --title "Installation fails on Python 3.8" \
  --product my-project \
  --agent your-name
```

## Create an Architecture Decision Record (ADR)

Document important architectural decisions:

```bash
kano-backlog adr create \
  --title "Use SQLite for local storage" \
  --product my-project \
  --agent your-name
```

This creates an ADR file in `_kano/backlog/decisions/` with a template for:
- Status (Proposed, Accepted, Deprecated, Superseded)
- Context
- Decision
- Consequences
- Alternatives Considered

## Next Steps

You now know the basics! Here's what to explore next:

1. **Learn about configuration** - See [Configuration Guide](configuration.md) for profiles, environment variables, and advanced settings

2. **Explore views** - Generate Obsidian Dataview dashboards:
   ```bash
   kano-backlog view refresh --product my-project --agent your-name
   ```

3. **Work with multiple products** - Create separate backlogs for different projects:
   ```bash
   kano-backlog backlog init --product another-project --agent your-name
   ```

4. **Integrate with your workflow** - Use the backlog discipline described in [AGENTS.md](../AGENTS.md) to track work before making code changes

5. **Read the full documentation** - See [Installation Guide](installation.md) for troubleshooting and advanced installation options

## Common Commands Reference

```bash
# Environment validation
kano-backlog doctor

# Backlog management
kano-backlog backlog init --product <name> --agent <agent>

# Item management
kano-backlog item create --type <type> --title "<title>" --product <name> --agent <agent>
kano-backlog item list --product <name>
kano-backlog item show <ID>
kano-backlog item update-state --id <ID> --state <state> --agent <agent>

# ADR management
kano-backlog adr create --title "<title>" --product <name> --agent <agent>
kano-backlog adr list --product <name>

# View management
kano-backlog view refresh --product <name> --agent <agent>
```

## Getting Help

- Run any command with `--help` to see available options:
  ```bash
  kano-backlog item create --help
  ```

- Check the [Installation Guide](installation.md) for troubleshooting

- Review [AGENTS.md](../AGENTS.md) for workflow guidelines and best practices

- Report issues on [GitHub](https://github.com/yourusername/kano-agent-backlog-skill/issues)

---

**Ready to dive deeper?** Check out the [Configuration Guide](configuration.md) to customize your backlog setup.
