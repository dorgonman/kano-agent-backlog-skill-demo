# Topic Template System Design

## Overview

This document outlines the design for a topic template system that provides predefined templates for common workflows while maintaining simplicity and extensibility.

## Template Schema

### Template Structure

```json
{
  "name": "research",
  "display_name": "Research Topic",
  "description": "Template for research and investigation topics",
  "version": "1.0.0",
  "author": "kano-agent-backlog-skill",
  "created_at": "2026-01-17T23:59:00Z",
  "tags": ["research", "investigation"],
  "structure": {
    "directories": [
      "materials/clips",
      "materials/links", 
      "materials/extracts",
      "materials/logs",
      "synthesis",
      "publish"
    ],
    "files": {
      "brief.md": "templates/research/brief.md.template",
      "notes.md": "templates/research/notes.md.template"
    }
  },
  "manifest_defaults": {
    "status": "open",
    "has_spec": false
  },
  "variables": {
    "research_question": {
      "type": "string",
      "description": "Main research question or hypothesis",
      "required": true
    },
    "domain": {
      "type": "string", 
      "description": "Research domain (e.g., technical, business, user)",
      "default": "technical"
    }
  }
}
```

### Template File Content

Templates use simple variable substitution with `{{variable_name}}` syntax:

```markdown
# Topic Brief: {{topic_name}}

**Research Question**: {{research_question}}
**Domain**: {{domain}}
**Status**: 🔍 **INVESTIGATING** | **Created**: {{created_date}}

## Research Objectives

- [ ] {{research_question}}
- [ ] Identify key findings and evidence
- [ ] Document conclusions and recommendations

## Methodology

{{#if domain == "technical"}}
- Code analysis and documentation review
- Performance testing and benchmarking
- Architecture evaluation
{{/if}}

{{#if domain == "business"}}
- Market research and competitive analysis
- Stakeholder interviews
- Business case development
{{/if}}

## Key Findings

<!-- Update as research progresses -->
- [ ] Finding 1 — [source](ref)
- [ ] Finding 2 — [source](ref)

## Open Questions

- [ ] {{research_question}} sub-questions
- [ ] Validation needed for findings
- [ ] Next steps and follow-up research

## Evidence Collection

### Primary Sources
- [ ] Documentation review
- [ ] Code analysis
- [ ] Expert consultation

### Secondary Sources  
- [ ] Literature review
- [ ] Case studies
- [ ] Best practices research

## Conclusions

<!-- To be completed -->
- **Recommendation**: TBD
- **Confidence Level**: TBD
- **Next Actions**: TBD

---
*Research template v1.0 - systematic investigation workflow*
```

## Storage Structure

### Template Location

Templates will be stored in the skill directory to ensure consistency across installations:

```
skills/kano-agent-backlog-skill/
  templates/
    _schema.json                    # Template schema definition
    research/
      template.json                 # Template metadata
      brief.md.template            # Brief template
      notes.md.template            # Notes template
    feature/
      template.json
      brief.md.template
      notes.md.template
      spec/                        # Optional spec templates
        requirements.md.template
        design.md.template
        tasks.md.template
    bugfix/
      template.json
      brief.md.template
      notes.md.template
    refactor/
      template.json
      brief.md.template
      notes.md.template
```

### Custom Templates

Users can create custom templates in their product directory:

```
_kano/backlog/products/<product>/
  _config/
    templates/                     # Custom templates override built-ins
      custom-workflow/
        template.json
        brief.md.template
        notes.md.template
```

## Template Resolution

Template resolution follows this priority order:

1. Product-specific custom templates (`_kano/backlog/products/<product>/_config/templates/`)
2. Built-in skill templates (`skills/kano-agent-backlog-skill/templates/`)

## CLI Integration

### Enhanced Create Command

```bash
# Create with template
kano topic create research-auth-system --template research --agent kiro

# Interactive template selection
kano topic create research-auth-system --interactive --agent kiro

# List available templates
kano topic create --list-templates

# Create custom template
kano topic template create my-workflow --from research --agent kiro
```

### Template Management Commands

```bash
# List templates
kano topic template list

# Show template details
kano topic template show research

# Validate template
kano topic template validate my-custom-template

# Create new template from existing topic
kano topic template export my-topic --name my-workflow --agent kiro
```

## Implementation Plan

### Phase 1: Core Template System

1. **Template Schema and Validation**
   - Define JSON schema for templates
   - Implement template validation logic
   - Create template loader with resolution priority

2. **Built-in Templates**
   - Research template (investigation, analysis)
   - Feature template (development workflow)
   - Bugfix template (issue investigation and resolution)
   - Refactor template (code improvement workflow)

3. **CLI Integration**
   - Extend `topic create` command with `--template` option
   - Add template listing and validation commands
   - Implement variable substitution engine

### Phase 2: Advanced Features

1. **Custom Templates**
   - Template creation from existing topics
   - Custom template validation
   - Template sharing and export

2. **Interactive Creation**
   - Template selection wizard
   - Variable prompting
   - Preview before creation

3. **Template Management**
   - Template versioning
   - Template updates and migration
   - Template usage analytics

## Template Definitions

### Research Template

**Purpose**: Systematic investigation and analysis
**Use Cases**: Technical research, competitive analysis, feasibility studies

**Structure**:
- Structured research methodology
- Evidence collection framework
- Findings and conclusions tracking
- Source citation and validation

### Feature Template  

**Purpose**: Feature development workflow
**Use Cases**: New feature planning, enhancement development

**Structure**:
- Requirements gathering
- Design and architecture planning
- Implementation tracking
- Testing and validation

### Bugfix Template

**Purpose**: Issue investigation and resolution
**Use Cases**: Bug reports, system issues, performance problems

**Structure**:
- Problem description and reproduction
- Root cause analysis
- Solution development and testing
- Verification and documentation

### Refactor Template

**Purpose**: Code improvement and technical debt reduction
**Use Cases**: Architecture improvements, code cleanup, performance optimization

**Structure**:
- Current state analysis
- Improvement objectives
- Refactoring plan and milestones
- Impact assessment and validation

## Benefits

### Consistency
- Standardized topic structure across teams
- Common workflow patterns and best practices
- Reduced setup time for new topics

### Efficiency  
- Pre-configured directory structure
- Template-specific content and guidance
- Faster topic creation and context switching

### Quality
- Built-in best practices and methodologies
- Structured approach to common workflows
- Improved documentation and knowledge capture

## Risks and Mitigations

### Template Proliferation
**Risk**: Too many templates leading to confusion
**Mitigation**: Limit to essential patterns, clear naming conventions, template validation

### Over-Engineering
**Risk**: Complex template system that's hard to use
**Mitigation**: Keep templates simple, focus on structure over content, gradual feature rollout

### Maintenance Overhead
**Risk**: Templates become outdated or inconsistent
**Mitigation**: Version templates, automated validation, community feedback integration

## Success Metrics

### Adoption
- Percentage of topics created with templates
- Template usage distribution
- User feedback and satisfaction

### Efficiency
- Reduced topic creation time
- Improved topic structure consistency
- Faster context switching and knowledge transfer

### Quality
- Better documentation completeness
- More structured workflow execution
- Reduced rework and clarification needs