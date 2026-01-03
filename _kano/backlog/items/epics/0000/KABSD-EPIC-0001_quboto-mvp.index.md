---
type: Index
for: KABSD-EPIC-0001
title: "Quboto_MVP Index"
updated: 2026-01-02
---

# MOC

- [[KABSD-FTR-0001_local-backlog-system|KABSD-FTR-0001 Local-first backlog system]]
  - [[KABSD-USR-0001_plan-before-code|KABSD-USR-0001 Plan work before coding]]
    - [[_kano/backlog/items/tasks/0000/KABSD-TSK-0001_project-backlog-skill|KABSD-TSK-0001 Create project-backlog skill]]
- [[KABSD-FTR-0002_tts-service-ops|KABSD-FTR-0002 TTS service operations]]
  - [[KABSD-USR-0002_test-tts-flow|KABSD-USR-0002 Test TTS flow locally]]
    - [[KABSD-TSK-0002_define-tts-service-plan|KABSD-TSK-0002 Define TTS service plan]]
- [[KABSD-FTR-0003_stt-service-ops|KABSD-FTR-0003 STT service operations]]
  - [[KABSD-USR-0003_test-stt-flow|KABSD-USR-0003 Test STT flow locally]]
    - [[KABSD-TSK-0003_define-stt-model-plan|KABSD-TSK-0003 Define STT model plan]]
- [[KABSD-FTR-0004_secret-provider-workflow|KABSD-FTR-0004 Secret provider workflow]]
  - [[KABSD-USR-0004_manage-secrets-across-providers|KABSD-USR-0004 Manage secrets across providers]]
    - [[KABSD-TSK-0004_define-secret-provider-plan|KABSD-TSK-0004 Define secret provider plan]]
    - [[KABSD-TSK-0006_document-secret-provider-docs|KABSD-TSK-0006 Document secret provider docs]]
    - [[KABSD-TSK-0007_define-secret-provider-validation|KABSD-TSK-0007 Define secret provider validation]]
- [[KABSD-FTR-0005_vllm-litellm-ops|KABSD-FTR-0005 vLLM + LiteLLM operations]]
  - [[KABSD-USR-0005_console-llm-smoke-test|KABSD-USR-0005 Console LLM smoke test]]
    - [[KABSD-TSK-0005_define-vllm-litellm-console-test|KABSD-TSK-0005 Define vLLM/LiteLLM console test]]

## Auto list (Dataview)

```dataview
table id, state, priority
from "_kano/backlog/items/features"
where parent = "KABSD-EPIC-0001"
sort priority asc
```

