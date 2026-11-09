# 51 — Configuration

An application-sized namelist: defaults, a file (here an internal file)
that overrides some of them, a check that rejects a bad value, and an
environment variable that overrides one field when it is set. The
namelist syntax itself is chapter 23. Environment variables are chapter 24.

`check_all.sh` does not set `FG_N_STEPS`, so the run recorded below keeps
the value from the namelist.

## Example

| File | Topic |
|---|---|
| [01_resolve.f90](01_resolve.f90) | Defaults, namelist, validation, optional environment override |
