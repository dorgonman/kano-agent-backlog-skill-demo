# TOML Config Schema Specification v1.0

## Design Decisions

### 1. TOML Table Merge Semantics

**Decision**: Use **recursive deep merge** matching current JSON behavior.

**Rationale**:
- Consistency with existing ConfigLoader._deep_merge()
- Allows partial overrides (e.g., override only `log.verbosity` without replacing entire `[log]` table)
- TOML standard doesn't define merge behavior; we control it at load time

**Implementation**:
```python
def merge_toml_tables(base: dict, overlay: dict) -> dict:
    """Same deep merge logic as JSON; TOML tables are just dicts."""
    result = dict(base)
    for key, value in overlay.items():
        if key in result and isinstance(result[key], dict) and isinstance(value, dict):
            result[key] = merge_toml_tables(result[key], value)
        else:
            result[key] = value
    return result
```

### 2. Dual Format Support Duration

**Decision**: Support both JSON and TOML for **2 minor versions** (e.g., 0.8.x, 0.9.x) before TOML-only in 1.0.

**Rationale**:
- Gives users time to migrate
- Allows gradual rollout across teams
- Emit deprecation warnings when JSON is loaded

**Timeline**:
- v0.8.0: Add TOML support, JSON still works (deprecation warning)
- v0.9.0: Migration tool available, JSON deprecated
- v1.0.0: TOML-only, remove JSON loader

### 3. Multi-Repo Registry Location

**Decision**: Embed registry entries in global `~/.kano/config.toml` using `[[registry]]` array.

**Rationale**:
- Simpler for v1 (one file to manage)
- TOML array-of-tables syntax is clean
- Can split to `registry.toml` later if it grows

### 4. Auth Credential Strategy

**Decision**: Environment variables only for v1; no secrets in config files.

**Supported env vars**:
- `JIRA_TOKEN`, `JIRA_USER`, `JIRA_PASSWORD`
- `AZURE_DEVOPS_TOKEN`
- `BACKLOG_API_TOKEN`
- Generic: `KANO_BACKEND_{NAME}_TOKEN`

**Rationale**:
- Keeps config files safe to version control
- Standard practice for CLI tools
- Credential manager integration deferred to v2

---

## Layer Precedence

**Load order (last wins)**:
1. Global: `~/.kano/config.toml`
2. Repo shared: `_kano/backlog/_shared/config.toml`
3. Product: `_kano/backlog/products/<product>/_config/config.toml`
4. Topic: `_kano/backlog/topics/<topic>/config.toml` (if agent has active topic)
5. Workset: `_kano/backlog/.cache/worksets/items/<item_id>/config.toml` (if working on item)
6. Runtime: CLI flags and environment variables

**Migration Note**: During transition, `.json` files load before `.toml` at same layer:
- Load `defaults.json`, then `defaults.toml` (TOML wins)
- Emit warning: "JSON config deprecated; migrate with `kano-backlog admin migrate-config`"

---

## Complete TOML Schema

### Layer 1: Global Config (`~/.kano/config.toml`)

```toml
# Global defaults shared across all repos
# Location: ~/.kano/config.toml (or $XDG_CONFIG_HOME/kano/config.toml on Linux)

[defaults]
default_product = "kano-agent-backlog-skill"
verbosity = "warning"

# Default backend for new repos
[backends.default]
type = "filesystem"
# No path needed; inferred from repo location

# Optional: Multi-repo registry for cross-repo search/navigation
[[registry]]
name = "work-projects"
uri = "file:///d:/work/backlogs"
products = ["product-a", "product-b", "shared-libs"]

[[registry]]
name = "team-backlog-server"
uri = "https://backlog.example.com/api/v1"
auth = "env:BACKLOG_API_TOKEN"
products = ["team-core", "team-platform"]
```

### Layer 2: Repo Shared Config (`_kano/backlog/_shared/config.toml`)

```toml
# Repo-level shared configuration
# Overrides global defaults; applies to all products in this repo

[project]
name = "kano-agent-backlog-skill-demo"
prefix = "KABSD"

[defaults]
default_product = "kano-agent-backlog-skill"

[mode]
skill_developer = true
persona = "developer"  # For human-facing reports: developer, pm, qa, etc.

[views]
auto_refresh = true

[log]
verbosity = "info"  # Override global "warning"
debug = false
format = "plain"  # plain | json | structured

[process]
profile = "builtin/azure-boards-agile"
# Optional: path = "./custom-process.yaml"

[sandbox]
root = "_kano/backlog_sandbox"

[index]
enabled = true
backend = "sqlite"
# path defaults to: _kano/backlog/_index/backlog.sqlite3
mode = "rebuild"  # rebuild | incremental

[analysis.llm]
enabled = false
# model = "gpt-4"  # If enabled

# Optional: Remote backend configuration (compiles to URI)
[backends.jira]
type = "jira"
host = "company.atlassian.net"
project = "PROJ"
# Compiled URI: jira://company.atlassian.net/PROJ
# Auth: env:JIRA_TOKEN or env:JIRA_USER + env:JIRA_PASSWORD

[backends.azure]
type = "azure-devops"
organization = "myorg"
project = "MyProject"
area_path = "MyProject\\Team"  # Optional
# Compiled URI: azure://dev.azure.com/myorg/MyProject
# Auth: env:AZURE_DEVOPS_TOKEN
```

### Layer 3: Product Config (`_kano/backlog/products/<product>/_config/config.toml`)

```toml
# Product-specific overrides
# Inherits from repo shared config

[project]
name = "kano-agent-backlog-skill"
prefix = "KABS"  # Override repo-level prefix

[mode]
skill_developer = true

[log]
verbosity = "debug"  # Override for this product only

[index]
enabled = true
path = "_kano/backlog/products/kano-agent-backlog-skill/_index/product.sqlite3"

# Product-specific backend (e.g., sync to external tracker)
[backends.external]
type = "jira"
host = "opensource.atlassian.net"
project = "KANO"
sync_enabled = false  # Don't sync by default
```

### Layer 4: Topic Override (`_kano/backlog/topics/<topic>/config.toml`)

```toml
# Topic-specific temporary overrides
# Active when agent has this topic set

[defaults]
default_product = "experimental-feature"  # Switch context for exploration

[log]
verbosity = "debug"  # More verbose during investigation

[views]
auto_refresh = false  # Don't refresh while editing views themselves
```

### Layer 5: Workset Override (`_kano/backlog/.cache/worksets/items/<item_id>/config.toml`)

```toml
# Item-specific overrides (rare use case)
# Active when working on this specific item

[log]
verbosity = "debug"

[views]
mode = "workset"  # Custom view mode for this item
```

### Layer 6: Runtime (CLI flags / env vars)

```bash
# CLI flags (highest precedence)
kano-backlog --log-level=debug --index-mode=incremental workitem list

# Environment variables
export KANO_LOG_LEVEL=debug
export KANO_INDEX_MODE=incremental
export KANO_PRODUCT=experimental-feature
```

---

## URI Compilation Rules

### Pattern

```
[backends.{name}]
type = "{backend_type}"
{type_specific_params}
```

↓ Compiles to:

```
uri = "{backend_type}://{compiled_path}"
```

### Supported Backend Types

#### 1. Filesystem (Local)

```toml
[backends.local]
type = "filesystem"
root = "/absolute/path/to/backlog"  # Optional; defaults to current repo
```

**Compiled URI**: `file:///absolute/path/to/backlog`

#### 2. Jira Cloud/Server

```toml
[backends.jira]
type = "jira"
host = "company.atlassian.net"  # Without https://
project = "PROJ"
# Optional: api_version = "3"  # Default: 3 for Cloud, 2 for Server
```

**Compiled URI**: `jira://company.atlassian.net/PROJ`  
**Auth**: `env:JIRA_TOKEN` (preferred) or `env:JIRA_USER` + `env:JIRA_PASSWORD`

#### 3. Azure DevOps

```toml
[backends.azure]
type = "azure-devops"
organization = "myorg"
project = "MyProject"
area_path = "MyProject\\Feature Team"  # Optional
```

**Compiled URI**: `azure://dev.azure.com/myorg/MyProject`  
**Auth**: `env:AZURE_DEVOPS_TOKEN` or `env:AZURE_DEVOPS_PAT`

#### 4. HTTP/REST API

```toml
[backends.api]
type = "http"
base_url = "https://backlog.example.com/api/v1"
# Optional: verify_ssl = true
```

**Compiled URI**: `https://backlog.example.com/api/v1`  
**Auth**: `env:BACKLOG_API_TOKEN` (sent as `Authorization: Bearer {token}`)

#### 5. MCP Server (Future)

```toml
[backends.mcp]
type = "mcp"
transport = "stdio"
command = "npx"
args = ["-y", "@modelcontextprotocol/server-backlog"]
```

**Compiled URI**: `mcp+stdio://npx/-y/@modelcontextprotocol/server-backlog`  
**Auth**: Passed via MCP protocol if needed

---

## Field Reference

### [mode]

- `skill_developer` (bool): Enable skill development features (default: `false`)
- `persona` (str): Human role for report customization (`developer`, `pm`, `qa`, `stakeholder`)

### [project]

- `name` (str): Project display name
- `prefix` (str): Item ID prefix (e.g., `KABSD` → `KABSD-TSK-0001`)

### [defaults]

- `default_product` (str): Fallback product when not inferrable from path

### [views]

- `auto_refresh` (bool): Regenerate views after item changes (default: `true`)
- `mode` (str): View rendering mode (`plain`, `obsidian-dataview`, `workset`)

### [log]

- `verbosity` (str): Log level (`debug`, `info`, `warning`, `error`)
- `debug` (bool): Enable debug mode (more detailed traces)
- `format` (str): Output format (`plain`, `json`, `structured`)

### [process]

- `profile` (str): Process profile name (`builtin/azure-boards-agile`, `builtin/scrum`, path to custom YAML)
- `path` (str): Custom process definition file path (overrides `profile`)

### [sandbox]

- `root` (str): Sandbox directory path (relative to backlog root or absolute)

### [index]

- `enabled` (bool): Enable canonical index/FTS (default: `true`)
- `backend` (str): Index backend (`sqlite`, `duckdb`, future: `postgres`)
- `path` (str): Index database path (default: `_kano/backlog/_index/backlog.sqlite3`)
- `mode` (str): Index update mode (`rebuild`, `incremental`)

### [analysis.llm]

- `enabled` (bool): Enable LLM-based analysis features (default: `false`)
- `model` (str): Model identifier (e.g., `gpt-4`, `claude-sonnet-4`)
- `api_key` (str): Must be `env:VAR_NAME` reference, never literal

### [[registry]]

Multi-repo registry entry (array of tables):

- `name` (str): Registry entry name
- `uri` (str): Backend URI (file://, https://, etc.)
- `auth` (str): Auth reference (`env:TOKEN_VAR`)
- `products` (array[str]): Product names available in this backend

---

## Validation Rules

1. **No secrets in TOML**: Any `*_key`, `*_token`, `*_password` field MUST start with `env:` or be rejected
2. **URI safety**: Remote URIs (`https://`, `jira://`, `azure://`) require explicit `auth` field or `--unsafe` flag
3. **Required fields**:
   - `[project].name` and `[project].prefix` required in repo shared config
4. **Mutually exclusive**: Cannot set both `[process].profile` and `[process].path`
5. **Path validation**: Relative paths resolved from config file location; absolute paths must exist

---

## Example: Complete Migration

### Before (JSON)

`_kano/backlog/_shared/defaults.json`:
```json
{
  "default_product": "kano-agent-backlog-skill"
}
```

`_kano/backlog/products/kano-agent-backlog-skill/_config/config.json`:
```json
{
  "mode": {"skill_developer": true},
  "project": {"name": "Demo", "prefix": "KABSD"},
  "log": {"verbosity": "info"}
}
```

### After (TOML)

`_kano/backlog/_shared/config.toml`:
```toml
[defaults]
default_product = "kano-agent-backlog-skill"
```

`_kano/backlog/products/kano-agent-backlog-skill/_config/config.toml`:
```toml
[mode]
skill_developer = true

[project]
name = "Demo"
prefix = "KABSD"

[log]
verbosity = "info"
```

**Migration command**:
```bash
kano-backlog admin migrate-config --backup --validate
```

**Output**:
```
✓ Backed up JSON configs to _kano/backlog/_backup/2026-01-13/
✓ Converted 2 JSON files to TOML
✓ Validated TOML syntax and schema
✓ JSON files remain (will be ignored; TOML takes precedence)
→ Remove JSON after confirming: rm _kano/backlog/_shared/defaults.json
```

---

## Parser Implementation Notes

```python
# Python 3.11+ stdlib
import tomllib  # Read-only TOML parser (PEP 680)

# For writing TOML (migration tool)
import tomli_w  # pip install tomli-w

def load_toml_config(path: Path) -> dict:
    with open(path, "rb") as f:
        return tomllib.load(f)

def save_toml_config(path: Path, data: dict) -> None:
    with open(path, "wb") as f:
        tomli_w.dump(data, f)
```

For Python <3.11, use `tomli` package (same API as `tomllib`).

---

## Open Questions (Resolved)

✅ **TOML table merge semantics**: Recursive deep merge (same as JSON)  
✅ **Dual format support duration**: 2 minor versions  
✅ **Auth strategy**: Environment variables only for v1  
✅ **Registry location**: Embedded in global config.toml  
✅ **URI compilation timing**: Load-time, fail-fast

---

## Next Steps

1. ✅ Schema defined and documented
2. → Implement TOML loader in `kano_backlog_core/config.py` (TSK-0192)
3. → Implement URI compiler (TSK-0193)
4. → Add CLI commands: `config show`, `config validate` (TSK-0194)
5. → Build migration tool: `admin migrate-config` (TSK-0195)
6. → Update tests to use TOML fixtures
7. → Update documentation and examples
