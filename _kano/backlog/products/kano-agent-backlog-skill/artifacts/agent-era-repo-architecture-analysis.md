# Agent-Era Repository Architecture Analysis

**Date**: 2026-01-10  
**Context**: GitHub Mobile "New Agent Session" limitations and multi-repo coordination challenges

## Executive Summary

The emergence of AI agent tooling has revealed a fundamental architectural constraint: **agent sessions are repo-scoped**. This creates significant friction for multi-repo projects and provides new advantages for monorepo architectures in agent-driven development workflows.

## Key Finding: Repo Boundaries = Agent Boundaries

### GitHub Mobile Agent Session Limitations (Dec 2025)

GitHub's "New Agent Session" feature demonstrates the constraint:
- Agent sessions bind to a single repository's working tree and permissions
- Cross-repo changes require multiple separate sessions and PRs
- Context and decision continuity is lost between repositories
- No atomic commit/PR unit spanning multiple repos

### Impact on Multi-Repo Projects

**Fragmentation Problems:**
- Same requirement → multiple agent sessions → multiple PRs
- Decision context scattered across repositories
- Agent handoffs lose planning artifacts and context
- Atomic acceptance becomes complex coordination problem

**Example Scenario:**
```
Requirement: "Add user authentication"
Multi-repo reality:
├── Session 1: API repo (auth endpoints)
├── Session 2: Frontend repo (login UI) 
├── Session 3: Database repo (user schema)
└── Manual coordination required for consistency
```

## Architectural Implications

### Monorepo Advantages in Agent Era

1. **Agent-Native Atomicity**
   - One session, one PR, one acceptance gate
   - Complete context available in single workspace
   - Cross-module changes handled atomically

2. **Decision Continuity**
   - Planning artifacts stay with implementation
   - Agent can see full impact of changes
   - Reduced "decision evaporation" between repos

3. **Simplified Coordination**
   - No cross-repo dependency management
   - Single CI/CD pipeline for related changes
   - Unified acceptance criteria

### Multi-Repo Mitigation Strategies

If polyrepo is unavoidable (e.g., Unreal Engine constraints, organizational boundaries):

1. **Coordination Artifacts**
   - Cross-repo work items with dependency tracking
   - Shared planning documents and decision records
   - Multi-PR tracking and atomic acceptance protocols

2. **Contract-First Development**
   - API/Schema definitions as coordination points
   - Version-controlled interfaces between repos
   - Agent works on contracts before implementations

3. **Orchestration Layer**
   - Centralized backlog system (cloud-based)
   - Bid/dispatch protocols for cross-repo work
   - Shared context graphs for agent handoffs

## Recommendations

### For New Projects
- **Prefer monorepo** for agent-driven development
- Design module boundaries within single repo
- Use workspace/folder organization instead of repo separation

### For Existing Multi-Repo Projects
- Implement coordination artifacts and protocols
- Consider cloud backlog system for cross-repo planning
- Evaluate selective monorepo migration for tightly coupled components

### For Cloud Backlog Systems
- Design for multi-repo coordination as primary use case
- Provide cross-repo dependency tracking
- Support agent context handoffs between repositories

## Conclusion

**In the agent era, repository boundaries become agent collaboration boundaries.** 

Monorepo architecture provides natural advantages for agent-driven development by aligning technical boundaries with agent session capabilities. Multi-repo projects require additional coordination infrastructure to achieve the same level of agent collaboration effectiveness.

This analysis supports the architectural decisions in:
- KABSD-FTR-0010 (Monorepo Platform Migration)
- KABSD-EPIC-0007 (Cloud Security & Access Control)
- Future multi-repo coordination features

---

**References:**
- [GitHub Blog: More direct access to agent session creation](https://github.blog/changelog/2025-12-16-more-direct-access-to-agent-session-creation-across-github-mobile/)
- KABSD-FTR-0010: Monorepo Platform Migration
- KABSD-EPIC-0007: Roadmap - Cloud security & access control