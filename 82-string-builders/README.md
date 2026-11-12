# 82 — String Builders

Building a string by executing `s = s // piece` repeatedly in a loop performs
$O(N^2)$ character copies because each concatenation allocates a new deferred-length
character string and copies the entire prefix.

A **string builder** avoids quadratic work by maintaining a geometric-growth
character buffer (`len(buf)` doubling via `move_alloc`) alongside a `used` cursor,
slicing `buf(1:used)` once at the end.

## Examples

| File | Topic |
|---|---|
| [01_builder.f90](01_builder.f90) | Amortized $O(1)$ append string builder using `move_alloc` |
