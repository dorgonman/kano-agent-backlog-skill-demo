---
type: Index
for: KABSD-FTR-0004
title: "Backlog config system and process profiles Index"
updated: 2026-01-10
---

# MOC

- [[KABSD-USR-0006_create-backlog-config-root-under-kano-backlog|KABSD-USR-0006 Create backlog config root under _kano/backlog]] (state: Proposed)
  - [[KABSD-TSK-0017_define-config-root-layout-and-baseline-config-file|KABSD-TSK-0017 Define config root layout and baseline config file]] (state: Done)
  - [[KABSD-TSK-0018_add-config-loader-for-skill-scripts|KABSD-TSK-0018 Add config loader for skill scripts]] (state: Done)
- [[KABSD-USR-0007_support-log-verbosity-and-debug-flags-in-config|KABSD-USR-0007 Support log verbosity and debug flags in config]] (state: Proposed)
  - [[KABSD-TSK-0019_define-log-verbosity-and-debug-config-keys|KABSD-TSK-0019 Define log verbosity and debug config keys]] (state: Done)
  - [[KABSD-TSK-0020_wire-logging-scripts-to-config-verbosity|KABSD-TSK-0020 Wire logging scripts to config verbosity]] (state: Done)
- [[KABSD-USR-0008_define-board-process-profiles-for-work-item-types-and-transitions|KABSD-USR-0008 Define board process profiles for work item types and transitions]] (state: Proposed)
  - [[KABSD-TSK-0021_design-process-profile-schema|KABSD-TSK-0021 Design process profile schema]] (state: Done)
  - [[KABSD-TSK-0022_draft-initial-process-profiles-agile-scrum-cmmi|KABSD-TSK-0022 Draft initial process profiles (Agile/Scrum/CMMI)]] (state: Done)
- [[KABSD-USR-0009_ship-built-in-process-definitions-and-select-via-config|KABSD-USR-0009 Ship built-in process definitions and select via config]] (state: Done)
  - [[KABSD-TSK-0023_ship-built-in-process-definition-files|KABSD-TSK-0023 Ship built-in process definition files]] (state: Done)
  - [[KABSD-TSK-0024_add-config-selector-for-process-profile|KABSD-TSK-0024 Add config selector for process profile]] (state: Done)
  - [[KABSD-TSK-0042_add-process-profile-template-and-document-built-ins|KABSD-TSK-0042 Add process profile template and document built-ins]] (state: Done)
  - [[KABSD-TSK-0043_add-jira-process-profile-and-align-schema-docs|KABSD-TSK-0043 Add Jira process profile and align schema docs]] (state: Done)
- [[KABSD-USR-0010_introduce-backlog-sandbox-path-for-tests|KABSD-USR-0010 Introduce backlog sandbox path for tests]] (state: Proposed)
  - [[KABSD-TSK-0025_define-backlog-sandbox-path-and-guardrails|KABSD-TSK-0025 Define backlog sandbox path and guardrails]] (state: Done)
  - [[KABSD-TSK-0026_update-test-scripts-to-use-backlog-sandbox|KABSD-TSK-0026 Update test scripts to use backlog sandbox]] (state: Done)
  - [[KABSD-TSK-0027_add-user-story-validation-test-script|KABSD-TSK-0027 Add user story validation test script]] (state: Done)
- [[KABSD-USR-0023_automated-backlog-realign-tool|KABSD-USR-0023 Automated backlog realignment tool]] (state: InProgress)
- [[KABSD-TSK-0037_review-and-improve-config-system-implementation|KABSD-TSK-0037 Review and improve config system implementation]] (state: Dropped)
- [[KABSD-TSK-0038_review-and-improve-config-system-implementation|KABSD-TSK-0038 Review and improve config system implementation]] (state: Done)
- [[KABSD-TSK-0039_add-config-access-helpers-and-defaults-loader|KABSD-TSK-0039 Add config access helpers and defaults loader]] (state: Done)
- [[KABSD-TSK-0040_document-config-defaults-and-env-override-rules|KABSD-TSK-0040 Document config defaults and env override rules]] (state: Done)
- [[KABSD-TSK-0041_add-lightweight-config-validation|KABSD-TSK-0041 Add lightweight config validation]] (state: Done)
- [[KABSD-TSK-0087_initialize-backlog-scaffold-from-active-process-profile|KABSD-TSK-0087 Initialize backlog scaffold from active process profile]] (state: Done)
- [[KABSD-TSK-0088_add-process-linter-to-validate-profile-based-folder-scaffolds|KABSD-TSK-0088 Add process_linter to validate profile-based folder scaffolds]] (state: Done)
- [[KABSD-TSK-0126_improve-process-profile-migration-with-original-type-preservation|KABSD-TSK-0126 Improve process profile migration with original type preservation]] (state: Done)
- [[KABSD-TSK-0146_clarify-config-replace-mode-role-with-mode-skill-developer-persona|KABSD-TSK-0146 Clarify config: replace mode.role with mode.skill_developer + persona]] (state: Done)
- [[KABSD-TSK-0147_persona-aware-project-summary-generation-in-view-refresh-dashboards|KABSD-TSK-0147 Persona-aware project summary generation in view_refresh_dashboards]] (state: Proposed)

## Auto list (Dataview)

```dataview
table id, state, priority
from "_kano/backlog/products/kano-agent-backlog-skill/items"
where parent = "KABSD-FTR-0004"
sort priority asc
```

