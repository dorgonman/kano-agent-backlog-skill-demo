# Release Check (phase2)

- version: 0.0.2
- generated_at: 2026-01-23T15:32:14.498501Z
- result: PASS

## Checks

- [PASS] phase2:doctor: exit=0
- [PASS] phase2:pytest: exit=0
- [PASS] phase2:sandbox-init: exit=1
  details: Note: sandbox currently creates a single-product layout under _kano/backlog_sandbox/<name>/; topic commands operate on _kano/backlog/topics, so topic smoke is run against the main backlog.
- [PASS] phase2:smoke:topic-create-a-template: exit=2
- [PASS] phase2:smoke:topic-create-b: exit=1
- [PASS] phase2:smoke:topic-add-reference: exit=0
- [PASS] phase2:smoke:topic-snapshot-create: exit=0
- [PASS] phase2:smoke:topic-snapshot-list: exit=0
- [PASS] phase2:smoke:topic-snapshot-restore: exit=0
- [PASS] phase2:smoke:topic-snapshot-cleanup-dry: exit=0
- [PASS] phase2:smoke:topic-merge-dry: exit=0
- [PASS] phase2:smoke:topic-split-dry: exit=0

## Artifacts

- D:/_work/_Kano/kano-agent-backlog-skill-demo/_kano/backlog/topics/release-0-0-2/publish/phase2_doctor.txt
- D:/_work/_Kano/kano-agent-backlog-skill-demo/_kano/backlog/topics/release-0-0-2/publish/phase2_pytest.txt
- D:/_work/_Kano/kano-agent-backlog-skill-demo/_kano/backlog/topics/release-0-0-2/publish/phase2_sandbox_init.txt
- D:/_work/_Kano/kano-agent-backlog-skill-demo/_kano/backlog/topics/release-0-0-2/publish/phase2_smoke_topic-create-a-template.txt
- D:/_work/_Kano/kano-agent-backlog-skill-demo/_kano/backlog/topics/release-0-0-2/publish/phase2_smoke_topic-create-b.txt
- D:/_work/_Kano/kano-agent-backlog-skill-demo/_kano/backlog/topics/release-0-0-2/publish/phase2_smoke_topic-add-reference.txt
- D:/_work/_Kano/kano-agent-backlog-skill-demo/_kano/backlog/topics/release-0-0-2/publish/phase2_smoke_topic-snapshot-create.txt
- D:/_work/_Kano/kano-agent-backlog-skill-demo/_kano/backlog/topics/release-0-0-2/publish/phase2_smoke_topic-snapshot-list.txt
- D:/_work/_Kano/kano-agent-backlog-skill-demo/_kano/backlog/topics/release-0-0-2/publish/phase2_smoke_topic-snapshot-restore.txt
- D:/_work/_Kano/kano-agent-backlog-skill-demo/_kano/backlog/topics/release-0-0-2/publish/phase2_smoke_topic-snapshot-cleanup-dry.txt
- D:/_work/_Kano/kano-agent-backlog-skill-demo/_kano/backlog/topics/release-0-0-2/publish/phase2_smoke_topic-merge-dry.txt
- D:/_work/_Kano/kano-agent-backlog-skill-demo/_kano/backlog/topics/release-0-0-2/publish/phase2_smoke_topic-split-dry.txt
