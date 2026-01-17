# MVP Validation Checklist: Vector Backend

This checklist validates the MVP implementation of the pluggable vector backend.

- [ ] **Interface Compliance**:
  - [ ] `get_backend()` factory returns the correct adapter based on config.
  - [ ] Adapter implements all ABC methods (`prepare`, `upsert`, `delete`, `query`, `persist`, `load`).
- [ ] **Functional Test (NoOp/Memory)**:
  - [ ] Can `upsert` a mock vector.
  - [ ] Can `query` and receive results (mocked or real).
  - [ ] `persist` and `load` do not crash.
- [ ] **Integration Stub**:
  - [ ] Can instantiate backend from `kano_backlog_cli` (via factory).
  - [ ] Config loading respects `vector.backend` setting.
- [ ] **Performance Baseline** (Future):
  - [ ] Define max acceptable latency for query (e.g., <50ms for 10k vectors).
