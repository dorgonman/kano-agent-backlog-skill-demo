# Topic Notes: Topic System Enhancements

## Overview

This topic covers systematic enhancements to the topic system, focusing on improving usability, workflow efficiency, and intelligent automation. The goal is to evolve topics from basic context management to a comprehensive knowledge management system.

## Related Items

**6 Feature Items (All Ready)**:
- FTR-0043: Topic Templates - Standardize common workflows
- FTR-0044: Cross-References - Lightweight topic linking (avoid complex dependencies)
- FTR-0045: Snapshots - Safe experimentation and rollback
- FTR-0046: Merge/Split - Flexible topic reorganization
- FTR-0047: Analytics - Usage insights and optimization
- FTR-0048: Smart Suggestions - AI-powered discovery (depends on embedding search)

## Key Decisions

**Decision: Phased Implementation Approach**
- Rationale: Avoid big-bang changes, validate each enhancement before building on it
- Phase 1: Core usability (templates, cross-refs)
- Phase 2: Advanced operations (snapshots, merge/split)
- Phase 3: Intelligence features (analytics, AI suggestions)

**Decision: Lightweight Cross-References Over Complex Dependencies**
- Rationale: User concern about creating "another backlog system"
- Solution: Simple "see also" links, no blocking/dependency management
- Implementation: Wiki-style references in brief.md

**Decision: Local-First Design**
- All features must work without external dependencies
- Optional features (like AI suggestions) degrade gracefully
- Privacy-preserving analytics (local data only)

## Open Questions

- Should templates be stored in skill directory or per-product?
- How many cross-references per topic before it becomes noise? (proposed limit: 5-10)
- Should snapshots include materials/ directory or just core files?
- What analytics are most valuable without being invasive?
- Integration strategy with existing embedding search system?

## Implementation Notes

**Start with FTR-0043 (Templates)**:
- Provides immediate value
- Establishes patterns for other features
- Low risk, high impact

**Cross-Reference Design**:
- Add `related_topics: List[str]` to TopicManifest
- Bidirectional linking by default
- Auto-generate "Related Topics" section in brief.md

**Snapshot Strategy**:
- Store in `.cache/snapshots/<topic>/<name>/`
- Include: manifest.json, brief.md, notes.md, key synthesis files
- Exclude: raw materials (too large, can be regenerated)

## Risk Mitigation

- **Feature Creep**: Stick to phased approach, validate each phase
- **Complexity**: Keep each feature simple and focused
- **Performance**: Monitor impact on topic operations
- **User Adoption**: Start with high-value, low-friction features
