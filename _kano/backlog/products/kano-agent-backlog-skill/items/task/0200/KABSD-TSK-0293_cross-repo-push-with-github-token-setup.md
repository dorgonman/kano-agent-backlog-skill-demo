---
id: KABSD-TSK-0293
uid: 019be6eb-472a-778a-a5eb-2923a2c1cd2e
type: Task
title: "Cross-repo Push with GitHub Token Setup"
state: Done
priority: P2
parent: KABSD-FTR-0057
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

The documentation pipeline needs to push built static site files from the Demo repo workflow to the Skill repo's gh-pages branch. GitHub's default GITHUB_TOKEN is repo-scoped and cannot write to external repositories.

ChatGPT identified this as a critical platform limitation: workflows using GITHUB_TOKEN for cross-repo pushes will fail with permission errors. A fine-grained Personal Access Token (PAT) is required.

# Goal

Implement secure cross-repository push mechanism that:
- Uses fine-grained PAT with minimal required permissions
- Pushes built documentation from Demo repo to Skill repo gh-pages branch
- Handles authentication and error scenarios gracefully
- Follows GitHub security best practices

# Non-Goals

- Using GITHUB_TOKEN for cross-repo operations (not supported)
- Implementing GitHub App authentication (overkill for this use case)
- Real-time synchronization or bidirectional sync
- Complex branch management or merge conflict resolution

# Approach

**Token Setup:**
1. Create fine-grained PAT with Contents: Read/Write permission on Skill repo
2. Store as SKILL_REPO_TOKEN secret in Demo repo
3. Use token in git remote URL for push operations

**Push Implementation:**
```bash
# Configure git with token
git config --global user.name "GitHub Actions"
git config --global user.email "actions@github.com"

# Add remote with token authentication
git remote add skill-origin https://${{ secrets.SKILL_REPO_TOKEN }}@github.com/owner/skill-repo.git

# Push to gh-pages branch
git push skill-origin HEAD:gh-pages --force
```

**Error Handling:**
- Validate token permissions before push
- Provide clear error messages for common failures
- Implement retry logic for transient network issues

# Alternatives

- **GitHub App**: More complex setup, requires app installation
- **SSH Deploy Keys**: Requires key management, less flexible
- **Classic PAT**: Broader permissions, less secure than fine-grained
- **Manual deployment**: Defeats automation purpose

# Acceptance Criteria

- [ ] Fine-grained PAT created with Contents: Read/Write on Skill repo
- [ ] SKILL_REPO_TOKEN secret configured in Demo repo
- [ ] Workflow can authenticate and push to Skill repo gh-pages branch
- [ ] Push operation overwrites gh-pages content with new build
- [ ] Error handling provides clear feedback on authentication failures
- [ ] Token permissions are minimal (only Contents: Read/Write, no admin access)
- [ ] Push operation is idempotent (can run multiple times safely)

# Risks / Dependencies

**Security Risks:**
- PAT token exposure in logs or error messages
- Token with excessive permissions
- Token expiration causing workflow failures
- Unauthorized access if token is compromised

**Technical Risks:**
- GitHub API rate limiting on push operations
- Network failures during push
- Git conflicts if gh-pages branch has unexpected changes
- Token-triggered workflows not firing (GitHub limitation)

**Dependencies:**
- Fine-grained PAT creation and management
- Demo repo secrets configuration access
- Skill repo exists and has gh-pages branch enabled
- GitHub Pages configured to serve from gh-pages branch

**Mitigation:**
- Use fine-grained PAT with minimal permissions
- Set token expiration and renewal reminders
- Implement force push to avoid conflicts
- Add token validation step before push
- Never log token values or git URLs with embedded tokens

# Worklog

2026-01-23 02:15 [agent=amazonq] Created item
2026-01-23 08:20 [agent=amazonq] Implemented cross-repo push with SKILL_REPO_TOKEN authentication in workflow
