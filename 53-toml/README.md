# 53 — TOML

[TOML](https://toml.io/) (Tom's Obvious, Minimal Language) is the configuration
format chosen by the Fortran Package Manager (`fpm`). The standard Fortran
library for parsing and serializing TOML is [toml-f](https://github.com/toml-f/toml-f).

This chapter demonstrates how to parse a TOML file structured like an `fpm.toml`
manifest: extracting package metadata, table-nested keys (such as `[library]`),
and dependency tables.

Phase 70 covers authoring and shipping complete `fpm.toml` package manifests.

## Examples

| Directory | Topic |
|---|---|
| [01_read_manifest/](01_read_manifest/) | Read package name, source directory, and dependencies with toml-f |
