# 113 — Sanitizers

`.github/workflows/check.yml` has a second job, `sanitizers`. It runs
`scripts/check_all.sh` on the integer chapters 75–82, 101, and 105.

The flags, measured with gfortran 15.2.0 on those ten programs:

```
-std=f2023 -Wall -Wextra -pedantic -g -fbacktrace -fcheck=all -fsanitize=address,undefined
```

`-fcheck=all` and `-fsanitize=address,undefined` both stay. On this
subset they compile and the programs exit 0. Nothing has to be dropped.

Chapters 36 and 72 are not in the job. Their `@run no` programs are
meant to crash, and a sanitizer would turn that crash into a job
failure.

## Examples

| File | Topic |
|---|---|
| [01_result.md](01_result.md) | The flag combination that passed |
