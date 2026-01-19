# AGENTS

## Repo purpose
This repo is a demo showing how to use `kano-agent-backlog-skill` to turn agent collaboration
into a durable, local-first backlog with an auditable decision trail (instead of losing context in chat).

## Conversational-first documentation (human-agent collaboration)

This project’s primary value is **human + AI collaboration**, not just a CLI.
Therefore, when writing or updating documentation (README, docs, SKILL.md, process notes), always include
instructions for **how to drive the workflow through a conversation with an AI agent**, not only how to run commands.

Rules:
- Every workflow doc should contain both:
  - **CLI commands** (for deterministic, auditable execution), and
  - **Suggested chat prompts** (copy/paste) that a human can say to an agent.
- Prompts must be specific about inputs the agent needs: topic/item IDs, product, agent identity, expected outputs.
- Document the expected artifacts and paths the agent will produce/update (e.g., reports under `topic/publish/`).
- Prefer a consistent pattern in docs:
  1) “Say this to your agent”
  2) “The agent will do” (explicit steps)
  3) “Expected output” (files/paths + how to verify)

Example (decision audit + decision write-back):
- Say to agent: “Run a decision write-back audit for topic <topic-name> and show me which work items are missing decisions.”
- Agent runs: `kano topic decision-audit <topic-name> --format plain`
- Expected output: `_kano/backlog/topics/<topic-name>/publish/decision-audit.md`
- Say to agent: “Write back this decision to <ITEM_ID> and include the synthesis file as source.”
- Agent runs: `kano workitem add-decision <ITEM_ID> --decision "..." --source "..." --agent <agent-id> --product <product>`
- Expected output: updated work item with a `## Decisions` section + appended Worklog entry.

## Agent roster (from README.md)
- Codex
- GitHub Copilot
- Google Antigravity
- Amazon Q
- Amazon Kiro
- Cursor
- Windsurf
- OpenCode

| Agent | Primary Model(s) | Alternative Models | Notes |
|--------|------------------|-------------------|-------|
| **Codex** | **Codex-Max** (Nov 2025) | GPT-5.2-Codex, o1/o3-reasoning | OpenAI's dedicated line for software engineering and multi-file logic |
| **GitHub Copilot** | **GPT-5.2** (Dec 2025) | Claude 4.5, Gemini 3 Pro, GPT-5.1 | Multi-model picker; GPT-5.2 Pro available for advanced research/reasoning |
| **Google Antigravity** | **Gemini 3 Flash** (Dec 2025) | Gemini 3 Pro, Gemini 1.5 Pro (legacy) | Optimized for low-latency planning and multimodal workspace reasoning |
| **Amazon Q** | **Claude 4 Sonnet** (May 2025) | Claude 4.5 Sonnet, Amazon Nova | Enhanced for autonomous computer use and deep codebase integration |
| **Amazon Kiro** | **Auto-Routing** (Dynamic) | Claude 4.5 (Opus/Sonnet/Haiku) | Intelligent routing across Claude 4 family; ~23% cheaper than direct Opus 4.5 use |
| **Cursor** | **Claude 3.5 Sonnet**, **GPT-5** | cursor-small (V2), GPT-4.1 Mini | Stable support for 2024/2025 frontier models; high-freq codebase indexing |
| **Windsurf** | **SWE-1.5** (Proprietary) | Claude 4, GPT-5.1, BYOK | SWE-1.5 is a frontier coding model with performance near Claude 4.5 |
| **OpenCode** | **Multi-Provider** | DeepSeek V3.2, Llama 4 Scout, Mistral Large 3 | Open-source champion; supports 75+ providers including regional models |

## Development Guidelines

### Quick Start Commands

```bash
# Install dependencies (dev mode)
python -m pip install -e skills/kano-agent-backlog-skill[dev]

# Run a specific test
python -m pytest tests/test_chunking_mvp.py -v

# Run all tests
python -m pytest tests/ -v

# Run tests with coverage
python -m pytest tests/ --cov=skills/kano-agent-backlog-skill/src --cov-report=html

# Format code
black skills/kano-agent-backlog-skill/src tests/

# Sort imports
isort skills/kano-agent-backlog-skill/src tests/

# Check types
mypy skills/kano-agent-backlog-skill/src

# Run all linting
black skills/kano-agent-backlog-skill/src tests/ && \
isort skills/kano-agent-backlog-skill/src tests/ && \
mypy skills/kano-agent-backlog-skill/src
```

### Code Style Guidelines

#### Type Hints

Always use type hints from `typing` module: `List`, `Dict`, `Optional`, `Any`, `Union`, `Tuple`.

Example:
```python
from typing import List, Optional, Dict

def process_items(items: List[str]) -> Dict[str, Any]:
    """Process items and return a dictionary."""
    result: Dict[str, Any] = {}
    for item in items:
        result[item] = len(item)
    return result
```

#### Import Conventions

1. Order: standard library → third-party → local modules
2. Use absolute imports from skill packages: `from kano_backlog_core import ...`
3. Use relative imports within packages: `from .models import ...`

Example:
```python
import json  # Standard library
from pathlib import Path  # Standard library
from frontmatter import load  # Third-party
from kano_backlog_core import BacklogItem  # Absolute from skill root
from .models import ItemState  # Relative within package
```

#### Naming Conventions

- Classes: `PascalCase` (e.g., `CanonicalStore`, `ChunkingOptions`)
- Functions: `snake_case` (e.g., `read_item`, `validate_config`)
- Constants: `UPPER_SNAKE_CASE` (e.g., `TYPE_DIRNAMES`)
- Private members: leading underscore `_private_var`, `__dunder__`
- Modules: `snake_case` (e.g., `kano_backlog_core`, `token_counter`)

#### Formatting Rules

- Line length: 88 characters (Black default)
- Indentation: 4 spaces
- No trailing whitespace
- Docstrings: triple double quotes `"""`, Google style
- Type hints: after function definition, before docstring

Example:
```python
def process_data(data: List[Dict[str, Any]]) -> Dict[str, Any]:
    """Process data and return results.

    Args:
        data: Input data to process.

    Returns:
        Dictionary of processed results.
    """
    result: {}
    for item in data:
        result[item["id"]] = item["value"]
    return result
```

#### Error Handling

Use exceptions from `kano_backlog_core/errors.py`:

- `ItemNotFoundError` - Item file doesn't exist
- `ParseError` - Invalid frontmatter or markdown
- `ValidationError` - Data validation failed
- `ConfigError` - Configuration error
- `WriteError` - Write operation failed

Example:
```python
from kano_backlog_core.errors import ItemNotFoundError

def load_item(item_path: Path) -> BacklogItem:
    if not item_path.exists():
        raise ItemNotFoundError(item_path, f"Item file not found: {item_path}")
```

#### Docstring Conventions

- Triple double quotes `"""`
- Google Style Guide format
- Include `Args:`, `Returns:`, and `Raises:` sections
- Imperative mood: "Return", not "Returns"

Example:
```python
def create_item(title: str) -> BacklogItem:
    """Create a new backlog item.

    Args:
        title: The title of the item.

    Returns:
        The created BacklogItem object.
    """
    return BacklogItem(title=title)
```

### Testing Guidelines

#### Test Structure

- Use pytest as test runner
- Place tests in `tests/` directory
- Test filename: `test_{module_name}.py`
- Use Hypothesis for property-based testing

#### Property-Based Testing with Hypothesis

```python
from hypothesis import given, strategies as st, composite
from kano_backlog_core import ChunkingOptions

@composite
def valid_config_strategy(draw):
    """Generate valid config instances."""
    return ChunkingOptions(
        target_tokens=draw(st.integers(min_value=50, max_value=2048)),
        max_tokens=draw(st.integers(min_value=512, max_value=4096))
    )

@given(valid_config_strategy())
def test_valid_config_passes(config: ChunkingOptions):
    """Valid config should pass validation."""
    assert config.target_tokens <= config.max_tokens
```

### Using the Kano Backlog Skill

#### Before Making Changes

1. Check existing items:
```bash
python -m kano_backlog_cli.main item list --product kano-agent-backlog-skill
```

2. Create or update work items before coding:
```bash
python -m kano_backlog_cli.main item create \
    --type task \
    --title "Implement X feature" \
    --product kano-agent-backlog-skill \
    --agent <your-agent-id>
```

3. Enforce the Ready gate on Task/Bug items:
- Required fields: Context, Goal, Approach, Acceptance Criteria, Risks / Dependencies
- All fields must be non-empty and written in **English only**

4. Update item state when starting work:
```bash
python -m kano_backlog_cli.main item update-state \
    --id KABSD-TSK-0146 \
    --state InProgress \
    --agent <your-agent-id>
```

#### Worklog Discipline

Worklog is append-only. Append when:
- A load-bearing decision is made
- An item state changes
- Scope/approach changes
- An ADR is created/linked

Format:
```
YYYY-MM-DD HH:MM [agent=<agent-id>] [model=<model>] description
```

**Always provide explicit `--agent <id>`** - never use placeholders like `auto` or `<AGENT_NAME>`.

#### State Transitions

```bash
# Move to InProgress
python -m kano_backlog_cli.main item update-state --id <ID> --state InProgress --agent <agent-id>

# Move to Done
python -m kano_backlog_cli.main item update-state --id <ID> --state Done --agent <agent-id>
```

#### ADR Creation

```bash
python -m kano_backlog_cli.main adr create \
    --title "Decision title" \
    --product kano-agent-backlog-skill \
    --agent <agent-id>
```

### Agent-Specific Rules

#### GitHub Copilot

Follow commit guidelines in `.github/copilot-instructions.md`:
- Use Kano backlog IDs directly in commit messages
- Preferred format: `KABSD-TSK-0146: <short summary>`
- Multiple items: `KABSD-TSK-0146 KABSD-TSK-0147: <short summary>`
- Do NOT use `jira#` prefix

Backlog system note:
- This repository uses kano-backlog as the system of record, not Jira.
- Do not add any `jira#` or `JIRA:` prefixes. Reference Kano IDs directly.
- Examples:
  - Good: `KABSD-TSK-0261: refine filename truncation`
  - Bad: `jira#KABSD-TSK-0261`

#### Agent Identity

Valid agent IDs for worklog entries:
- `copilot`, `codex`, `claude`, `goose`, `antigravity`, `cursor`, `windsurf`, `opencode`, `kiro`, `amazon-q`

Forbidden: `<AGENT_NAME>`, `$AGENT_NAME`

### Architecture Rules (ADR-0013)

#### Module Boundaries

- `kano_backlog_core/` - Import-only, no executable code
- `kano_backlog_ops/` - Use cases and business logic
- `kano_backlog_cli/` - Executable CLI commands
- `scripts/` - Entry point scripts

#### Cross-Package Imports

Use absolute imports from `kano_backlog_core` when importing from other packages:
```python
from kano_backlog_core import BacklogItem, ItemState
```

Never import directly from `kano_backlog_ops` from CLI or scripts.

### Common Data Structures

- `BacklogItem` - Core work item model with frontmatter
- `ItemType` - Enum: EPIC, FEATURE, USER_STORY, TASK, BUG
- `ItemState` - Enum: Proposed, Planned, Ready, InProgress, Blocked, Done, Dropped
- `ChunkingOptions`, `TokenBudgetPolicy` - Configuration for chunking system

### Common Error Types

- `ItemNotFoundError` - Item file doesn't exist
- `ParseError` - Invalid frontmatter or markdown
- `ValidationError` - Data validation failed
- `ConfigError` - Configuration error
- `WriteError` - Write operation failed

---

**Remember**: This is a living document. Update it as patterns evolve in the codebase.

## Canonical + Adapters Architecture

> [!IMPORTANT]
> **This repo uses a "canonical source + adapters" layout** to support multiple AI coding agents.

### Canonical Source (Single Source of Truth)
- All skill documentation lives in: `skills/<skill-name>/SKILL.md`
- **Always read the canonical SKILL.md** - adapters are just entry points

### Adapters (Entry Points for Different Agents)
- **GitHub Copilot**: `.github/skills/<skill-name>/SKILL.md` (thin wrapper with links to canonical)
- **OpenAI Codex**: `.codex/skills/<skill-name>/SKILL.md` (thin wrapper with name/description and links)
- **Anthropic Claude**: `.claude/skills/<skill-name>/SKILL.md` (compatible with Claude Code/Desktop)
- **Goose**: `.goose/skills/<skill-name>/SKILL.md` (open-source agent compatible with Claude skills)
- **Google Antigravity**: `.agent/skills/<skill-name>/SKILL.md` (native workspace skills)
- **Claude Code**: `CLAUDE.md` (root wrapper pointing back to this file)
- **Universal**: `AGENTS.md` (this file) enforces workflow rules
- **Modular**: Skills are self-contained in `skills/` directory

### Workflow Enforcement
1. **Before using any skill**: Open and read the canonical `skills/<skill-name>/SKILL.md`
2. If you only see a summary/wrapper, **follow the links** to canonical sections
3. Run `doctor` or verification commands mentioned in canonical docs

## Key paths
- Skill (submodule): `skills/kano-agent-backlog-skill/`
  - **Canonical rules**: `skills/kano-agent-backlog-skill/SKILL.md` ← READ THIS
  - Copilot adapter: `.github/skills/kano-agent-backlog-skill/SKILL.md`
  - Codex adapter: `.codex/skills/kano-agent-backlog-skill/SKILL.md`
  - Claude adapter: `.claude/skills/kano-agent-backlog-skill/SKILL.md`
  - Goose adapter: `.goose/skills/kano-agent-backlog-skill/SKILL.md`
  - Antigravity adapter: `.agent/skills/kano-agent-backlog-skill/SKILL.md`
  - References: `skills/kano-agent-backlog-skill/references/`
- Skill: `skills/kano-commit-convention-skill/`
  - **Canonical rules**: `skills/kano-commit-convention-skill/SKILL.md` ← READ THIS
  - Copilot adapter: `.github/skills/kano-commit-convention-skill/SKILL.md`
  - Codex adapter: `.codex/skills/kano-commit-convention-skill/SKILL.md`
  - Claude adapter: `.claude/skills/kano-commit-convention-skill/SKILL.md`
  - Goose adapter: `.goose/skills/kano-commit-convention-skill/SKILL.md`
  - Antigravity adapter: `.agent/skills/kano-commit-convention-skill/SKILL.md`
- **Universal Rules**: `AGENTS.md` (this file)
- **Claude Code**: `CLAUDE.md` (root wrapper pointing to AGENTS.md)
- Demo backlog (system of record): `_kano/backlog/`
  - Items: `_kano/backlog/items/`
  - ADRs: `_kano/backlog/decisions/`
  - Views: `_kano/backlog/products/<product>/views/`
  - Tools (project-specific): `_kano/backlog/tools/` (project-only views/dashboards)

## Backlog discipline (this repo)
- Use `skills/kano-agent-backlog-skill/SKILL.md` for any planning/backlog work.
- If Python deps are missing, install them with `python -m pip install -e skills/kano-agent-backlog-skill` (add `[dev]` when developing the skill itself).
- Before any code change, create/update items in `_kano/backlog/items/` (Epic -> Feature -> UserStory -> Task/Bug).
> [!IMPORTANT]
> **Strictly English Only**: All backlog item content (Context, Goal, Approach, Worklog, etc.) MUST be written in English. This is a hard requirement for this demo to ensure accessibility for all agents.
- Enforce the Ready gate on Task/Bug (required, non-empty): `Context`, `Goal`, `Approach`, `Acceptance Criteria`, `Risks / Dependencies`.
- Worklog is append-only; never rewrite history. Append a Worklog line whenever:
  - a load-bearing decision is made,
  - an item state changes,
  - scope/approach changes,
  - or an ADR is created/linked.
- Use `python skills/kano-agent-backlog-skill/scripts/kano item update-state ...` for state transitions so `state`, `updated`, and Worklog stay consistent.
- Need a new backlog product? Run `python skills/kano-agent-backlog-skill/scripts/kano backlog init --product <name> --agent <id>` to scaffold `_kano/backlog/products/<name>/` before creating items.
- For backlog/skill file operations, go through the `kano` CLI so audit logs capture the action (no ad-hoc file edits).
- Skill scripts refuse paths outside `_kano/backlog/` or `_kano/backlog_sandbox/`.
- Keep backlog volume under control: only open new items for code/design changes; keep Tasks/Bugs sized to one focused session; avoid ADRs unless there is a real architectural trade-off.
- Ticketing threshold (agent-decided):
  - Open a new Task/Bug when you will change code/docs/views/scripts.
  - Open an ADR (and link it) when a real trade-off or direction change is decided.
  - Otherwise, record the discussion in an existing Worklog; ask if unsure.
- State ownership: the agent decides when to move items to InProgress or Done; humans observe and can add context.

## Naming and storage rules (short)
- Store items under `_kano/backlog/items/<type>/<bucket>/` and bucket per 100 (`0000`, `0100`, ...).
- Filenames are stable: `<ID>_<slug>.md` (ASCII slug).
- For Epics, create an adjacent `<ID>_<slug>.index.md` MOC and register it in `_kano/backlog/_meta/indexes.md`.

## Views (human-friendly)
- Obsidian Dataview dashboards live under product view roots (e.g. `_kano/backlog/products/<product>/views/Dashboard.md`).
- Generate the canonical dashboards via the CLI: `python skills/kano-agent-backlog-skill/scripts/kano-backlog view refresh --agent <id> --backlog-root _kano/backlog --product <name>`.
  - Note: `_kano/backlog/tools/*.sh` are deprecated; use Python tools instead when needed (e.g. `generate_demo_views.py`, `generate_focus_view.py`).

## Demo principles
- Keep the demo backlog small and traceable; avoid ticket spam.
- Avoid unrelated refactors; every meaningful change should be explainable via a backlog item or ADR (with verification steps).
- If you change the skill itself, commit inside the submodule `skills/kano-agent-backlog-skill/` and update the parent repo submodule pointer.
- Self-contained skill stance (this demo repo):
  - Prefer adding automation as new `kano` subcommands so the skill is usable without manual setup.
  - Keep `_kano/backlog/tools/` for project-only dashboards/demos (wrapping skill scripts is OK when the behavior is demo-specific).
  - Other projects may choose override-only usage; this repo does not. Treat the skill as the source of truth.

## Tests
No tests or build steps are defined yet.

## Temporary Clause: Local-first First, No Server Implementation Yet

**Effective immediately**, this project prioritizes **local-first** completion and hardening.

### Allowed (Encouraged)
- Any work that improves local-first workflows and quality, including:
  - File-based canonical data design, schema refinement, validation, and migration tooling
  - Local indexing/search (e.g., SQLite/FTS/sidecar ANN), ingest pipelines, and performance work
  - CLI scripts, automation scripts, and developer tooling
  - Documentation, ADRs, threat models, and evaluations for future cloud/server support
  - Designing server interfaces (API/MCP schemas) **as documentation/spec only**

### Not Allowed (Hard Stop)
- **Do not implement any server runtime** or deployable server component, including but not limited to:
  - HTTP server, REST API service, gRPC service
  - MCP server (any transport)
  - Web UI that depends on a running server
  - Docker/K8s deployment for a server component
  - Authentication/authorization implementation **as runnable server code**
- Do not add runtime dependencies whose primary purpose is server hosting (unless explicitly approved).

### Re-enabling Condition
- This clause remains in effect **until a human explicitly removes or disables it**.
- Any request that appears to require server implementation must be treated as **"spec-only"** and should produce:
  1) an ADR and/or design doc,
  2) a roadmap ticket proposal,
  3) a clear note that implementation is deferred due to this clause.

### Rationale
- Keep the project focused on local-first stability and usability before expanding to cloud/multi-remote deployments.

<!-- kano-agent-backlog-skill:start -->
## Project backlog discipline (kano-agent-backlog-skill)
- Use `skills/kano-agent-backlog-skill/SKILL.md` for any planning/backlog work.
- Backlog root is `_kano/backlog_sandbox/_tmp_tests/guide_test_backlog` (items are file-first; index/logs are derived).
- Before any code change, create/update items in `_kano/backlog_sandbox/_tmp_tests/guide_test_backlog/items/` (Epic -> Feature -> UserStory -> Task/Bug).
- Enforce the Ready gate on Task/Bug before starting; Worklog is append-only.
- Use the `kano` CLI (not ad-hoc edits) so audit logs capture actions:
  - Bootstrap: `python skills/kano-agent-backlog-skill/scripts/kano backlog init --product <name> --agent <agent-name>`
  - Create/update: `python skills/kano-agent-backlog-skill/scripts/kano item create|update-state ... --agent <agent-name>`
  - Views: `python skills/kano-agent-backlog-skill/scripts/kano view refresh --agent <agent-name> --product <name>`
- Dashboards auto-refresh after item changes by default (`views.auto_refresh=true`); use `--no-refresh` or set it to `false` if needed.
<!-- kano-agent-backlog-skill:end -->
