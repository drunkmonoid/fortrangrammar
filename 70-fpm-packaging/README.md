# 70 — Fpm Packaging

The Fortran Package Manager (`fpm`) is the standard build tool and package manager
for modern Fortran. While [30-ecosystem/01_fpm_project](../30-ecosystem/01_fpm_project)
introduced a basic executable layout, this chapter explores shipping a complete,
reusable Fortran library package.

## Key Packaging Concepts

1. **Package Identity**:
   - `name`: Lowercase, hyphenated or underscore identifier.
   - `version`: Semantic versioning (`MAJOR.MINOR.PATCH`).
   - `license`, `author`, `maintainer`, `description`, `keywords`.
2. **Library Layout**:
   - `[library]`: Configures `source-dir` containing reusable modules.
   - `[install]`: Marks `library = true` so `fpm install` installs compiled `.mod` files
     and static/shared library archives.
3. **Namespacing**:
   - Unlike languages with hierarchical namespaces, Fortran module names share a flat
     namespace. Libraries should adopt a distinctive prefix (e.g. `geom_`) for all public
     modules to prevent symbol collisions when combined into larger projects.
4. **Dependencies & Profiles**:
   - `[dependencies]` vs `[dev-dependencies]`.
   - `[profile.debug]` and `[profile.release]` customizing compiler flags for testing
     versus optimized production builds.

`build.sh` runs `fpm build` and `fpm test`, exiting with code 77 if `fpm` is not installed.

## Examples

| Directory | Topic |
|---|---|
| [01_library_pkg/](01_library_pkg/) | Complete fpm library manifest with version, install target, profiles, and tests |
