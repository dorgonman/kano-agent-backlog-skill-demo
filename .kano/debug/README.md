# Debug Output Directory (Deprecated)

Effective config artifacts now live under `.kano/cache/`.

## Contents

### `effective_backlog_config.toml`

The **stable effective configuration** file showing the merged project/product configuration used by the backlog system.

**What it contains:**
- `[meta]` - Source file list + mtimes + merge inputs
- `[context]` - Runtime context (project root, backlog root, product info, etc.)
- `[config]` - Complete merged configuration including:
  - System defaults (hardcoded in the skill)
  - Backlog defaults (`_kano/backlog/_shared/defaults.toml` if present)
  - Project-level settings (from `.kano/backlog_config.toml`)
  - Product-specific overrides
  - All computed/derived values

**Purpose:**
- Debugging configuration issues
- Understanding which values are being used at runtime
- Verifying configuration precedence and merging behavior
- Troubleshooting unexpected behavior

## When is the file generated?

The `effective_backlog_config.toml` file is generated when `load_effective_config()` runs and the merged config changes (mtime-based cache).

## Runtime Override Artifact

If a command uses profile/topic/workset overrides, a separate artifact is written to:
`.kano/cache/effective_runtime_backlog_config.toml`.

## File Format

The file uses TOML format with two main sections:

```toml
[context]
project_root = "/path/to/project"
backlog_root = "/path/to/backlog"
product_name = "my-product"
# ... other context fields

[config]
[config.product]
name = "my-product"
prefix = "MP"

[config.log]
debug = true
level = "INFO"

# ... all other configuration sections
```

## Gitignore

`.kano/cache/` is excluded from version control.

## Troubleshooting

### File not being generated?

1. Run any command that loads config (e.g. `kano config show --product my-product`).
2. Check `.kano/cache/effective_backlog_config.toml` for the merged config.

### File contains unexpected values?

The effective config shows the **final merged result** from multiple layers:
1. System defaults (lowest priority)
2. Project-level defaults (`[defaults]` section)
3. Shared settings (`[shared.*]` sections)
4. Product-specific settings (flattened keys under `[products.<name>]`)

Check each layer to understand where a value is coming from.

## Related Commands

```bash
# Show effective config (JSON output)
kano config show --product my-product

# Export effective config to custom location
kano config export --product my-product --out /path/to/output.toml

# Validate configuration
kano config validate --product my-product

# Refresh views
kano view refresh --agent your-agent --product my-product
```

## See Also

- Project config: `.kano/backlog_config.toml`
- Backlog root: `_kano/backlog/`
- Skill documentation: `skills/kano-agent-backlog-skill/SKILL.md`
