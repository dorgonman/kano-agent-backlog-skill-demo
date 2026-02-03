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

7) Tag the release (both repos)

This workspace contains a git submodule (`skills/kano-agent-backlog-skill`). For a real release, tag:

- The **skill repo** (inside the submodule), and
- The **demo repo** (this repo), which pins the submodule commit.

Recommended convention:
- Tag name: `v<version>` (e.g. `v0.0.3`) in both repos.
- Use annotated tags.

Commands:

```bash
# Confirm submodule is at the intended release commit
git -C skills/kano-agent-backlog-skill status --porcelain=v1
git -C skills/kano-agent-backlog-skill rev-parse HEAD

# 1) Tag the skill repo at the intended skill commit
git -C skills/kano-agent-backlog-skill tag -a v<version> -m "kano-agent-backlog-skill v<version>"

# 2) Tag the demo repo after the submodule pointer commit is in place
git tag -a v<version> -m "kano-agent-backlog-skill-demo v<version>"
```

Verification:

```bash
git -C skills/kano-agent-backlog-skill tag --list "v<version>"
git tag --list "v<version>"

# Optional: see what each tag points to
git -C skills/kano-agent-backlog-skill show --no-patch v<version>
git show --no-patch v<version>
```

Notes:
- Tagging in the submodule does not automatically tag the parent repo; they must be created separately.
- Pushing tags is intentionally omitted here (human-driven). If you publish, you must push tags for both repos.

## 0.0.3 Playbook (What We Learned)

This section captures the practical workflow that worked for the 0.0.3 release.

### Say This To Your Agent

Copy/paste one of these depending on the state:

1) Initial release prep

"Prepare release <version> for kano-agent-backlog-skill. Run Phase1 + Phase2 release checks and tell me what fails. Then update README + docs/releases + skill docs/releases + skill CHANGELOG until Phase1 passes. Ensure Phase2 uses a sandbox so smoke topics do not land in _kano/backlog/topics."

2) Fix Phase1 mismatch

"Run Phase1 release check for <version>. If it fails due to README/version mismatch, fix README and rerun Phase1 until PASS."

3) Fix Phase2 pollution

"Run Phase2 release check for <version> using --sandbox <name>. Verify smoke topics are created under _kano/backlog_sandbox/<name>/ and not under _kano/backlog/topics/. If older smoke topics exist in main backlog, delete them."

### Phase1 (Version + Docs Consistency)

Command:

```bash
python skills/kano-agent-backlog-skill/scripts/kano-backlog admin release check \
  --version <version> \
  --topic release-<version-dashed> \
  --agent <agent-id> \
  --phase phase1 \
  --product kano-agent-backlog-skill
```

Expected output (report):
- `_kano/backlog/topics/release-<version-dashed>/publish/release_check_<version>_phase1.md`

Common 0.0.3 failure mode:
- `version:README: mismatch (expected=<version>, actual=<older>)`
  - Fix: update `README.md` banner + “Current Status” + any explicit release text.
  - Then rerun Phase1.

### Phase2 (Doctor + Pytest + Topic Smoke)

Command:

```bash
python skills/kano-agent-backlog-skill/scripts/kano-backlog admin release check \
  --version <version> \
  --topic release-<version-dashed> \
  --agent <agent-id> \
  --phase phase2 \
  --product kano-agent-backlog-skill \
  --sandbox release-<version-dashed>-smoke
```

Expected output (report + artifacts):
- `_kano/backlog/topics/release-<version-dashed>/publish/release_check_<version>_phase2.md`
- `_kano/backlog/topics/release-<version-dashed>/publish/phase2_*.txt`

0.0.3 learning: avoid committing test smoke topics

- Phase2 runs topic smoke commands.
- Those topics must be created in a sandbox root under `_kano/backlog_sandbox/<sandbox>/...` (gitignored).
- If you see these paths under the main backlog, they are pollution from older runs:
  - `_kano/backlog/topics/release-<version-dashed>-smoke-a/`
  - `_kano/backlog/topics/release-<version-dashed>-smoke-b/`

Cleanup guidance:
- Delete the polluted directories under `_kano/backlog/topics/`.
- Re-run Phase2 with `--sandbox ...`.

### Document Outputs (Required)

For each release version, update or create:
- `README.md`
- `docs/releases/<version>.md`
- `skills/kano-agent-backlog-skill/docs/releases/<version>.md`
- `skills/kano-agent-backlog-skill/CHANGELOG.md`

### Git Hygiene Notes

- `_kano/backlog_sandbox/` is ignored by `.gitignore` and is the correct place for disposable smoke outputs.
- Prefer committing only canonical docs + code changes. Avoid committing derived artifacts and scratch data.
- For this repo, commits should be explicitly requested by the human (e.g. "commit now: <intent>").

### Tagging (After Phase1 + Phase2 PASS)

0.0.3 learning: treat tagging as an explicit, final step after the reports are green and docs are updated.

Checklist:
- Phase1 report is PASS (version/docs consistency).
- Phase2 report is PASS (doctor/pytest/sandboxed smoke).
- Release notes exist in both locations:
  - `docs/releases/<version>.md`
  - `skills/kano-agent-backlog-skill/docs/releases/<version>.md`
- The demo repo commit that pins the submodule commit exists.

Then create tags in both repos (see Checklist step 7).

## Notes

- `brief.generated.md` is tool-owned and overwritten by `topic distill`.
- `brief.md` is human-owned and should remain stable across iterations.
- Keep “shared index across different embedding models” out of scope unless explicitly decided; default to per-model indexes keyed by an explicit `embedding_space_id`.

