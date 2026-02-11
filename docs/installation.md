# Installation Guide

This guide covers installing kano-agent-backlog-skill, system requirements, virtual environment setup, optional dependencies, and troubleshooting common issues.

## System Requirements

### Required

- **Python**: 3.8 or higher (3.10+ recommended)
- **SQLite**: Version 3.8.0 or higher (usually included with Python)
- **pip**: Python package installer (usually included with Python)
- **Operating System**: Linux, macOS, or Windows

### Recommended

- **Virtual environment**: venv, virtualenv, or conda
- **Disk space**: ~50 MB for base installation, ~2 GB with vector dependencies
- **Memory**: 512 MB minimum, 2 GB+ recommended for vector search features

### Verify Your System

Check your Python version:

```bash
python --version
# or
python3 --version
```

You should see Python 3.8.0 or higher.

Check SQLite availability:

```bash
python -c "import sqlite3; print(sqlite3.sqlite_version)"
```

You should see a version number (e.g., `3.35.5`).

## Installation Methods

### Method 1: Install from PyPI (Recommended)

Install the latest stable release:

```bash
pip install kano-agent-backlog-skill
```

**Verify installation:**

```bash
kano-backlog --version
```

You should see the version number (e.g., `0.1.0`).

### Method 2: Install in a Virtual Environment (Best Practice)

Using a virtual environment isolates the package and its dependencies from your system Python.

**Using venv (Python 3.3+):**

```bash
# Create a virtual environment
python -m venv kano-env

# Activate the virtual environment
# On Linux/macOS:
source kano-env/bin/activate
# On Windows (PowerShell):
.\kano-env\Scripts\Activate.ps1
# On Windows (Command Prompt):
.\kano-env\Scripts\activate.bat

# Install kano-agent-backlog-skill
pip install kano-agent-backlog-skill

# Verify installation
kano-backlog --version
```

**Using conda:**

```bash
# Create a conda environment
conda create -n kano-env python=3.11

# Activate the environment
conda activate kano-env

# Install kano-agent-backlog-skill
pip install kano-agent-backlog-skill

# Verify installation
kano-backlog --version
```

**Deactivating the environment:**

```bash
# For venv:
deactivate

# For conda:
conda deactivate
```

### Method 3: Install from Source (Development)

For contributors or those who want the latest development version:

```bash
# Clone the repository
git clone https://github.com/kano-ai/kano-agent-backlog-skill.git
cd kano-agent-backlog-skill

# Create and activate a virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .\.venv\Scripts\Activate.ps1

# Install in editable mode with development dependencies
pip install -e ".[dev]"

# Verify installation
kano-backlog --version
```

## Optional Dependencies

kano-agent-backlog-skill supports optional feature groups that can be installed separately.

### Development Tools (`[dev]`)

Install development and testing tools:

```bash
pip install "kano-agent-backlog-skill[dev]"
```

**Includes:**
- `pytest` - Testing framework
- `pytest-cov` - Test coverage reporting
- `hypothesis` - Property-based testing
- `black` - Code formatter
- `mypy` - Static type checker
- `ruff` - Fast Python linter

**Use when:**
- Contributing to the project
- Running tests locally
- Developing custom extensions

### Vector Search (`[vector]`)

Install machine learning dependencies for semantic search and embeddings:

```bash
pip install "kano-agent-backlog-skill[vector]"
```

**Includes:**
- `sentence-transformers` - Embedding models
- `numpy` - Numerical computing
- `torch` - PyTorch deep learning framework

**Use when:**
- You need semantic search across backlog items
- You want to find similar items by meaning
- You're working with large backlogs (100+ items)

**Note:** This adds ~1.5 GB of dependencies. Only install if you need vector search features.

### Install Multiple Extras

Combine multiple optional dependency groups:

```bash
# Install both dev and vector dependencies
pip install "kano-agent-backlog-skill[dev,vector]"
```

## Post-Installation Validation

After installation, validate your environment:

```bash
kano-backlog doctor
```

This command checks:
- ✅ Python version compatibility (>= 3.8)
- ✅ SQLite availability and version
- ✅ Required directories and permissions
- ✅ Configuration file validity
- ✅ Optional dependencies status

**Expected output:**

```
Environment Check Results:
✅ Python version: 3.11.5 (>= 3.8 required)
✅ SQLite version: 3.42.0 (>= 3.8.0 required)
✅ Write permissions: OK
⚠️  Optional [vector] dependencies: Not installed
✅ Configuration: Valid

All critical checks passed!
```

## Upgrading

### Upgrade to Latest Version

```bash
pip install --upgrade kano-agent-backlog-skill
```

### Upgrade to Specific Version

```bash
pip install kano-agent-backlog-skill==0.2.0
```

### Check Current Version

```bash
pip show kano-agent-backlog-skill
# or
kano-backlog --version
```

## Uninstalling

Remove kano-agent-backlog-skill:

```bash
pip uninstall kano-agent-backlog-skill
```

**Note:** This does not remove your backlog data (stored in `_kano/backlog/`). Your work items, ADRs, and configuration remain intact.

## Troubleshooting

### Issue: `kano-backlog: command not found`

**Cause:** The installation directory is not in your PATH.

**Solution 1:** Ensure you're in the correct virtual environment:

```bash
# Check if virtual environment is activated
which python  # Should show path to venv/bin/python

# If not activated, activate it:
source kano-env/bin/activate  # Linux/macOS
.\kano-env\Scripts\Activate.ps1  # Windows PowerShell
```

**Solution 2:** Add pip's user installation directory to PATH:

```bash
# Linux/macOS (add to ~/.bashrc or ~/.zshrc):
export PATH="$HOME/.local/bin:$PATH"

# Windows: Add to PATH environment variable:
# %APPDATA%\Python\Python311\Scripts
```

**Solution 3:** Use `python -m` to run the CLI:

```bash
python -m kano_backlog_cli.cli --version
```

### Issue: `ImportError: No module named 'kano_backlog_core'`

**Cause:** Package not installed or installed incorrectly.

**Solution:**

```bash
# Reinstall the package
pip uninstall kano-agent-backlog-skill
pip install kano-agent-backlog-skill

# Verify installation
pip list | grep kano
```

### Issue: `sqlite3.OperationalError: no such table`

**Cause:** Backlog database not initialized.

**Solution:**

```bash
# Initialize a new backlog
kano-backlog backlog init --product my-project --agent your-name

# Or run doctor to diagnose
kano-backlog doctor
```

### Issue: Python version too old

**Cause:** Python < 3.8 is not supported.

**Solution:** Install Python 3.8 or higher:

```bash
# Check available Python versions
python3 --version
python3.11 --version

# Use a specific Python version for venv
python3.11 -m venv kano-env
source kano-env/bin/activate
pip install kano-agent-backlog-skill
```

### Issue: Permission denied when installing

**Cause:** Trying to install to system Python without sudo.

**Solution 1:** Use a virtual environment (recommended):

```bash
python -m venv kano-env
source kano-env/bin/activate
pip install kano-agent-backlog-skill
```

**Solution 2:** Install to user directory:

```bash
pip install --user kano-agent-backlog-skill
```

**Solution 3:** Use sudo (not recommended):

```bash
sudo pip install kano-agent-backlog-skill
```

### Issue: `ModuleNotFoundError: No module named 'sentence_transformers'`

**Cause:** Vector search dependencies not installed.

**Solution:**

```bash
# Install vector dependencies
pip install "kano-agent-backlog-skill[vector]"
```

### Issue: Slow installation with `[vector]` dependencies

**Cause:** PyTorch and ML libraries are large (~1.5 GB).

**Solution:**

- **Use a faster mirror:**
  ```bash
  pip install --index-url https://download.pytorch.org/whl/cpu "kano-agent-backlog-skill[vector]"
  ```

- **Install CPU-only PyTorch (smaller):**
  ```bash
  pip install kano-agent-backlog-skill
  pip install torch --index-url https://download.pytorch.org/whl/cpu
  pip install sentence-transformers numpy
  ```

- **Skip vector dependencies if not needed:**
  ```bash
  pip install kano-agent-backlog-skill
  # Vector search features will not be available
  ```

### Issue: `kano-backlog doctor` reports configuration errors

**Cause:** Invalid YAML syntax or missing required fields in config files.

**Solution:**

```bash
# Check config file location
ls ~/.kano/backlog_config.toml
ls .kano/backlog_config.toml

# Validate YAML syntax
python -c "import tomli; tomli.load(open('.kano/backlog_config.toml', 'rb'))"

# Reset to default config
rm .kano/backlog_config.toml
kano-backlog backlog init --product my-project --agent your-name
```

### Issue: Write permission errors

**Cause:** Insufficient permissions to write to backlog directory.

**Solution:**

```bash
# Check permissions
ls -la _kano/backlog/

# Fix permissions (Linux/macOS)
chmod -R u+w _kano/backlog/

# Run as administrator (Windows)
# Right-click PowerShell -> Run as Administrator
```

### Issue: Conflicts with other packages

**Cause:** Dependency version conflicts with other installed packages.

**Solution:** Use a dedicated virtual environment:

```bash
# Create a fresh environment
python -m venv kano-fresh-env
source kano-fresh-env/bin/activate

# Install only kano-agent-backlog-skill
pip install kano-agent-backlog-skill

# Verify no conflicts
pip check
```

## Platform-Specific Notes

### Linux

- **Debian/Ubuntu:** Install Python development headers if building from source:
  ```bash
  sudo apt-get install python3-dev python3-pip python3-venv
  ```

- **Fedora/RHEL:** Install Python development tools:
  ```bash
  sudo dnf install python3-devel python3-pip
  ```

### macOS

- **Homebrew Python:** If using Homebrew Python, ensure pip is up to date:
  ```bash
  python3 -m pip install --upgrade pip
  ```

- **System Python:** Avoid using system Python (`/usr/bin/python`). Install Python via Homebrew:
  ```bash
  brew install python@3.11
  ```

### Windows

- **PowerShell Execution Policy:** If activation fails, enable script execution:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

- **Long Path Support:** Enable long paths for deep directory structures:
  ```powershell
  # Run as Administrator
  New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
  ```

- **Windows Subsystem for Linux (WSL):** kano-agent-backlog-skill works in WSL2. Follow Linux instructions.

## Getting Help

If you encounter issues not covered here:

1. **Run diagnostics:**
   ```bash
   kano-backlog doctor
   ```

2. **Check the Quick Start Guide:** [quick-start.md](quick-start.md)

3. **Review configuration:** [configuration.md](configuration.md)

4. **Search existing issues:** [GitHub Issues](https://github.com/kano-ai/kano-agent-backlog-skill/issues)

5. **Report a bug:** [Create a new issue](https://github.com/kano-ai/kano-agent-backlog-skill/issues/new)

## Next Steps

Once installation is complete:

1. **Follow the Quick Start Guide:** [quick-start.md](quick-start.md) - Create your first backlog in 5-10 minutes

2. **Configure your environment:** [configuration.md](configuration.md) - Set up profiles and preferences

3. **Explore the CLI:** Run `kano-backlog --help` to see all available commands

4. **Read the workflow guide:** See [AGENTS.md](../AGENTS.md) for best practices on using the backlog system

---

**Installation complete?** Head to the [Quick Start Guide](quick-start.md) to create your first backlog!
