# The run

gfortran 15.2.0, ten programs: `75-stacks` through `82-string-builders`,
`101-game-of-life`, `105-k-means`.

| Flags | Result |
|---|---|
| `-fcheck=all` and `-fsanitize=address,undefined` | 10 passed |
| `-fsanitize=address,undefined` without `-fcheck=all` | 10 passed, on the two chapters tried first (`75`, `76`) |

The CI job uses both. LeakSanitizer needs to be allowed to trace the
process; a sandbox that blocks `ptrace` makes it abort before the
program's own result is visible.
