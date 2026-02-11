# Configuration Guide

This guide explains how to configure kano-agent-backlog-skill, including config file locations, the profile system, environment variables, backlog root setup, and multi-product configuration.

## Overview

kano-agent-backlog-skill uses a layered configuration system that allows you to:
- Manage multiple products from a single project
- Override settings at different levels (CLI, profile, product, project)
- Use profiles for different workflows (embedding models, logging levels, etc.)
- Customize behavior per product or globally

## Configuration File Locations

### Project-Level Configuration (Primary)

**Location:** `.kano/backlog_config.toml` (in your project root)

This is the **primary configuration file** for your project. It defines:
- Product definitions (name, prefix, backlog_root)
- Shared settings across all products
- Default values for all products

**Example structure:**

```toml
# .kano/backlog_config.toml

[defaults]
skill_developer = true
auto_refresh = true

[products.my-project]
name = "my-project"
prefix = "MP"
backlog_root = "_kano/backlog"

[shared.log]
debug = false

[shared.cache]
root = ".kano/cache/backlog"
```

**When to use:**
- Required for all projects using kano-agent-backlog-skill
- Defines which products exist and where their data lives
- Sets project-wide defaults

### Product-Specific Configuration (Optional)

**Location:** `<backlog_root>/products/<product-name>/_config/config.toml`

Product-specific overrides for settings that differ from project defaults.

**Example:**

```toml
# _kano/backlog/products/my-project/_config/config.toml

[product]
name = "my-project"
prefix = "MP"

[log]
debug = true  # Override project default for this product only

[vector]
enabled = true
backend = "sqlite"
```

**When to use:**
- Override project defaults for a specific product
- Enable/disable features per product
- Customize logging, caching, or vector settings

### Profile Configuration (Optional)

**Location:** `.kano/backlog_config/<category>/<name>.toml`

Profiles are named configuration overlays for specific workflows or experiments.

**Example:**

```toml
# .kano/backlog_config/embedding/gemini-embedding-001.toml

[embedding]
provider = "gemini"
model = "text-embedding-004"
api_key_env = "GEMINI_API_KEY"

[vector]
enabled = true
backend = "sqlite"
```

**When to use:**
- Switch between different embedding models
- Test different chunking strategies
- Experiment with logging levels
- Share configuration across team members

### Configuration Precedence

Settings are merged in this order (highest priority first):

1. **CLI parameters** - `--cache-root`, `--profile`, etc.
2. **Workset config** - `_kano/backlog/.cache/worksets/items/<item_id>/config.toml`
3. **Topic config** - `_kano/backlog/topics/<topic>/config.toml`
4. **Profile** - `.kano/backlog_config/<category>/<name>.toml` (via `--profile`)
5. **Product config** - `<backlog_root>/products/<product>/_config/config.toml`
6. **Project config** - `.kano/backlog_config.toml`
7. **Defaults** - Built-in defaults

**Example:** If you set `debug = true` in your profile, it overrides the project config setting, but `--log-level debug` on the CLI overrides everything.

## Profile System

### What Are Profiles?

Profiles are reusable configuration overlays that let you switch between different settings without editing your main config file.

**Common use cases:**
- **Embedding profiles** - Switch between local models, OpenAI, Gemini, etc.
- **Logging profiles** - Different verbosity levels for debugging vs. production
- **Experiment profiles** - Test different chunking or tokenization strategies

### Profile Locations

Profiles can be stored in two places:

1. **Project-local profiles** (recommended):
   - Location: `.kano/backlog_config/<category>/<name>.toml`
   - Example: `.kano/backlog_config/embedding/local-noop.toml`
   - Tracked in your project's git repository

2. **Built-in profiles** (provided by the skill):
   - Location: `skills/kano-agent-backlog-skill/profiles/<category>/<name>.toml`
   - Example: `skills/kano-agent-backlog-skill/profiles/embedding/gemini-embedding-001.toml`
   - Shared across all projects

### Using Profiles

**Via CLI:**

```bash
# Use shorthand (searches .kano/backlog_config/ first, then built-in profiles)
kano-backlog embedding build --profile embedding/local-noop

# Use explicit path (absolute or repo-relative)
kano-backlog embedding build --profile .kano/backlog_config/embedding/local-noop.toml

# Use absolute path
kano-backlog embedding build --profile /path/to/custom-profile.toml
```

**Via project config:**

Set a default profile in `.kano/backlog_config.toml`:

```toml
[defaults]
profile = "embedding/local-noop"
```

**Note:** CLI `--profile` always overrides the project config default.

### Profile Resolution Order

When you use `--profile embedding/local-noop`, the system searches:

1. **Explicit path** - If the argument is an existing file path (absolute or repo-relative), use it
2. **Project-local shorthand** - `.kano/backlog_config/embedding/local-noop.toml`
3. **Built-in shorthand** - `skills/kano-agent-backlog-skill/profiles/embedding/local-noop.toml`

**Tip:** Use shorthand for portability. Use explicit paths for one-off experiments.

### Creating Custom Profiles

**Step 1:** Create a profile file

```bash
# Create the directory structure
mkdir -p .kano/backlog_config/embedding

# Create a profile file
cat > .kano/backlog_config/embedding/my-custom.toml << 'EOF'
[embedding]
provider = "openai"
model = "text-embedding-3-small"
api_key_env = "OPENAI_API_KEY"

[vector]
enabled = true
backend = "sqlite"
metric = "cosine"

[chunking]
target_tokens = 512
max_tokens = 1024
EOF
```

**Step 2:** Use the profile

```bash
kano-backlog embedding build --profile embedding/my-custom
```

**Step 3:** Verify effective configuration

```bash
kano-backlog config show --profile embedding/my-custom
```

This displays the merged configuration with your profile applied.

### Built-in Profiles

kano-agent-backlog-skill includes several built-in profiles:

**Embedding profiles:**
- `embedding/local-noop` - No-op embedding (for testing without ML dependencies)
- `embedding/gemini-embedding-001` - Google Gemini text-embedding-004
- `embedding/openai-text-embedding-3-small` - OpenAI text-embedding-3-small

**Logging profiles:**
- `logging/debug` - Verbose debug logging
- `logging/quiet` - Minimal output

**To list available profiles:**

```bash
kano-backlog config list-profiles
```

## Environment Variables

kano-agent-backlog-skill respects several environment variables for configuration and credentials.

### API Keys and Credentials

**GEMINI_API_KEY**
- **Purpose:** API key for Google Gemini embedding models
- **Used by:** `embedding/gemini-embedding-001` profile
- **Example:**
  ```bash
  export GEMINI_API_KEY="your-api-key-here"
  kano-backlog embedding build --profile embedding/gemini-embedding-001
  ```

**OPENAI_API_KEY**
- **Purpose:** API key for OpenAI embedding models
- **Used by:** `embedding/openai-text-embedding-3-small` profile
- **Example:**
  ```bash
  export OPENAI_API_KEY="sk-..."
  kano-backlog embedding build --profile embedding/openai-text-embedding-3-small
  ```

### Configuration Overrides

**KANO_BACKLOG_ROOT**
- **Purpose:** Override the default backlog root directory
- **Default:** `_kano/backlog`
- **Example:**
  ```bash
  export KANO_BACKLOG_ROOT="/path/to/custom/backlog"
  kano-backlog item list --product my-project
  ```

**KANO_BACKLOG_CONFIG**
- **Purpose:** Override the project config file location
- **Default:** `.kano/backlog_config.toml`
- **Example:**
  ```bash
  export KANO_BACKLOG_CONFIG="/path/to/custom-config.toml"
  kano-backlog config show
  ```

**KANO_CACHE_ROOT**
- **Purpose:** Override the cache directory location
- **Default:** `.kano/cache/backlog`
- **Example:**
  ```bash
  export KANO_CACHE_ROOT="/tmp/kano-cache"
  kano-backlog embedding build
  ```

### Debugging and Logging

**KANO_LOG_LEVEL**
- **Purpose:** Set logging verbosity
- **Values:** `DEBUG`, `INFO`, `WARNING`, `ERROR`, `CRITICAL`
- **Default:** `INFO`
- **Example:**
  ```bash
  export KANO_LOG_LEVEL=DEBUG
  kano-backlog item create --type task --title "Test" --product my-project --agent me
  ```

**KANO_DEBUG**
- **Purpose:** Enable debug mode (equivalent to `KANO_LOG_LEVEL=DEBUG`)
- **Values:** `1`, `true`, `yes` (case-insensitive)
- **Example:**
  ```bash
  export KANO_DEBUG=1
  kano-backlog doctor
  ```

### Environment Variable Precedence

Environment variables are overridden by:
1. CLI parameters (highest priority)
2. Profile settings
3. Config file settings
4. Environment variables
5. Built-in defaults (lowest priority)

**Example:**

```bash
# Environment variable sets default
export KANO_LOG_LEVEL=WARNING

# Config file overrides environment variable
# .kano/backlog_config.toml: [shared.log] debug = true

# CLI parameter overrides everything
kano-backlog item list --log-level ERROR
```

## Backlog Root Setup

### What is a Backlog Root?

The **backlog root** is the directory containing all backlog data for a product:
- `items/` - Work items (epics, features, tasks, bugs)
- `decisions/` - Architecture Decision Records (ADRs)
- `topics/` - Topic-based work organization
- `products/<product>/` - Product-specific views and configuration
- `_meta/` - Metadata and indexes

### Single Product Setup

For a single product, use the default backlog root:

```toml
# .kano/backlog_config.toml

[products.my-project]
name = "my-project"
prefix = "MP"
backlog_root = "_kano/backlog"
```

**Directory structure:**

```
my-project/
├── .kano/
│   └── backlog_config.toml
└── _kano/
    └── backlog/
        ├── items/
        ├── decisions/
        ├── topics/
        ├── products/
        │   └── my-project/
        └── _meta/
```

### Multiple Products in One Repository

Manage multiple products with separate backlog roots:

```toml
# .kano/backlog_config.toml

[products.frontend]
name = "frontend"
prefix = "FE"
backlog_root = "_kano/backlog/products/frontend"

[products.backend]
name = "backend"
prefix = "BE"
backlog_root = "_kano/backlog/products/backend"

[products.mobile]
name = "mobile"
prefix = "MOB"
backlog_root = "_kano/backlog/products/mobile"
```

**Directory structure:**

```
monorepo/
├── .kano/
│   └── backlog_config.toml
└── _kano/
    └── backlog/
        └── products/
            ├── frontend/
            │   ├── items/
            │   ├── decisions/
            │   └── products/frontend/
            ├── backend/
            │   ├── items/
            │   ├── decisions/
            │   └── products/backend/
            └── mobile/
                ├── items/
                ├── decisions/
                └── products/mobile/
```

**Benefits:**
- Isolated ID sequences per product
- Separate views and dashboards
- Independent configuration per product
- Shared project-level settings

### External Backlog References

Reference backlogs in other repositories:

```toml
# In project-a/.kano/backlog_config.toml

[products.project-a]
name = "project-a"
prefix = "PA"
backlog_root = "_kano/backlog"

[products.shared-lib]
name = "shared-lib"
prefix = "SL"
backlog_root = "../shared-library/_kano/backlog"
```

**Use cases:**
- Shared libraries tracked separately
- Microservices with cross-repo dependencies
- Monorepo with external dependencies

**Note:** Relative paths are resolved from the project root (where `.kano/backlog_config.toml` lives).

### Absolute Paths

Use absolute paths for system-wide backlogs:

```toml
[products.my-project]
name = "my-project"
prefix = "MP"
backlog_root = "/home/user/backlogs/my-project"
```

**When to use:**
- Shared team backlog on a network drive
- Centralized backlog management
- CI/CD environments with fixed paths

## Multi-Product Configuration

### Defining Multiple Products

Define all products in `.kano/backlog_config.toml`:

```toml
# .kano/backlog_config.toml

# Global defaults for all products
[defaults]
skill_developer = true
auto_refresh = true

# Product 1
[products.web-app]
name = "web-app"
prefix = "WEB"
backlog_root = "_kano/backlog/products/web-app"
vector_enabled = true

# Product 2
[products.api-server]
name = "api-server"
prefix = "API"
backlog_root = "_kano/backlog/products/api-server"
vector_enabled = true

# Product 3
[products.mobile-app]
name = "mobile-app"
prefix = "MOB"
backlog_root = "_kano/backlog/products/mobile-app"
vector_enabled = false  # Disable vector search for this product

# Shared settings
[shared.log]
debug = false

[shared.cache]
root = ".kano/cache/backlog"

[shared.vector]
enabled = true
backend = "sqlite"
metric = "cosine"
```

### Product-Specific Overrides

Override shared settings per product using product-specific config files:

```toml
# _kano/backlog/products/web-app/_config/config.toml

[log]
debug = true  # Enable debug logging for web-app only

[vector]
enabled = true
backend = "sqlite"
collection = "web-app-backlog"

[chunking]
target_tokens = 512
max_tokens = 1024
```

### Working with Multiple Products

**List all products:**

```bash
kano-backlog config show
```

**Create items in different products:**

```bash
# Create task in web-app
kano-backlog item create \
  --type task \
  --title "Add login page" \
  --product web-app \
  --agent your-name

# Create task in api-server
kano-backlog item create \
  --type task \
  --title "Implement auth endpoint" \
  --product api-server \
  --agent your-name
```

**List items per product:**

```bash
# List web-app items
kano-backlog item list --product web-app

# List api-server items
kano-backlog item list --product api-server
```

**Generate views per product:**

```bash
# Refresh web-app views
kano-backlog view refresh --product web-app --agent your-name

# Refresh api-server views
kano-backlog view refresh --product api-server --agent your-name
```

### Shared vs. Product-Specific Settings

**Shared settings** (apply to all products unless overridden):
- `[shared.log]` - Logging configuration
- `[shared.cache]` - Cache directory location
- `[shared.vector]` - Vector search settings
- `[shared.chunking]` - Chunking strategy
- `[shared.embedding]` - Embedding model configuration

**Product-specific settings** (defined per product):
- `name` - Product display name
- `prefix` - ID prefix (e.g., `WEB`, `API`, `MOB`)
- `backlog_root` - Where this product's data lives
- `vector_enabled` - Enable/disable vector search for this product
- `analysis_llm_enabled` - Enable/disable LLM analysis features

**Override precedence:**
1. Product-specific config file (`<backlog_root>/products/<product>/_config/config.toml`)
2. Product definition in project config (`.kano/backlog_config.toml` `[products.<name>]`)
3. Shared settings (`.kano/backlog_config.toml` `[shared.*]`)
4. Defaults (`.kano/backlog_config.toml` `[defaults]`)

## Configuration Validation

### Validate Your Configuration

Check if your configuration is valid:

```bash
kano-backlog config show
```

This displays the effective configuration for the default product, including:
- Merged settings from all layers
- Active profile (if any)
- Resolved paths

**Validate a specific product:**

```bash
kano-backlog config show --product my-project
```

**Validate with a profile:**

```bash
kano-backlog config show --profile embedding/gemini-embedding-001
```

### Common Configuration Errors

**Error: Project config required but not found**

```
ConfigError: Project config required but not found.
Create .kano/backlog_config.toml in project root.
```

**Solution:** Create `.kano/backlog_config.toml`:

```bash
kano-backlog backlog init --product my-project --agent your-name
```

**Error: Invalid TOML syntax**

```
ParseError: Invalid TOML syntax in .kano/backlog_config.toml at line 15
```

**Solution:** Validate TOML syntax:

```bash
python -c "import tomli; tomli.load(open('.kano/backlog_config.toml', 'rb'))"
```

**Error: Unknown product**

```
ConfigError: Product 'unknown-product' not found in .kano/backlog_config.toml
```

**Solution:** Add the product to your config:

```toml
[products.unknown-product]
name = "unknown-product"
prefix = "UP"
backlog_root = "_kano/backlog"
```

**Error: Backlog root does not exist**

```
ConfigError: Backlog root '_kano/backlog' does not exist
```

**Solution:** Initialize the backlog:

```bash
kano-backlog backlog init --product my-project --agent your-name
```

### Configuration Cache

kano-agent-backlog-skill caches the effective configuration to improve performance.

**Cache location:** `.kano/cache/effective_backlog_config.toml`

**When cache is updated:**
- When source config files change (detected via mtime)
- When you use `--profile` (creates `effective_runtime_backlog_config.toml`)
- When you run `kano-backlog config show`

**Clear the cache:**

```bash
rm -rf .kano/cache/effective_*.toml
```

The cache will be regenerated on the next command.

## Advanced Configuration

### Conditional Configuration

Use different settings based on environment:

```bash
# Development
export KANO_BACKLOG_CONFIG=".kano/backlog_config.dev.toml"
kano-backlog item list

# Production
export KANO_BACKLOG_CONFIG=".kano/backlog_config.prod.toml"
kano-backlog item list
```

### Configuration Templates

Create reusable configuration templates:

```bash
# Create a template
cat > .kano/backlog_config.template.toml << 'EOF'
[defaults]
skill_developer = true

[products.PRODUCT_NAME]
name = "PRODUCT_NAME"
prefix = "PREFIX"
backlog_root = "_kano/backlog"

[shared.log]
debug = false
EOF

# Use the template
cp .kano/backlog_config.template.toml .kano/backlog_config.toml
# Edit and replace PRODUCT_NAME and PREFIX
```

### Configuration Inheritance

Inherit settings from a base configuration:

```toml
# .kano/backlog_config.base.toml (base settings)
[shared.log]
debug = false

[shared.cache]
root = ".kano/cache/backlog"
```

```toml
# .kano/backlog_config.toml (project-specific)
# Note: Explicit inheritance not yet supported
# Workaround: Copy base settings or use profiles
```

**Workaround:** Use profiles for shared settings:

```bash
# Create a base profile
cat > .kano/backlog_config/base.toml << 'EOF'
[log]
debug = false

[cache]
root = ".kano/cache/backlog"
EOF

# Use it
kano-backlog item list --profile base
```

## Configuration Examples

### Example 1: Simple Single Product

```toml
# .kano/backlog_config.toml

[products.my-app]
name = "my-app"
prefix = "APP"
backlog_root = "_kano/backlog"

[shared.log]
debug = false

[shared.cache]
root = ".kano/cache/backlog"
```

### Example 2: Monorepo with Multiple Products

```toml
# .kano/backlog_config.toml

[defaults]
auto_refresh = true

[products.frontend]
name = "frontend"
prefix = "FE"
backlog_root = "_kano/backlog/products/frontend"
vector_enabled = true

[products.backend]
name = "backend"
prefix = "BE"
backlog_root = "_kano/backlog/products/backend"
vector_enabled = true

[products.shared]
name = "shared-lib"
prefix = "SH"
backlog_root = "_kano/backlog/products/shared"
vector_enabled = false

[shared.log]
debug = false

[shared.cache]
root = ".kano/cache/backlog"

[shared.vector]
enabled = true
backend = "sqlite"
metric = "cosine"
```

### Example 3: External Backlog Reference

```toml
# In project-a/.kano/backlog_config.toml

[products.project-a]
name = "project-a"
prefix = "PA"
backlog_root = "_kano/backlog"

[products.shared-lib]
name = "shared-lib"
prefix = "SL"
backlog_root = "../shared-library/_kano/backlog"

[shared.cache]
root = ".kano/cache/backlog"
```

### Example 4: Development vs. Production

**Development config:**

```toml
# .kano/backlog_config.dev.toml

[products.my-app]
name = "my-app-dev"
prefix = "DEV"
backlog_root = "_kano/backlog-dev"

[shared.log]
debug = true

[shared.cache]
root = "/tmp/kano-cache"
```

**Production config:**

```toml
# .kano/backlog_config.prod.toml

[products.my-app]
name = "my-app"
prefix = "APP"
backlog_root = "/var/lib/kano/backlog"

[shared.log]
debug = false

[shared.cache]
root = "/var/cache/kano"
```

**Usage:**

```bash
# Development
export KANO_BACKLOG_CONFIG=".kano/backlog_config.dev.toml"
kano-backlog item list

# Production
export KANO_BACKLOG_CONFIG=".kano/backlog_config.prod.toml"
kano-backlog item list
```

## Troubleshooting Configuration

### Issue: Configuration not loading

**Symptoms:**
- Commands fail with "config not found" errors
- Settings don't seem to apply

**Solution:**

1. Verify config file exists:
   ```bash
   ls -la .kano/backlog_config.toml
   ```

2. Validate TOML syntax:
   ```bash
   python -c "import tomli; tomli.load(open('.kano/backlog_config.toml', 'rb'))"
   ```

3. Check effective configuration:
   ```bash
   kano-backlog config show
   ```

### Issue: Profile not found

**Symptoms:**
- `--profile` flag fails with "profile not found"

**Solution:**

1. List available profiles:
   ```bash
   kano-backlog config list-profiles
   ```

2. Check profile path:
   ```bash
   ls -la .kano/backlog_config/embedding/
   ```

3. Use explicit path:
   ```bash
   kano-backlog embedding build --profile .kano/backlog_config/embedding/my-profile.toml
   ```

### Issue: Settings not overriding

**Symptoms:**
- Profile or product settings don't override project defaults

**Solution:**

1. Check configuration precedence (see [Configuration Precedence](#configuration-precedence))

2. Verify effective configuration:
   ```bash
   kano-backlog config show --profile my-profile
   ```

3. Use CLI parameters for highest priority:
   ```bash
   kano-backlog item list --log-level DEBUG
   ```

### Issue: Environment variables not working

**Symptoms:**
- Environment variables don't affect behavior

**Solution:**

1. Verify environment variable is set:
   ```bash
   echo $KANO_LOG_LEVEL
   ```

2. Check if config file overrides it:
   ```bash
   kano-backlog config show
   ```

3. Use CLI parameter to override everything:
   ```bash
   kano-backlog item list --log-level DEBUG
   ```

## Next Steps

Now that you understand configuration:

1. **Customize your setup** - Edit `.kano/backlog_config.toml` to match your workflow

2. **Create profiles** - Set up profiles for different embedding models or logging levels

3. **Explore multi-product** - If you have multiple products, configure them in one project

4. **Read the Quick Start** - See [Quick Start Guide](quick-start.md) for basic workflows

5. **Check the Installation Guide** - See [Installation Guide](installation.md) for troubleshooting

---

**Need help?** Run `kano-backlog config show` to see your effective configuration, or `kano-backlog doctor` to validate your environment.
