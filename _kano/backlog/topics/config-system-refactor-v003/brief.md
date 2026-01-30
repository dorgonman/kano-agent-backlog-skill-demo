# Topic Brief: Config System Refactor v0.0.3

Generated: 2026-01-30T00:02:52.303090Z

## Overview

Major architectural improvement to the kano-agent-backlog-skill configuration system, introducing project-level configuration support for multi-product backlog management. This is a key feature for v0.0.3 release.

## Facts

<!-- Verified facts with citations to materials/items/docs -->
- [x] Project-level config system implemented — [KABSD-FTR-0063](../../items/feature/0000/KABSD-FTR-0063_simplify-multi-product-config-with-project-level-kano-config-toml.md)
- [x] Core data structures created (ProjectConfig, ProductDefinition) — [project_config.py](../../skills/kano-agent-backlog-skill/src/kano_backlog_core/project_config.py)
- [x] Configuration precedence hierarchy updated — [KABSD-TSK-0322](../../items/task/0000/KABSD-TSK-0322_update-config-resolution-logic-with-precedence-hierarchy.md)
- [x] CLI integration completed — [util.py updates](../../skills/kano-agent-backlog-skill/src/kano_backlog_cli/util.py)
- [x] Backward compatibility maintained — [implementation doc](../../skills/kano-agent-backlog-skill/references/project-config-implementation.md)
- [x] Real-world validation successful (kano-opencode-quickstart external management) — [test results](../../skills/kano-agent-backlog-skill/references/test-new-config.py)

## Key Features Delivered

- **Multi-product management**: Single `.kano/backlog_config.toml` manages multiple products
- **Flexible backlog roots**: Support for relative/absolute paths pointing anywhere
- **Configuration precedence**: CLI > Workset > Topic > Project Product Overrides > Project Config > Product Config > Defaults
- **Product-specific overrides**: Each product can have custom settings
- **Shared configuration**: Common settings across all products
- **Automatic product detection**: Smart product resolution when not specified

## Unknowns / Risks

<!-- Open questions and potential blockers -->
- [ ] Migration strategy for existing large-scale deployments
- [ ] Performance impact with many products in single config file
- [ ] Validation of complex nested configuration scenarios

## Proposed Actions

<!-- Concrete next steps, linked to workitems -->
- [ ] Add CLI --config-file parameter support → [KABSD-TSK-0323](../../items/task/0000/KABSD-TSK-0323_add-cli-support-for-config-file-parameter.md)
- [ ] Create migration tools for existing setups → [KABSD-TSK-0324](../../items/task/0000/KABSD-TSK-0324_create-migration-tools-for-existing-multi-product-setups.md)
- [ ] Document new configuration system → [KABSD-TSK-0325](../../items/task/0000/KABSD-TSK-0325_document-new-project-level-config-system.md)
- [ ] Create comprehensive test suite for edge cases → new ticket needed
- [ ] Performance benchmarking with large config files → new ticket needed

## Decision Candidates

<!-- Tradeoffs requiring ADR -->
- [x] Configuration file naming: `.kano/backlog_config.toml` chosen for clarity
- [ ] Default behavior when both project and product configs exist → ADR needed
- [ ] Environment variable expansion in backlog_root paths → design decision needed
- [ ] Validation strictness level (fail fast vs. graceful degradation) → ADR needed

## Release Impact

This refactor is a **major feature** for v0.0.3:
- Enables enterprise-scale multi-product management
- Simplifies configuration maintenance
- Provides foundation for advanced features
- Maintains full backward compatibility

## Success Metrics

- [x] All existing functionality preserved
- [x] External product management working (kano-opencode-quickstart)
- [x] Configuration precedence working correctly
- [x] CLI commands work with new system
- [ ] Migration tools available
- [ ] Documentation complete
- [ ] Performance benchmarks acceptable

---
_This brief is human-maintained. `topic distill` writes to `brief.generated.md`._