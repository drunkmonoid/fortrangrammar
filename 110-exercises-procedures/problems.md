# Exercises: Chapters 11–20

Each exercise combines two features from the corresponding chapter. Every solution is a standalone Fortran 2023 program.

1. **Chapter 11 (Procedures Basics):** Pair `optional` keyword arguments with `present(...)` defaults and an `intent(out)` status flag in an internal or module subroutine.
2. **Chapter 12 (Procedures Interfaces):** Define a generic interface `clamp` overloading both `integer` and `real(real64)` implementations alongside a module `procedure` pointer.
3. **Chapter 13 (Procedure Attributes):** Combine an `elemental` function with a `recursive` factorial/Fibonacci helper inside one module and apply `elemental` over an array.
4. **Chapter 14 (Modules):** Encapsulate a bounded counter module with `private` default, `protected` read-only global state or `type` visibility, and explicit `only:` imports.
5. **Chapter 15 (Submodules):** Split a geometry module interface (`module function`) from its implementation inside a child `submodule`.
6. **Chapter 16 (Derived Types):** Define a derived type with a default-initialized component and an `allocatable` array component, initialized via structure constructor and keyword arguments.
7. **Chapter 17 (Parameterized Types):** Define a `kind`-parameterized matrix/pair type (`integer, kind :: k`) with two kind specializations (`int32`, `int64`) and compute a sum.
8. **Chapter 18 (OOP Polymorphism):** Extend a base `shape_t` type with a `circle_t` / `rect_t` subtype overriding a type-bound procedure `area()` and dispatch polymorphically through a `class(shape_t)` variable and `select type`.
9. **Chapter 19 (Advanced OOP):** Combine an `abstract` counter interface with `deferred` procedure bindings and a `final` cleanup counter incremented upon scope exit in a `block`.
10. **Chapter 20 (Unlimited Polymorphism):** Store `integer`, `real(real64)`, and `character` values in a `class(*)` array or wrapper and tally their types with `select type`.
