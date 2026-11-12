# 78 — Hash Maps

This chapter demonstrates an associative map from integer keys to integer values
using **open addressing with linear probing**:

- **Modulo Hashing**: `mod(abs(key), capacity) + 1` distributes keys directly into array slots
- **Tombstone Markers**: When a key is deleted, its slot cannot simply be marked empty,
  as doing so would prematurely terminate probe searches for colliding keys inserted later.
  A `STATE_TOMBSTONE` marker preserves probe continuity while allowing new insertions to reuse the slot.
- **Dynamic Resizing**: When the load factor reaches 0.5 ($N \ge \text{capacity} / 2$),
  the table capacity doubles with `move_alloc` and all active entries are rehashed.

## Examples

| File | Topic |
|---|---|
| [01_hash_map.f90](01_hash_map.f90) | Open addressing hash map with linear probing and tombstone deletion |
