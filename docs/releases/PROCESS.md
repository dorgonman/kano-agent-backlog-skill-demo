# Release Process (Demo Repo)

This repo treats releases as a **documentation + backlog milestone** exercise.
Keep everything local-first and auditable (no server runtime).

## Checklist

1) Pick the release version (e.g., `0.0.2`) and confirm the milestone Epic (e.g., `KABSD-EPIC-0003`).

2) Update the human-facing version references
- `README.md` (top banner + “Current Status” section)
- `docs/releases/<version>.md`
- `skills/kano-agent-backlog-skill/docs/releases/<version>.md`

3) Ensure the release focus topics are in a reviewable state
- Run `topic distill` to refresh `brief.generated.md` (do not overwrite `brief.md`)
- Close finished topics (`kano-backlog topic close ...`) and prune snapshots if needed

4) Generate/merge changelog entries (optional but recommended)
- Generate: `python skills/kano-agent-backlog-skill/scripts/kano-backlog changelog generate --version <version> --product kano-agent-backlog-skill`
- Merge into `CHANGELOG.md`: `python skills/kano-agent-backlog-skill/scripts/kano-backlog changelog merge-unreleased --version <version>`

5) Attach release notes to the milestone Epic (recommended)
- `python skills/kano-agent-backlog-skill/scripts/kano-backlog workitem attach-artifact <EPIC_ID> --path docs/releases/<version>.md --no-shared --product kano-agent-backlog-skill --backlog-root-override _kano/backlog --agent <agent-id> --note "Attach release notes"`

6) Refresh views (if dashboards are used)
- `python skills/kano-agent-backlog-skill/scripts/kano-backlog view refresh --agent <agent-id> --product kano-agent-backlog-skill`

## Notes

- `brief.generated.md` is tool-owned and overwritten by `topic distill`.
- `brief.md` is human-owned and should remain stable across iterations.
- Keep “shared index across different embedding models” out of scope unless explicitly decided; default to per-model indexes keyed by an explicit `embedding_space_id`.

