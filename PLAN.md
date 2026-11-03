# Implementation Plan — 30 Phases

Target language level: **Fortran 2023** (ISO/IEC 1539-1:2023).
Older standards are out of scope for now; a comparison track comes later.

Each phase is one directory, one commit, one push.
Status: `[x]` done · `[ ]` pending.

| # | Status | Directory | Topic |
|---|---|---|---|
| 1 | [x] | `01-getting-started/` | Toolchain, compiling, program anatomy, `implicit none`, program units overview |
| 2 | [ ] | `02-lexical-elements/` | Source form, character set, names, comments, continuation, labels, `include` |
| 3 | [ ] | `03-intrinsic-types/` | integer, real, complex, logical, character; literals; kinds |
| 4 | [ ] | `04-declarations/` | Declaration syntax, attributes, `parameter`, initialization, enumerations |
| 5 | [ ] | `05-expressions/` | Operators, precedence, mixed mode, assignment, conditional expressions |
| 6 | [ ] | `06-control-flow/` | `if`, `select case`, `do` forms, `exit`/`cycle`, `block`, `associate`, `stop` |
| 7 | [ ] | `07-arrays-fundamentals/` | Bounds, rank, constructors, sections, whole-array ops, `where` |
| 8 | [ ] | `08-arrays-dynamic/` | Allocatables, argument shapes, assumed rank, `select rank`, `contiguous` |
| 9 | [ ] | `09-array-intrinsics/` | Construction, reduction, location, manipulation, `matmul`, `reduce` |
| 10 | [ ] | `10-characters/` | Character kinds, deferred length, substrings, string intrinsics, `split`/`tokenize` |
| 11 | [ ] | `11-procedures-basics/` | Subroutines, functions, `intent`, `optional`, keywords, `value`, internal procedures |
| 12 | [ ] | `12-procedures-interfaces/` | Explicit/abstract interfaces, generics, dummy procedures, procedure pointers |
| 13 | [ ] | `13-procedure-attributes/` | `pure`, `elemental`, `impure`, `recursive`, `simple`, host association, `import` |
| 14 | [ ] | `14-modules/` | `use`/`only`/rename, accessibility, `protected`, intrinsic modules, `.mod` files |
| 15 | [ ] | `15-submodules/` | Separate module procedures, submodule trees, compilation cascades |
| 16 | [ ] | `16-derived-types/` | Components, default init, constructors, nesting, accessibility, `sequence` |
| 17 | [ ] | `17-parameterized-types/` | `kind` and `len` type parameters, assumed/deferred parameters |
| 18 | [ ] | `18-oop-polymorphism/` | `extends`, `class`, `select type`, type-bound procedures, `pass`/`nopass` |
| 19 | [ ] | `19-oop-advanced/` | `abstract`, `deferred`, `non_overridable`, generic bindings, operators, `final` |
| 20 | [ ] | `20-unlimited-polymorphism/` | `class(*)`, type inquiry, generic containers, defined derived-type I/O |
| 21 | [ ] | `21-pointers/` | `pointer`/`target`, `associated`, remapping, linked structures |
| 22 | [ ] | `22-formatted-io/` | Every edit descriptor, format specifications, unlimited format items |
| 23 | [ ] | `23-file-io/` | `open`/`close`/`inquire`, access modes, unformatted, stream, `namelist`, async |
| 24 | [ ] | `24-errors-environment/` | `stat`/`errmsg`/`iostat`, termination, command line, env vars, time, random |
| 25 | [ ] | `25-numeric-ieee/` | Numeric model inquiry, `ieee_arithmetic`, `ieee_exceptions`, rounding |
| 26 | [ ] | `26-intrinsic-catalog/` | A–Z reference of intrinsic procedures not covered elsewhere |
| 27 | [ ] | `27-c-interop/` | `iso_c_binding`, `bind(c)`, `ISO_Fortran_binding.h`, mixed builds |
| 28 | [ ] | `28-native-parallelism/` | `do concurrent`, coarrays, teams, events, collectives, atomics |
| 29 | [ ] | `29-parallel-ecosystem/` | OpenMP, OpenACC, MPI (`mpi_f08`) |
| 30 | [ ] | `30-ecosystem/` | fpm, CMake, stdlib, testing, docs, tooling, debugging, support matrix, index |

---

## Phase details

### 1 — Getting started
Compilers and flags, file extensions, hello world, statement ordering inside a
program unit, `implicit none (type, external)`, the implicit-typing trap,
list-directed I/O basics, overview of program units, compiler inquiry.

### 2 — Lexical elements
Free source form rules, Fortran character set, names (63 chars), keywords are not
reserved, comments, `&` continuation (incl. split tokens and strings), statement
separator `;`, line length (10 000 chars in F2023), statement labels, `include`
lines, case insensitivity, blanks significance.

### 3 — Intrinsic types and kinds
All five intrinsic types, literal constant syntax (incl. kind suffixes, BOZ),
`kind=`, `iso_fortran_env` kind constants and arrays (`integer_kinds`, …),
`selected_int_kind`, `selected_real_kind`, `selected_char_kind`,
`selected_logical_kind` (F2023), portable kind modules.

### 4 — Declarations and attributes
Type-declaration statement grammar, the full attribute list, attribute statements,
`parameter` and constant expressions, initialization and implied `save`,
`dimension`, `allocatable`, `target`, `volatile`, `asynchronous`, `value`,
`enum, bind(c)` and F2023 `enumeration type`, `typeof`/`classof` (F2023).

### 5 — Expressions and assignment
Arithmetic/relational/logical/character operators, precedence and associativity,
integer division and `**`, mixed-mode promotion, no guaranteed short-circuit,
defined operators preview, intrinsic assignment, conditional expressions (F2023).

### 6 — Control flow
`if` statement and construct, `select case` (ranges, defaults), `do` (counted,
`while`, infinite), named constructs, `exit`/`cycle` from any construct, `block`,
`associate`, `stop`/`error stop` with codes and `quiet=`, `return`, `go to` note.

### 7 — Arrays I
Explicit bounds and rank (up to 15), array constructors `[ ]` with type-spec,
implied-do, sections, strides, vector subscripts, whole-array and elemental
operations, conformance, `where`/`elsewhere`, array inquiry (`size`, `shape`,
`lbound`, `ubound`), `forall` as obsolescent note.

### 8 — Arrays II
`allocatable` arrays, `allocate` with `stat`/`errmsg`/`source`/`mold`, automatic
(re)allocation on assignment, `move_alloc`, explicit-shape vs assumed-shape vs
assumed-size vs assumed-rank dummies, `select rank`, `contiguous`, `is_contiguous`,
automatic arrays, lower bounds on assumed shape.

### 9 — Array intrinsics
`reshape`, `pack`, `unpack`, `spread`, `merge`, `sum`, `product`, `maxval`,
`minval`, `count`, `any`, `all`, `parity`, `iall`/`iany`/`iparity`, `norm2`,
`maxloc`, `minloc`, `findloc`, `matmul`, `dot_product`, `transpose`, `cshift`,
`eoshift`, `reduce` (F2018), `dim=`/`mask=`/`back=` arguments.

### 10 — Characters
Fixed and deferred length, `len=*`, substrings, concatenation, comparison
(`lge`, …), `len`, `len_trim`, `trim`, `adjustl`/`adjustr`, `index`, `scan`,
`verify`, `repeat`, `achar`/`iachar`/`char`/`ichar`, `new_line`, character kinds
(ASCII, ISO 10646), number⇄string via internal I/O, F2023 `split` and `tokenize`.

### 11 — Procedures I
Subroutines and functions, `result`, `intent(in/out/inout)`, `optional` and
`present`, keyword arguments, `value`, argument association rules, aliasing
restrictions, internal procedures, function side effects.

### 12 — Procedures II
Explicit interfaces, interface blocks, `abstract interface`, generic interfaces
and resolution rules, `procedure` declaration statement, dummy procedures,
procedure pointers, `operator(...)` and `assignment(=)` generics.

### 13 — Procedure attributes
`pure`, `elemental`, `impure elemental`, `recursive` (default since F2018) and
`non_recursive`, `simple` (F2023), `module procedure`, host association,
`import`, `import, only`, `import, none`, `import, all` (F2018).

### 14 — Modules
`module`/`end module`, `use`, `only:`, renaming (incl. operators), `public`/
`private` defaults, `protected`, module variables and implicit `save`,
`use, intrinsic` vs `non_intrinsic`, list of intrinsic modules, compile order
and `.mod` files, multi-file builds.

### 15 — Submodules
`module procedure` interfaces vs `separate module procedure` bodies, submodule
syntax `submodule (parent) child`, nested submodules, `.smod` files, why
submodules break recompilation cascades.

### 16 — Derived types
Type definitions, components and default initialization, structure constructors
(keyword and positional), nested types, component accessibility, `private`
components with public types, `sequence`, intrinsic assignment of types,
allocatable components and deep copy.

### 17 — Parameterized derived types
`kind` and `len` type parameters, defaults, `type(t(k=..., n=...))`, assumed
(`*`) and deferred (`:`) parameters, inquiry `%k`, current compiler caveats.

### 18 — OOP I
`extends`, parent component, `class(t)` polymorphic entities, dynamic dispatch,
`select type` (`type is`, `class is`, `class default`), type-bound procedures,
`pass`, `pass(arg)`, `nopass`, overriding.

### 19 — OOP II
`abstract` types, `deferred` bindings with abstract interfaces,
`non_overridable`, `generic ::` bindings, type-bound operators and assignment,
`final` procedures and finalization order, factory patterns.

### 20 — Unlimited polymorphism and defined I/O
`class(*)`, `same_type_as`, `extends_type_of`, heterogeneous containers,
`allocate(..., source=)` of polymorphic values, user-defined derived-type I/O
(`read(formatted)`, `write(formatted)`, `dt` edit descriptor).

### 21 — Pointers
`pointer`, `target`, `=>`, `associated` (1 and 2 args), `nullify`, `null()`,
pointer initialization, bounds specification and rank remapping, pointer
components, linked lists, trees, memory leaks and dangling pointers.

### 22 — Formatted I/O
Format specification syntax, data edit descriptors (I, B, O, Z, F, E, EN, ES,
EX, D note, G, G0, L, A, DT), control descriptors (X, T, TL, TR, `/`, `:`, P,
S/SP/SS, BN/BZ, RU/RD/RZ/RN/RC/RP, DC/DP), repeat counts, `*(...)` unlimited
items, character-variable formats, `g0` idioms.

### 23 — File I/O
Units and `newunit=`, `open` specifiers, `close`, `inquire` (by unit, by file,
by output list), sequential/direct/stream access, formatted vs unformatted,
`advance='no'`, `size=`, `pos=`, `rewind`/`backspace`/`endfile`, `flush`,
`namelist`, internal files, asynchronous I/O and `wait`.

### 24 — Errors and the environment
`stat=`/`errmsg=` on allocate/deallocate, `iostat=`/`iomsg=`, `iostat_end`,
`is_iostat_end`, `stop`/`error stop` with codes, `quiet=`, error-handling
patterns, `get_command`, `get_command_argument`, `command_argument_count`,
`get_environment_variable`, `execute_command_line`, `date_and_time`,
`cpu_time`, `system_clock`, `random_number`, `random_seed`, `random_init`.

### 25 — Numeric model and IEEE
`digits`, `epsilon`, `huge`, `tiny`, `precision`, `range`, `radix`,
`maxexponent`, `minexponent`, `spacing`, `nearest`, `rrspacing`, `fraction`,
`exponent`, `scale`, `set_exponent`, `ieee_arithmetic` (classes, `ieee_is_nan`,
`ieee_value`, rounding modes), `ieee_exceptions` (flags, halting),
`ieee_features`, F2023 `ieee_max`/`ieee_min` family.

### 26 — Intrinsic catalog
Elemental math (`sin` … `atan2`, `hypot`, `bessel_*`, `erf`, `gamma`,
`log_gamma`), degree trig `sind`/`cosd`/`tand`/`acosd`… and `*pi` (F2023),
conversions (`int`, `nint`, `real`, `cmplx`, `aimag`, `conjg`, `floor`, `ceiling`,
`modulo`, `mod`), bit intrinsics (`iand`, `ior`, `ieor`, `not`, `ishft`, `ishftc`,
`shifta`, `shiftl`, `shiftr`, `dshiftl`, `ibset`, `ibclr`, `btest`, `ibits`,
`mvbits`, `popcnt`, `poppar`, `leadz`, `trailz`, `merge_bits`, `maskl`, `maskr`,
`bge`…), `transfer`, `storage_size`, `c_sizeof`, `out_of_range`.

### 27 — C interoperability
`iso_c_binding` kinds, `bind(c, name=...)`, `value`, interoperable derived types,
`c_ptr`, `c_funptr`, `c_loc`, `c_funloc`, `c_f_pointer`, `c_f_procpointer`,
`c_associated`, strings and `c_null_char`, callbacks, global variables,
`ISO_Fortran_binding.h` / `CFI_cdesc_t`, assumed-type `type(*)`, F2023
`c_f_strpointer`/`f_c_string`, mixed C/Fortran builds.

### 28 — Native parallelism
`do concurrent` with `local`, `local_init`, `shared`, `default(none)`, F2023
`reduce`; coarrays: `[*]` codimensions, `this_image`, `num_images`,
`sync all`/`sync images`/`sync memory`, `critical`, `lock`/`unlock`, `event`
types, `form team`/`change team`/`sync team`, `co_sum`/`co_min`/`co_max`/
`co_broadcast`/`co_reduce`, `atomic_*`, failed images, `-fcoarray=single` and
OpenCoarrays.

### 29 — Parallel ecosystem
OpenMP (parallel regions, worksharing, reductions, tasks, `simd`, offload
`target`), OpenACC overview, MPI with `mpi_f08` (point-to-point, collectives,
derived datatypes), hybrid MPI+OpenMP.

### 30 — Ecosystem and wrap-up
fpm manifests and workflow, CMake Fortran support and module dependencies,
Make, Fortran stdlib tour, unit testing (test-drive, pFUnit, veggies), FORD
documentation, fortls, fprettify/findent, gdb, valgrind, sanitizers, gprof/perf,
F2023 feature support matrix across compilers, full cross-reference index.
