# 71 — Continuous Integration

[`.github/workflows/check.yml`](../.github/workflows/check.yml) installs
gfortran 15 with `fortran-lang/setup-fortran` and runs
`scripts/check_all.sh`. A red job means a program that should compile
did not, or a program that should fail to compile succeeded. An example
marked `@build skip` is reported as SKIP and does not fail the job.

An optional second job can install `ifx` and is allowed to fail, because
chapters 31–36 still contain forms one compiler warns about and another
rejects. Add it beside the gfortran job:

```yaml
  ifx:
    runs-on: ubuntu-latest
    continue-on-error: true
    steps:
      - uses: actions/checkout@v4
      - uses: fortran-lang/setup-fortran@v1
        with:
          compiler: intel
          version: "2025"
      - run: FC=ifx FFLAGS="-stand f23 -warn all" scripts/check_all.sh
```

The flag names are the ones in
[compilers.md](../01-getting-started/compilers.md). Chapter 37 is the
same matrix, run by hand.
