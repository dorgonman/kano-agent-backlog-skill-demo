# Welcome to Kano Agent Backlog Skill Demo

This repository demonstrates the capabilities of the **Kano Agent Backlog Skill** - a local-first, file-based backlog management system for AI agent collaboration.

## Quick Start

### 1. Clone the repository
```bash
git clone https://github.com/dorgonman/kano-agent-backlog-skill-demo.git
cd kano-agent-backlog-skill-demo
```

### 2. Initialize submodules
```bash
git submodule update --init --recursive
```

### 3. Install the skill
```bash
python -m pip install -e skills/kano-agent-backlog-skill
```

### 4. Verify installation
```bash
kano --help
```

### 5. Explore the demo backlog
```bash
# List work items
kano item list --product kano-agent-backlog-skill
```

## Official Documentation

For comprehensive documentation, including detailed guides and API references, please visit our [Official Documentation Website](https://dorgonman.github.io/kano-agent-backlog-skill).
