# 97 — Linear Congruential Generator

A classic power-of-two linear congruential generator (LCG), a Hull-Dobell full-period check on a small modulus, and a quarter-circle Monte Carlo hit count.

## Parameters

- Main generator: `m = 65536`, `a = 25173`, `c = 13849`, starting at `state = 1`.
- Toy Hull-Dobell check: `m = 16`, `a = 5`, `c = 3` (full period `16`).
- Quarter-circle test: `1000` uniform `(x, y)` pairs in `[0, 1)^2` counting points with `x^2 + y^2 <= 1`.

## Files

| File | Description |
|---|---|
| [01_lcg.f90](01_lcg.f90) | `lcg_t` generator, period check, and Monte Carlo quarter-circle count |
