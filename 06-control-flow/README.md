# 06 — Control Flow

Branching, looping, scoping constructs and program termination.

## Examples

| File | Topic |
|---|---|
| [01_if.f90](01_if.f90) | `if` statement, `if … else if … else … end if`, named |
| [02_select_case.f90](02_select_case.f90) | `select case` with lists, ranges, characters, logicals |
| [03_do_loops.f90](03_do_loops.f90) | Counted, `do while`, infinite `do`, trip-count rules |
| [04_exit_cycle_named.f90](04_exit_cycle_named.f90) | `exit`/`cycle`, named loops, exiting any construct |
| [05_block.f90](05_block.f90) | `block` — local declarations mid-code |
| [06_associate.f90](06_associate.f90) | `associate` — aliases for variables and expressions |
| [07_stop.f90](07_stop.f90) | `stop code, quiet=` — exit status |
| [08_error_stop.f90](08_error_stop.f90) | `error stop`, also from `pure` procedures |

Other constructs live with their topic: `where` (07), `select rank` (08),
`select type` (18), `do concurrent`, `critical`, `change team` (28).

## Construct syntax summary

```fortran
name: if (c) then ... else if (c) then name ... else name ... end if name
name: select case (x); case (1, 3:5, 10:) name; case default name; end select name
name: do i = a, b, s ... end do name
name: do while (c) ... end do name
name: do ... end do name
name: block ... end block name
name: associate (a => expr) ... end associate name
```

## Jumps

| Statement | Effect | Valid in |
|---|---|---|
| `cycle [name]` | next iteration | `do` loops |
| `exit [name]` | leave construct | `do`, and any *named* construct (F2008) |
| `return` | leave the procedure | subprograms |
| `stop [code][, quiet=]` | normal termination | anywhere |
| `error stop [code][, quiet=]` | error termination | anywhere, incl. `pure` |
| `go to label` | jump | avoid |

## Key points

- `if` conditions must be logical — `if (n)` with integer `n` is an error.
- `select case` has no fall-through and rejects overlapping cases; it does
  not accept `real` selectors.
- The trip count of a counted `do` is fixed before the first iteration;
  never modify the loop variable.
- After a completed `do i = 1, n`, `i` is `n + 1`.
- `block` hides outer names and deallocates its allocatables on exit.
- An `associate` alias to a variable writes through; an alias to an
  expression is a read-only snapshot.
- Deleted/obsolescent forms not used here: real loop variables, labelled
  `do 10 …`, arithmetic `if`, computed `go to`, `pause`.
