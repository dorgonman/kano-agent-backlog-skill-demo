# Quick Reference - Kano Agent Backlog Skill Demo

## Project Overview

This repository demonstrates the `kano-agent-backlog-skill` - a local-first, file-based backlog system that creates an auditable decision trail for agent collaboration.

## Key Files

- `PROJECT_STATUS.md` - Comprehensive project status and statistics
- `ACTIVE_WORK.md` - Current InProgress work items
- `AGENTS.md` - Agent workflow instructions and rules
- `CLAUDE.md` - Claude-specific workflow notes
- `README.md` - Repository README

## Backlog Location

All backlog items are stored in: `_kano/backlog/products/`

- **kano-agent-backlog-skill**: 176 items (57% done)
- **kano-commit-convention-skill**: 15 items (7% done)

## Quick Commands

### Initialize Submodules
```bash
git submodule update --init --recursive
```

### View Backlog Statistics

#### Count items by type
```bash
find _kano/backlog/products/kano-agent-backlog-skill/items -type f -name "*.md" ! -name "*.index.md" | wc -l
```

#### Count items by state
```bash
grep -r "^state:" _kano/backlog/products/kano-agent-backlog-skill/items/ | grep -v ".index.md" | cut -d':' -f3 | sort | uniq -c | sort -rn
```

#### Find InProgress items
```bash
grep -l "^state: InProgress" _kano/backlog/products/*/items/*/*.md _kano/backlog/products/*/items/*/*/*.md 2>/dev/null | grep -v ".index.md"
```

### Generate Views (when submodules initialized)

```bash
# Generate active work view
python skills/kano-agent-backlog-skill/scripts/backlog/view_generate.py \
  --groups "New,InProgress" \
  --title "Active Work" \
  --output _kano/backlog/views/Dashboard_PlainMarkdown_Active.md

# Generate new work view
python skills/kano-agent-backlog-skill/scripts/backlog/view_generate.py \
  --groups "New" \
  --title "New Work" \
  --output _kano/backlog/views/Dashboard_PlainMarkdown_New.md

# Generate done work view
python skills/kano-agent-backlog-skill/scripts/backlog/view_generate.py \
  --groups "Done" \
  --title "Done Work" \
  --output _kano/backlog/views/Dashboard_PlainMarkdown_Done.md
```

## Work Item States

- **New**: Newly created, not yet started
- **Ready**: Ready to be picked up (all ready criteria met)
- **InProgress**: Currently being worked on
- **Planned**: Scheduled for future work
- **Proposed**: Idea/proposal, not yet planned
- **Done**: Completed
- **Dropped**: Decided not to pursue

## Work Item Types

- **Epic**: Large initiative (e.g., milestones)
- **Feature**: Significant functionality
- **UserStory**: User-facing capability
- **Task**: Technical work item
- **Bug**: Defect to fix

## Current Focus Areas

1. **Milestone 0.0.2** (KABSD-EPIC-0003) - Indexing + Resolver
2. **Product-aware CLI** (KABSD-TSK-0083) - P1 priority
3. **Artifact System** (KABSD-FTR-0009)
4. **Multi-product governance** (KABSD-FTR-0011)

## Workflow Principles

1. **Plan before code**: Create/update backlog items before making changes
2. **English only**: All backlog content must be in English
3. **Append-only worklog**: Never rewrite history
4. **Ready gate**: Tasks/Bugs must have Context, Goal, Approach, Acceptance Criteria, and Risks/Dependencies before starting
5. **Auditable**: Use skill scripts for operations to maintain audit trail

## Getting Help

- See `AGENTS.md` for detailed agent workflow rules
- See `CLAUDE.md` for Claude-specific backlog workflow
- Check `_kano/backlog/README.md` for backlog structure

## Health Status (as of 2026-01-08)

✅ **Strengths**:
- 101 items completed (57%)
- Well-organized structure
- Active development

⚠️ **Attention Needed**:
- 5 items in InProgress (should be completed or moved)
- Submodules need initialization
- Views need regeneration with current data
