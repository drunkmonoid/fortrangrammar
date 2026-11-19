# 112 — Formatting and Lint

Two config files at the repository root:

| File | Tool | What it pins |
|---|---|---|
| [`.fprettify.rc`](../.fprettify.rc) | [fprettify](https://github.com/fortran-lang/fprettify) | Indent of 2. Whitespace is not rewritten, so `implicit none (type, external)` keeps its space. |
| [`fortitude.toml`](../fortitude.toml) | [fortitude](https://github.com/PlasmaFAIR/fortitude) | Line length 132, indent 2. Rule S241 is ignored because the examples use single quotes. |

`01_sample.f90` is already in that style. `build.sh` runs both tools on it and prints `clean` when neither wants a change. If either tool is missing, the script exits 77.

## Examples

| File | Topic |
|---|---|
| [01_sample.f90](01_sample.f90) | A short program in the repository style |
| [02_tools/](02_tools/) | Run fprettify and fortitude on the sample |
