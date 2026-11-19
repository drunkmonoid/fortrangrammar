# 115 — Fortran 90 and 95

The features that made the language people now call modern Fortran. Every
file is compiled with `-std=f95`, which replaces the default `-std=f2023`
because `@flags` are placed after `FFLAGS`.

Fortran 90 brought free form, modules, `implicit none`, derived types,
allocatable arrays, and whole-array assignment. Fortran 95 added `pure`,
`elemental`, and `forall`. Array constructors here use `(/ /)`. The
square-bracket form is Fortran 2003.

An allocatable component is also Fortran 2003. `02_allocatable_component.f90`
is marked `@build fail` so the diagnostic from `-std=f95` is part of the
chapter.

## Examples

| File | Topic |
|---|---|
| [01_features.f90](01_features.f90) | Module, allocatable array, `elemental`, `forall` |
| [02_allocatable_component.f90](02_allocatable_component.f90) | An allocatable component, rejected by `-std=f95` |
