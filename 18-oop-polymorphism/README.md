# 18 — OOP I: Type-Bound Procedures, Extension, Polymorphism

Methods, inheritance, dynamic dispatch and run-time type selection
(F2003).

## Examples

| File | Topic |
|---|---|
| [01_type_bound_procedures.f90](01_type_bound_procedures.f90) | `contains` in a type, `procedure :: name => impl`, `class(t)` self |
| [02_pass_nopass.f90](02_pass_nopass.f90) | `pass`, `pass(arg)`, `nopass` |
| [03_type_extension.f90](03_type_extension.f90) | `extends`, parent component, constructors of extended types |
| [04_overriding.f90](04_overriding.f90) | Overriding bindings, two ways to call "super" |
| [05_polymorphism.f90](05_polymorphism.f90) | `class(shape)`, `allocate(circle :: s)`, heterogeneous collections |
| [06_select_type.f90](06_select_type.f90) | `select type`: `type is`, `class is`, `class default` |

## Vocabulary

| Term | Fortran |
|---|---|
| class / object | derived type / variable of that type |
| method | type-bound procedure (`procedure :: m`) |
| `this` / `self` | passed-object dummy, declared `class(t)` |
| inheritance | `type, extends(parent) :: child` |
| `super` part | parent component `obj%parent` |
| base-class reference | `class(parent)` dummy, allocatable or pointer |
| `instanceof` / downcast | `select type` |
| static method | `procedure, nopass :: m` |
| interface / pure virtual | `abstract` type, `deferred` binding (chapter 19) |
| `final` / sealed method | `non_overridable` (chapter 19) |
| destructor | `final ::` procedure (chapter 19) |

## Key points

- The passed-object dummy must be `class(t)`, not `type(t)`, so
  extensions inherit the binding.
- Overrides keep the interface; only the passed object's type changes.
- `self%parent%method()` calls the parent's binding on the parent
  component — nested calls then see only the parent's behaviour.
  `parent_impl(self)` keeps dynamic dispatch.
- `class(t)` variables must be dummies, allocatables or pointers.
- Dispatch follows the dynamic type; component access follows the
  declared type — use `select type` to reach extension components.
- Arrays of `class(t)` share one dynamic type; wrap for heterogeneous lists.
- `type is` beats `class is`; the most specific `class is` wins.
