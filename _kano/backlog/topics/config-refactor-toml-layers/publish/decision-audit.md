# Decision Write-back Audit: config-refactor-toml-layers

Generated: 2026-01-19T04:15:35.664531Z

## Summary

- Decisions found in synthesis: 27
- Workitems checked: 7
- Workitems with decisions: 7
- Workitems missing decisions: 0

## Decisions (from synthesis)

1. 1. TOML Table Merge Semantics (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
2. Use **recursive deep merge** matching current JSON behavior. (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
3. Consistency with existing ConfigLoader._deep_merge() (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
4. Allows partial overrides (e.g., override only `log.verbosity` without replacing entire `[log]` table) (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
5. TOML standard doesn't define merge behavior; we control it at load time (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
6. 2. Dual Format Support Duration (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
7. Support both JSON and TOML for **2 minor versions** (e.g., 0.8.x, 0.9.x) before TOML-only in 1.0. (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
8. Gives users time to migrate (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
9. Allows gradual rollout across teams (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
10. Emit deprecation warnings when JSON is loaded (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
11. v0.8.0: Add TOML support, JSON still works (deprecation warning) (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
12. v0.9.0: Migration tool available, JSON deprecated (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
13. v1.0.0: TOML-only, remove JSON loader (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
14. 3. Multi-Repo Registry Location (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
15. Embed registry entries in global `~/.kano/config.toml` using `[[registry]]` array. (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
16. Simpler for v1 (one file to manage) (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
17. TOML array-of-tables syntax is clean (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
18. Can split to `registry.toml` later if it grows (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
19. 4. Auth Credential Strategy (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
20. Environment variables only for v1; no secrets in config files. (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
21. `JIRA_TOKEN`, `JIRA_USER`, `JIRA_PASSWORD` (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
22. `AZURE_DEVOPS_TOKEN` (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
23. `BACKLOG_API_TOKEN` (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
24. Generic: `KANO_BACKEND_{NAME}_TOKEN` (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
25. Keeps config files safe to version control (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
26. Standard practice for CLI tools (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)
27. Credential manager integration deferred to v2 (source: `_kano\backlog\topics\config-refactor-toml-layers\synthesis\toml-config-schema-v1.md`)

## Workitems Missing Decision Write-back

- (none)


## Workitems With Decision Write-back

- `_kano\backlog\products\kano-agent-backlog-skill\items\feature\0000\KABSD-FTR-0024_global-config-layers-and-uri-compilation.md`
- `_kano\backlog\products\kano-agent-backlog-skill\items\task\0100\KABSD-TSK-0187_refactor-config-resolution-using-topic-workset-overlays.md`
- `_kano\backlog\products\kano-agent-backlog-skill\items\task\0100\KABSD-TSK-0191_define-toml-config-schema-and-migration-strategy.md`
- `_kano\backlog\products\kano-agent-backlog-skill\items\task\0100\KABSD-TSK-0192_implement-toml-parser-with-deep-merge-and-validation.md`
- `_kano\backlog\products\kano-agent-backlog-skill\items\task\0100\KABSD-TSK-0193_implement-uri-compilation-from-human-friendly-config-fields.md`
- `_kano\backlog\products\kano-agent-backlog-skill\items\task\0100\KABSD-TSK-0194_add-cli-commands-config-show-and-config-validate.md`
- `_kano\backlog\products\kano-agent-backlog-skill\items\task\0100\KABSD-TSK-0195_build-json-to-toml-migration-tool-with-validation.md`
