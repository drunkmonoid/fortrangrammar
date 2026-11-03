# 15 — Submodules

Splitting a module into a public interface and private implementations
(F2008).

## Examples

| File | Topic |
|---|---|
| [01_separate_module_procedures.f90](01_separate_module_procedures.f90) | `module function` interfaces, `module procedure` bodies |
| [02_submodule_hierarchy.f90](02_submodule_hierarchy.f90) | `submodule (ancestor:parent) child`, shared helpers |
| [03_private_implementation.f90](03_private_implementation.f90) | Private state, helpers and hidden dependencies |
| [04_compilation_cascade/](04_compilation_cascade/) | Proof that implementation edits leave the `.mod` unchanged |

## Syntax

```fortran
module m
  interface
    module subroutine s(x)          ! interface with the MODULE prefix
      real, intent(inout) :: x
    end subroutine s
  end interface
end module m

submodule (m) m_impl                ! parent: the module
contains
  module procedure s                ! body; interface taken from m
    x = 2 * x
  end procedure s
end submodule m_impl

submodule (m:m_impl) m_more         ! parent: the submodule m_impl
end submodule m_more
```

## Two ways to write the body

| Form | Header repeated | Pros |
|---|---|---|
| `module procedure name … end procedure` | no | cannot drift from the interface |
| `module subroutine name(args) … end subroutine` | yes, checked | readable standalone |

## Key points

- Users only `use` the module; submodules have no public entities.
- A submodule sees all of its ancestors, including private entities.
- Implementation-only `use` statements go in the submodule, shrinking the
  module's dependency footprint.
- Changing a submodule recompiles only that submodule: no cascade.
- gfortran writes `parent.smod` and `parent@child.smod` files next to `.mod`.
- Submodules can break circular dependencies between modules.
