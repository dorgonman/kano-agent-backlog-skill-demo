# ULID vs UUIDv7 Comparison

Technical comparison to inform ADR-0003 uid format choice

## Summary

| Characteristic | ULID | UUIDv7 |
|----------------|------|--------|
| Length | 128 bits | 128 bits |
| String length | 26 chars (Base32) | 36 chars (hex + hyphens) |
| Timestamp | 48 bits (ms) | 48 bits (ms) |
| Random part | 80 bits | 74 bits (minus version/variant) |
| Standardization | Community convention | IETF RFC 9562 |
| Ordering | Lexicographically sortable | Lexicographically sortable |
| Readability | Shorter, no hyphens | Standard UUID format |

## Detailed comparison

### 1. Format and readability

**ULID**
```
01AN4Z07BY79KA1307SR9X4MV3
|----------|----------------|
 Timestamp    Randomness
  (10 ch)      (16 ch)
```
- Uses Crockford's Base32 (excludes I, L, O, U to avoid confusion)
- Uppercase, no hyphens
- 26 characters

**UUIDv7**
```
017f22e2-79b0-7cc3-98c4-dc0c0c07398f
|-------|    |  |    |
  time  ver  var  random
```
- Standard UUID format (8-4-4-4-12)
- Hexadecimal with hyphens
- 36 characters

### 2. Ordering characteristics

| Aspect | ULID | UUIDv7 |
|--------|------|--------|
| Lexicographic ordering | ✅ Fully supported | ✅ Fully supported |
| Same-millisecond ordering | Monotonic increment | Counter/random |
| Cross-machine ordering | Time precision only | Time precision only |

Both reflect time order correctly under lexicographic sort.

### 3. Collision safety

| Aspect | ULID | UUIDv7 |
|--------|------|--------|
| Random entropy | 80 bits | ~74 bits |
| Same-ms collision rate | 2^-80 | 2^-74 |
| Theoretical security | Extremely high | Extremely high |

In practice, both have negligible collision probability.

### 4. Library support

**ULID**
- Python: `python-ulid`, `ulid-py`
- JavaScript: `ulid` (official)
- Go: `oklog/ulid`
- Community-driven, broad multi-language coverage

**UUIDv7**
- Python: `uuid6` (backport for <3.x), built-in planned in Python 3.12+
- JavaScript: `uuid@9+`
- Go: `google/uuid`
- **IETF standardized** (RFC 9562); mainstream UUID libraries are adding support

### 5. uidshort prefix length guidance

**ULID**
- First 10 characters = timestamp part
- Recommended uidshort: 8-10 characters (covers time + partial randomness)
- Example: `01AN4Z07BY` → 8 characters `01AN4Z07`

**UUIDv7**
- First 8 characters (no hyphens) = high bits of timestamp
- Recommended uidshort: 8-12 characters (hex)
- Example: `017f22e2-79b0-7...` → 8 characters `017f22e2`

## Recommendation

### Initial analysis recommendation: ULID

| Advantage | Notes |
|-----------|-------|
| Shorter | 26 vs 36 characters; cleaner filenames |
| More readable | No hyphens; visually cleaner |
| Sufficient entropy | 80-bit randomness; extremely low collision risk |
| Mature ecosystem | Years of use; stable library support |
| Filename-friendly | No special characters; compatible across filesystems |

### Advantages of UUIDv7

- Standardization: IETF RFC 9562; strong long-term stability
- Compatibility: Works with existing UUID infrastructure (e.g., database UUID columns)
- Future-proofing: Python 3.12+ and mainstream libraries add native support

---

## Final decision (2026-01-06)

**Adopt UUIDv7**

Choose UUIDv7 for these reasons:
1. IETF standardization provides stronger long-term stability
2. Compatible with existing UUID ecosystems
3. Native support in mainstream languages is arriving

**uidshort length: 8 characters (hex prefix)**
- Example: `017f22e2-79b0-7...` → `017f22e2`

## References

- [ULID Spec](https://github.com/ulid/spec)
- [RFC 9562 - UUIDv7](https://www.rfc-editor.org/rfc/rfc9562)
- [python-ulid](https://github.com/mdomke/python-ulid)
