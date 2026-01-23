---
id: KABSD-EPIC-0012
uid: 019be6eb-120a-70c9-9489-edfad4e95f71
type: Epic
title: "Official Documentation Website with GitHub Pages"
state: Done
priority: P2
parent: null
area: general
iteration: backlog
tags: []
created: 2026-01-23
updated: 2026-01-23
owner: None
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
---

# Context

The skill needs an official documentation website to provide comprehensive documentation, examples, and guides for users. The current documentation is scattered across README files and needs to be consolidated into a professional, searchable website.

ChatGPT provided a detailed technical approach using Quartz as the documentation engine with GitHub Pages for hosting, including multi-repo content integration and automated publishing pipeline.

# Goal

Establish a professional documentation website for the kano-agent-backlog-skill using:
- Quartz as the documentation engine (static site generator)
- GitHub Pages for hosting (published to Skill repo's gh-pages branch)
- Automated pipeline that builds from Demo repo and publishes to Skill repo
- Multi-repo content integration (Quartz engine + Demo docs + Skill docs)

# Non-Goals

- Custom documentation platform development
- Real-time documentation updates
- User authentication or private documentation sections
- Integration with external documentation platforms

# Approach

**Pipeline Architecture:**
1. Workflow in Demo repo triggers on version tags (v*.*.*)  
2. Multi-checkout: Quartz (engine) + Demo (content) + Skill (content)
3. Content "cooking" using white-list manifest to select files
4. Quartz build generates static site
5. Cross-repo push to Skill repo's gh-pages branch
6. GitHub Pages serves the site

**Key Components:**
- Node 22 + `npx quartz build` for static site generation
- Fine-grained PAT (SKILL_REPO_TOKEN) for cross-repo push permissions
- Manifest-based content selection to avoid noise
- Fixed workspace layout for predictable build paths

# Alternatives

- **GitBook/Notion**: Requires external platform dependency
- **Jekyll/Hugo**: Less specialized for documentation than Quartz
- **Docusaurus**: More complex setup, React-based
- **MkDocs**: Python-based, but Quartz has better linking features

# Acceptance Criteria

- [ ] Quartz + GitHub Pages publishing pipeline operational
- [ ] Multi-repo checkout and content integration working
- [ ] Cross-repo push mechanism with proper token setup
- [ ] Release trigger workflow (tag v*.*.* → build + publish)
- [ ] Website accessible at Skill repo GitHub Pages URL
- [ ] Documentation displays properly with navigation and search
- [ ] Content cooking strategy prevents noise/unwanted files
- [ ] Build artifacts can be packaged for releases

# Risks / Dependencies

**Technical Risks:**
- Cross-repo push permissions: GitHub's GITHUB_TOKEN is repo-scoped, requires fine-grained PAT
- Token-triggered workflows: GITHUB_TOKEN pushes don't trigger some downstream workflows
- Node/Quartz version compatibility issues
- Build workspace path conflicts or permission issues

**Dependencies:**
- Quartz documentation engine (external repo)
- GitHub Pages configuration on Skill repo
- Fine-grained Personal Access Token with Contents: Read/Write on Skill repo
- Node 22 runtime in GitHub Actions
- Stable file structure in Demo and Skill repos for content selection

**Mitigation:**
- Use fine-grained PAT stored as SKILL_REPO_TOKEN secret
- Test workflow with dry-run capabilities
- Pin Node version and Quartz dependencies
- Implement manifest-based content selection for stability

# Worklog

2026-01-23 02:15 [agent=amazonq] Created item
2026-01-23 08:20 [agent=amazonq] Auto parent sync: child KABSD-FTR-0057 -> Done; parent -> Done.
