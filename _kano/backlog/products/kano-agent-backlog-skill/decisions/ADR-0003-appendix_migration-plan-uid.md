---
uid: 019bc5dc-68d9-70ca-b86b-88b64de16d79
---

# Migration Plan: Add uid to Existing Items

A migration plan to add a UUIDv7 `uid` field to existing backlog items.

## Overview

Existing backlog items currently only have `id` (display ID). Per ADR-0003, each item needs a `uid` (UUIDv7) as the immutable primary key.

**Key Decisions (ADR-0003):**
- `uid` format: UUIDv7 (RFC 9562)
- Filenames remain unchanged (`<id>_<slug>.md`)
- `uid` is added only in frontmatter

## Migration Steps

### Phase 1: Preparation

1. **Back up the current backlog**
   ```bash
   cp -r _kano/backlog _kano/backlog_backup_$(date +%Y%m%d)
   ```

2. **Ensure a UUIDv7 library is available**
   - Python: `uuid6` package or Python 3.12+ built-in
   - Install: `pip install uuid6`

### Phase 2: Migration script

Create `scripts/backlog/migration_add_uid.py`:

```python
#!/usr/bin/env python3
"""
Add uid (UUIDv7) to existing backlog items.

Usage:
    python migration_add_uid.py --dry-run  # Preview changes
    python migration_add_uid.py --apply    # Apply changes
"""
import uuid6  # or uuid (Python 3.12+)

def generate_uid():
    """Generate a UUIDv7 string."""
    return str(uuid6.uuid7())

def extract_uidshort(uid: str, length: int = 8) -> str:
    """Extract uidshort (first N hex chars, no hyphens)."""
    return uid.replace("-", "")[:length]
```

**Script capabilities:**
1. Scan all `.md` files under `_kano/backlog/items/`
2. Parse frontmatter
3. If `uid` is missing, generate a UUIDv7 and add it
4. Update the `updated` field
5. Write changes back to the file

### Phase 3: Handle parent/link references

**Backward-compatibility strategy (incremental):**

1. **Keep the existing `parent` field** (by display id)
2. **Optionally add `parent_uid`**
3. A Resolver tool maps `parent` to the actual uid

```yaml
# Before migration
parent: KABSD-FTR-0042

# After migration (backward compatible)
parent: KABSD-FTR-0042
parent_uid: 019473f2-79b0-7cc3-98c4-dc0c0c07398f  # optional
```

### Phase 4: Validation

1. Run a verification script to ensure every item has a `uid`
2. Verify `uid` format correctness (UUIDv7)
3. Verify dashboards render correctly

## Frontmatter schema changes

### New fields

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `uid` | string | Required (post-migration) | UUIDv7, immutable |
| `parent_uid` | string | Optional | Parent item's uid |
| `aliases` | list | Optional | Legacy IDs or alternate names |

### Example

```yaml
---
id: KABSD-TSK-0059
uid: 019473f2-79b0-7cc3-98c4-dc0c0c07398f
type: Task
title: "ULID vs UUIDv7 comparison document"
state: Done
priority: P3
parent: KABSD-FTR-0042
parent_uid: 019473e8-1234-7abc-5678-def012345678  # optional
# ... rest of frontmatter
---
```

## uidshort specification

| Property | Value |
|----------|-------|
| Length | 8 characters |
| Source | First 8 hex characters of `uid` (no hyphens) |
| Example | `019473f2` |
| Usage | Human-friendly reference `KABSD-TSK-0059@019473f2` |

## Risks / Mitigations

| Risk | Mitigation |
|------|------------|
| Migration failure causing data corruption | Back up first; provide a dry-run mode |
| `uid` collisions | Extremely unlikely with UUIDv7; add validation checks |
| Tool incompatibility | Backward-compatible: keep `parent`, add `parent_uid` |

## Implementation order

1. [ ] Create `migration_add_uid.py`
2. [ ] Test in sandbox
3. [ ] Dry-run preview
4. [ ] Back up and perform migration
5. [ ] Verify results
6. [ ] Update related tools to support uid resolution