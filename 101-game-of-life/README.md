# 101 — Conway's Game of Life

One generation of Conway's Game of Life on a `5x5` integer grid with fixed dead edges (`0`).

## Behaviour

- Initialises a vertical blinker at `(2,3)`, `(3,3)`, `(4,3)`.
- The centre cell `(3,3)` has `2` live neighbours and survives; `(3,2)` and `(3,4)` each have `3` live neighbours and turn on; `(2,3)` and `(4,3)` each have `1` live neighbour and die.
- Prints the updated `5x5` grid and total live cell count (`3`).

## Files

| File | Description |
|---|---|
| [01_game_of_life.f90](01_game_of_life.f90) | Single-step blinker evolution and live cell count |
