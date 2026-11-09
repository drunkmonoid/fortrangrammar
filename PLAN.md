# Implementation Plan

Target language level: **Fortran 2023** (ISO/IEC 1539-1:2023).
Phases 1–30 teach that language. Phases 31–74 continue it: legacy Fortran
you meet in existing code, numerical libraries, data formats, interop,
parallel applications, and shipping a library. Phases 75–114 are a second
haul: data structures, parsers, classical numerical methods, small
applications, and exercises. They use only the compiler. They do not
replace unfinished rows in 31–74.

Each phase is one directory, one commit, one push.
Status: `[x]` done · `[ ]` pending.

Examples follow [CONVENTIONS.md](CONVENTIONS.md). A phase that needs a
library or tool the compiler does not ship (BLAS, LAPACK, HDF5, NetCDF,
MPI, Python, fypp, stdlib, test-drive, toml-f) builds through `build.sh`
and exits 77 when that tool is missing, so `scripts/check_all.sh` stays
green with only gfortran installed. Later phases cite earlier chapters
and use them.

| # | Status | Directory | Topic |
|---|---|---|---|
| 1 | [x] | `01-getting-started/` | Toolchain, compiling, program anatomy, `implicit none`, program units overview |
| 2 | [x] | `02-lexical-elements/` | Source form, character set, names, comments, continuation, labels, `include` |
| 3 | [x] | `03-intrinsic-types/` | integer, real, complex, logical, character; literals; kinds |
| 4 | [x] | `04-declarations/` | Declaration syntax, attributes, `parameter`, initialization, enumerations |
| 5 | [x] | `05-expressions/` | Operators, precedence, mixed mode, assignment, conditional expressions |
| 6 | [x] | `06-control-flow/` | `if`, `select case`, `do` forms, `exit`/`cycle`, `block`, `associate`, `stop` |
| 7 | [x] | `07-arrays-fundamentals/` | Bounds, rank, constructors, sections, whole-array ops, `where` |
| 8 | [x] | `08-arrays-dynamic/` | Allocatables, argument shapes, assumed rank, `select rank`, `contiguous` |
| 9 | [x] | `09-array-intrinsics/` | Construction, reduction, location, manipulation, `matmul`, `reduce` |
| 10 | [x] | `10-characters/` | Character kinds, deferred length, substrings, string intrinsics, `split`/`tokenize` |
| 11 | [x] | `11-procedures-basics/` | Subroutines, functions, `intent`, `optional`, keywords, `value`, internal procedures |
| 12 | [x] | `12-procedures-interfaces/` | Explicit/abstract interfaces, generics, dummy procedures, procedure pointers |
| 13 | [x] | `13-procedure-attributes/` | `pure`, `elemental`, `impure`, `recursive`, `simple`, host association, `import` |
| 14 | [x] | `14-modules/` | `use`/`only`/rename, accessibility, `protected`, intrinsic modules, `.mod` files |
| 15 | [x] | `15-submodules/` | Separate module procedures, submodule trees, compilation cascades |
| 16 | [x] | `16-derived-types/` | Components, default init, constructors, nesting, accessibility, `sequence` |
| 17 | [x] | `17-parameterized-types/` | `kind` and `len` type parameters, assumed/deferred parameters |
| 18 | [x] | `18-oop-polymorphism/` | `extends`, `class`, `select type`, type-bound procedures, `pass`/`nopass` |
| 19 | [x] | `19-oop-advanced/` | `abstract`, `deferred`, `non_overridable`, generic bindings, operators, `final` |
| 20 | [x] | `20-unlimited-polymorphism/` | `class(*)`, type inquiry, generic containers, defined derived-type I/O |
| 21 | [x] | `21-pointers/` | `pointer`/`target`, `associated`, remapping, linked structures |
| 22 | [x] | `22-formatted-io/` | Every edit descriptor, format specifications, unlimited format items |
| 23 | [x] | `23-file-io/` | `open`/`close`/`inquire`, access modes, unformatted, stream, `namelist`, async |
| 24 | [x] | `24-errors-environment/` | `stat`/`errmsg`/`iostat`, termination, command line, env vars, time, random |
| 25 | [x] | `25-numeric-ieee/` | Numeric model inquiry, `ieee_arithmetic`, `ieee_exceptions`, rounding |
| 26 | [x] | `26-intrinsic-catalog/` | A–Z reference of intrinsic procedures not covered elsewhere |
| 27 | [x] | `27-c-interop/` | `iso_c_binding`, `bind(c)`, `ISO_Fortran_binding.h`, mixed builds |
| 28 | [x] | `28-native-parallelism/` | `do concurrent`, coarrays, teams, events, collectives, atomics |
| 29 | [x] | `29-parallel-ecosystem/` | OpenMP, OpenACC, MPI (`mpi_f08`) |
| 30 | [x] | `30-ecosystem/` | fpm, CMake, stdlib, testing, docs, tooling, debugging, support matrix, index |

## Continuation: phases 31–74

| Track | Phases | Aim |
|---|---|---|
| Legacy and the standard | 31–38 | Read old Fortran, know what `-std=f2023` still accepts, and follow the 202Y draft |
| Numerical practice | 39–49 | Make array code fast, then call and write numerical libraries |
| Data | 50–55 | Tables, configuration, JSON, TOML, HDF5, NetCDF |
| Interop and ABI | 56–59 | Python, C++, descriptors, a stable C API |
| Parallel applications | 60–66 | Patterns beyond the introductions in chapters 28 and 29 |
| Engineering | 67–74 | Generics, errors, tests, packaging, CI, performance, a capstone |

| # | Status | Directory | Topic |
|---|---|---|---|
| 31 | [x] | `31-fixed-form/` | Fixed source form, `character*`, statement-style `parameter` and `dimension` |
| 32 | [x] | `32-storage-association/` | `common`, `equivalence`, `block data`, the layout-shift bug |
| 33 | [x] | `33-obsolescent-forms/` | Statement functions, `entry`, alternate return, computed `go to`, `forall`, labelled `do` |
| 34 | [x] | `34-deleted-features/` | `assign`, assigned `go to`, arithmetic `if`, `pause`, real `do` variables, shared `do` termination |
| 35 | [x] | `35-f77-rewrites/` | Complete Fortran 77 programs beside the modern equivalent |
| 36 | [x] | `36-conformance/` | Programs the standard leaves undefined, and what the compiler can still catch |
| 37 | [x] | `37-compiler-portability/` | One example set under gfortran, ifx and flang; a support matrix |
| 38 | [x] | `38-fortran-202y/` | Fortran 202Y draft, chiefly templates, marked `@build skip` until a compiler accepts them |
| 39 | [x] | `39-array-performance/` | Temporaries, contiguity, column-major traversal, elemental calls |
| 40 | [x] | `40-floating-point-practice/` | Reproducible sums, fused multiply-add, what `-ffast-math` changes |
| 41 | [x] | `41-stdlib/` | stdlib strings, linalg, stats, optval, logger |
| 42 | [x] | `42-blas/` | `gemv` and `gemm`: leading dimensions, transpose, linking |
| 43 | [ ] | `43-lapack/` | Factor and solve, least squares, symmetric eigenvalues |
| 44 | [x] | `44-sparse/` | COO and CSR, sparse matvec, a Jacobi or conjugate-gradient solver |
| 45 | [x] | `45-quadrature/` | Trapezoid, Simpson, Gauss quadrature, scalar root finding |
| 46 | [x] | `46-ode/` | Euler and classical Runge–Kutta on a problem with a known solution |
| 47 | [x] | `47-fftw/` | FFTW plans, real-to-complex transforms, cleanup |
| 48 | [x] | `48-random-variates/` | Normal and discrete variates, independent streams, a Monte Carlo integral |
| 49 | [x] | `49-generic-kernels/` | One kernel for `real32`, `real64` and `real128` without templates |
| 50 | [x] | `50-csv/` | Read and write CSV, including quoted fields and ragged rows |
| 51 | [x] | `51-configuration/` | Namelist configuration with defaults, validation and environment overrides |
| 52 | [ ] | `52-json/` | A dependency-free JSON subset, plus an optional json-fortran example |
| 53 | [ ] | `53-toml/` | Read a TOML manifest with toml-f |
| 54 | [ ] | `54-hdf5/` | Create a file, write a dataset and an attribute, read them back |
| 55 | [ ] | `55-netcdf/` | A dimension, a variable and an attribute |
| 56 | [ ] | `56-python-interop/` | A Fortran array kernel called from Python |
| 57 | [ ] | `57-cxx-interop/` | `extern "C"` between Fortran and C++, including `std::vector` |
| 58 | [ ] | `58-c-descriptors/` | `CFI_establish`, `CFI_allocate`, lower bounds, character and pointer descriptors |
| 59 | [ ] | `59-library-abi/` | A versioned `bind(c)` API and the C header a caller compiles against |
| 60 | [x] | `60-openmp-patterns/` | `collapse`, array reductions, `simd`, schedules, a data race written so the test cannot hang |
| 61 | [ ] | `61-mpi-patterns/` | Communicators, struct datatypes, non-blocking halo exchange |
| 62 | [ ] | `62-coarray-halos/` | A 1-D ring halo with `sync images` |
| 63 | [x] | `63-do-concurrent-performance/` | Locality mistakes, `reduce`, checksums rather than timings |
| 64 | [ ] | `64-hybrid-grid/` | 2-D Jacobi, MPI across rows and OpenMP across columns |
| 65 | [ ] | `65-gpu-offload/` | OpenMP `target` `map` on a saxpy, correct when the device is the host |
| 66 | [ ] | `66-mpi-io/` | Write and read a distributed array with MPI-IO |
| 67 | [ ] | `67-fypp/` | Kind-generic source generated with fypp |
| 68 | [x] | `68-error-library/` | A result type and `stat`/`errmsg` helpers used by more than one program |
| 69 | [ ] | `69-test-drive/` | An fpm package whose tests use test-drive |
| 70 | [ ] | `70-fpm-packaging/` | Version, namespace, dependencies, profiles, install |
| 71 | [x] | `71-ci/` | GitHub Actions running `scripts/check_all.sh` on gfortran 15 |
| 72 | [x] | `72-debugging-numerics/` | An off-by-one and an uninitialised real, then the corrected program |
| 73 | [x] | `73-profiling/` | Find an array temporary and remove it, checksum unchanged |
| 74 | [ ] | `74-capstone/` | A small library: modules, tests, fpm, a C API, an optional Python caller |

## Second haul: phases 75–114

Pure Fortran. Printed results are integers, logicals, or a checksum.
Timings stay in the README. A phase that needs a tool beyond the
compiler exits 77.

| Track | Phases | Aim |
|---|---|---|
| Data structures | 75–82 | Arrays, arenas, heaps, hash maps, graphs |
| Text | 83–88 | Lexing, parsing, records, a `use` scanner |
| Numerical methods | 89–100 | Grids, solvers, fitting, special functions |
| Applications | 101–108 | Small programs with a known answer |
| Using the tutorial | 109–114 | Exercises, lint, sanitizers, a reading order |

| # | Status | Directory | Topic |
|---|---|---|---|
| 75 | [ ] | `75-stacks/` | A growable stack of integers with `move_alloc` |
| 76 | [ ] | `76-arenas/` | Nodes as integer indices into one allocatable array |
| 77 | [ ] | `77-heaps/` | A binary heap: push, pop, and a heap sort |
| 78 | [ ] | `78-hash-maps/` | Open addressing, integer keys, linear probing |
| 79 | [ ] | `79-union-find/` | Disjoint sets with path compression |
| 80 | [ ] | `80-graphs/` | Adjacency lists, BFS distances on a fixed graph |
| 81 | [ ] | `81-sorted-tables/` | A sorted array as a map: insert and binary search |
| 82 | [ ] | `82-string-builders/` | Append without quadratic `//` in a loop |
| 83 | [ ] | `83-lexer/` | Tokens for integers, identifiers, and `+ - * / ( )` |
| 84 | [ ] | `84-parser/` | Recursive descent for arithmetic expressions |
| 85 | [ ] | `85-evaluator/` | The parser's tree, evaluated on integer inputs |
| 86 | [ ] | `86-fixed-records/` | Read and write fixed-width fields |
| 87 | [ ] | `87-use-scanner/` | List the module names a file `use`s |
| 88 | [ ] | `88-derived-dump/` | Print a derived type as `name = value` lines |
| 89 | [ ] | `89-interpolation/` | Linear and cubic interpolation on a known polynomial |
| 90 | [ ] | `90-poisson/` | 1-D Poisson equation with a direct Thomas solve |
| 91 | [ ] | `91-heat/` | Explicit heat equation, one step, exact for a linear profile |
| 92 | [ ] | `92-advection/` | Upwind advection of a step, checksum of the shifted cells |
| 93 | [ ] | `93-conjugate-gradient/` | CG on the 3×3 matrix from chapter 44, residual zero |
| 94 | [ ] | `94-newton-systems/` | Newton on a 2×2 polynomial system with a known root |
| 95 | [ ] | `95-least-squares/` | Normal equations for a line through three exact points |
| 96 | [ ] | `96-richardson/` | One Richardson step on a symmetric difference |
| 97 | [ ] | `97-lcg/` | A linear congruential generator and a Monte Carlo count |
| 98 | [ ] | `98-quadrature-2d/` | Product Simpson rule on x² + y² over the unit square |
| 99 | [ ] | `99-special-functions/` | Series for exp and erf, checked against a tolerance |
| 100 | [ ] | `100-golden-section/` | Minimum of (x−2)² on an interval |
| 101 | [ ] | `101-game-of-life/` | One generation of a blinker, then the cell count |
| 102 | [ ] | `102-mandelbrot/` | Escape counts for a few complex points |
| 103 | [ ] | `103-two-body/` | One Euler step of a circular orbit, radius checked loosely |
| 104 | [ ] | `104-regression/` | Slope and intercept of y = 2x + 1 on integer abscissae |
| 105 | [ ] | `105-k-means/` | Two points, two centres, the assignment after one update |
| 106 | [ ] | `106-sir/` | A few Euler steps of an SIR model, populations summed to N |
| 107 | [ ] | `107-ppm/` | Write a 2×2 PPM image and read the pixel bytes back |
| 108 | [ ] | `108-geometry/` | Circle-segment intersection with an exact hit and a miss |
| 109 | [ ] | `109-exercises-basics/` | Problems and solutions for chapters 01–10 |
| 110 | [ ] | `110-exercises-procedures/` | Problems and solutions for chapters 11–20 |
| 111 | [ ] | `111-exercises-rest/` | Problems and solutions for chapters 21–36 |
| 112 | [ ] | `112-lint/` | fprettify and fortitude configuration; exit 77 if absent |
| 113 | [ ] | `113-sanitizers/` | A CI job with `-fsanitize=address,undefined` on a safe subset |
| 114 | [ ] | `114-learning-paths/` | Three reading orders: language, numerics, applications |

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

### 31 — Fixed form and old declarations
Fixed source form in a `.f` file: columns 1–5 label, column 6 continuation,
columns 7–72 statement, columns 73+ ignored, `C`/`c`/`*` comments.
`scripts/check_all.sh` and `scripts/make_index.sh` must gain `*.f`.
Old declarations that gfortran 15 still accepts under `-std=f2023 -pedantic`:
`double precision`, `character*len`, statement-style `parameter` and
`dimension`. `real*8` stays a comment; it is a GNU extension and the default
flags reject it. `character*len` warns as obsolescent.

### 32 — Storage association
Named and blank `common`, `equivalence`, `block data` with `data`.
Two programs of the layout-shift bug: a `common` block whose second unit
declares fewer variables, and an `equivalence` that overlays `a(2)` on
`b(1)`. gfortran warns that the named blocks differ in size and still
compiles. Replacement shown beside the old form: a module or a derived
type (chapters 14 and 16).

### 33 — Obsolescent forms that still compile
Each of these compiles with the default flags and warns. Under
`implicit none (type, external)` an external procedure needs an explicit
interface.

- Statement functions, dummies declared in the host specification part.
- `entry`. Declare every entry dummy before the first executable statement.
  The interface for the entry name must match the entry, including `intent`.
  `entry` is not allowed in a module procedure.
- Alternate return: `call sub(*10, *20)`, `return 1`, interface with `*`.
- Computed `go to (10, 20, 30), k`, rewritten as `select case`.
- `forall`, rewritten as `do concurrent` (chapter 28).
- Labelled `do 10 i = 1, n` ending on `continue` or `end do`.

### 34 — Deleted features
One `@build fail` program that the default flags reject, with the diagnostic
in a comment: `assign`, assigned `go to`, `pause`, arithmetic `if`, a real
`do` variable, and shared `do` termination (`do 10` nested onto the same
label). A second file with `! @flags -std=legacy` and `! @run no` proves
the same source compiles once the later `-std=` wins. Do not run it.
gfortran 15 does not terminate `do x = 1.0, 2.0` under `-std=legacy`, and
`pause` waits for stdin. The modern replacements (`select case`, integer
`do`, `error stop`) are comments, since those forms already have chapters.

### 35 — Fortran 77 rewrites
Three self-contained pairs, each a fixed-form program and a free-form
module program that print the same lines: mean and standard deviation of a
table, a labelled-`do` stencil, and a `common`-based state machine. The
multi-file `build.sh` compiles both and diffs the output. Fixed-form files
use the `.f` support added in phase 31.

### 36 — Conformance
Small programs whose behaviour the standard leaves undefined, each paired
with the conforming rewrite: argument aliasing (chapter 11), a `common`
size mismatch used on purpose, an allocatable used unallocated, and
sequence association through an assumed-size dummy. Document which of
`-fcheck=all` and the address sanitizer catch the case. Programs that
crash are `@run no` or `@exit` with the status gfortran actually produces.

### 37 — Compiler portability
`scripts/compiler_matrix.sh` runs `scripts/check_all.sh` for each compiler
on `PATH` (`gfortran`, `ifx`, `flang`), writing a markdown matrix of
pass, fail and skip. The chapter explains flag equivalents already listed
in `01-getting-started/compilers.md` and extends
`30-ecosystem/09_feature_support.md` with a column per compiler that was
actually run. Missing compilers are skipped, not failed.

### 38 — Fortran 202Y
Follow the Fortran 202Y draft current when the phase is written, chiefly
templates (`template`, `requirement`, `instantiate`, under whatever syntax
the draft has settled). Examples are complete and commented, and carry
`@build skip` until a compiler in the matrix accepts them. Refresh the
skip reason when the draft or the compiler changes. No private syntax.

### 39 — Array performance
Whole-array expressions that allocate temporaries, strided sections,
non-contiguous actual arguments to `contiguous` dummies, column-major
versus row-major loops, elemental procedure calls versus a single loop.
Compile with `-Warray-temporaries` and `-fcheck=all`. Print checksums.
A short note records the flags, and the `! Output:` block contains only
the checksums.

### 40 — Floating-point practice
Builds on chapter 25. Compensated summation against a naive sum, a
reduction whose result moves when `-ffast-math` or `-O3` contracts it,
`ieee_fma` beside a source-level `a*b+c`, and a directed-rounding sum.
Keep one program on the default flags so `check_outputs.sh` has a stable
`! Output:` block; put flag-dependent results in a program with `@run no`
and the observed digits in a comment.

### 41 — stdlib
Deeper than `30-ecosystem/07_stdlib_example.f90`: `stdlib_strings`,
`stdlib_linalg` (solve and a norm), `stdlib_stats`, `stdlib_optval`,
`stdlib_logger`. `build.sh` exits 77 when stdlib is absent. The Fortran
that would replace each call is named in a comment with its chapter.

### 42 — BLAS
`dgemv` and `dgemm` through the Fortran BLAS interface: `trans`, `lda`,
column-major storage matching chapter 7. A reference triple loop prints
the same matrix. `build.sh` links `-lblas` (or whatever `pkg-config`
reports) and exits 77 when the library is absent.

### 43 — LAPACK
`dgesv` for a dense linear system, `dgels` for least squares, `dsyev` for
a symmetric eigenproblem, each checked against a residual or a known
spectrum. Link `-llapack -lblas`. Exit 77 when LAPACK is absent. Show the
`info` return and map a negative `info` to a clear error.

### 44 — Sparse
Dependency-free. Build a COO matrix, convert to CSR, sparse matvec, then
Jacobi or conjugate gradient on a 1-D Laplacian whose solution is known.
Print the residual norm with a fixed format. This is the pure-Fortran
baseline that phases 42 and 43 do not cover.

### 45 — Quadrature and roots
Trapezoid, Simpson and a small Gauss rule on an integral with a known
value; bisection and Newton on a scalar function with a known root.
`pure` functions, a tolerance argument, and a failure status when the
iteration budget runs out (chapter 24).

### 46 — ODEs
Euler and classical fourth-order Runge–Kutta on the harmonic oscillator,
compared with the closed form at a fixed step. Show the global error
dropping when the step is halved. No external ODE library.

### 47 — FFTW
A multi-file example: create a plan, execute a real-to-complex transform,
check Parseval or a single-mode input, destroy the plan. Link FFTW through
`pkg-config --libs fftw3`. Exit 77 when the library or the header is
absent. Wisdom files are mentioned and left unused.

### 48 — Random variates
Builds on `random_number` and `random_init` (chapter 24). Uniform to
normal via Box–Muller, a discrete inverse-CDF sampler, two streams from
different seeds, and a Monte Carlo estimate of a 1-D integral with a
known value. Print the estimate and a fixed seed so the `! Output:` block
is stable. State that the stream is compiler-dependent if a seed alone
does not pin it down, and in that case check a tolerance inside the
program and print `ok`.

### 49 — Generic kernels
One axpy-style kernel for `real32`, `real64` and `real128` using a generic
interface and an `include` file of the body, which is the pattern stdlib
used before templates. Phase 67 does the same kernel with fypp. Call each
kind from a driver and print a checksum.

### 50 — CSV
A module that reads and writes CSV: commas, quotes, escaped quotes, a
header row, and ragged rows stored as deferred-length allocatable
character arrays (chapter 10). Round-trip a small table through an
internal file or a scratch file (chapter 23) and print the parsed cells.

### 51 — Configuration
An application-sized namelist: several groups, defaults for missing
items, validation with a `stat` result, and an environment variable that
overrides one field (chapter 24). A small driver prints the resolved
configuration. The namelist syntax itself stays in chapter 23.

### 52 — JSON
A dependency-free reader and writer for a subset: objects, arrays,
strings, numbers, `true`, `false`, `null`. Build a value as a derived
type with allocatable components (chapters 16 and 20) and round-trip a
document. A second multi-file example uses json-fortran and exits 77 when
that library is absent.

### 53 — TOML
Read a `fpm.toml`-like file with toml-f: package name, library source
directory, and a dependency table. Exit 77 when toml-f is absent. The
chapter points at phase 70 for writing such a manifest for real.

### 54 — HDF5
Create a file, write a 1-D double dataset, attach a string attribute,
close, reopen, and read both back. Use the HDF5 Fortran bindings.
`build.sh` finds them via `pkg-config` or `h5fc` and exits 77 otherwise.

### 55 — NetCDF
Define a dimension, define a variable, write values and a unit attribute,
close, and read them back with the NetCDF Fortran interface. Exit 77 when
`nf-config` (or `pkg-config netcdf-fortran`) fails.

### 56 — Python interop
A Fortran module procedure with `bind(c)` that fills an array, compiled
as a shared library, called from Python with `ctypes` and a NumPy array.
`build.sh` exits 77 when `python3` or NumPy is missing. Document f2py as
the alternative and keep one path actually executed.

### 57 — C++ interop
A C++ file calls a `bind(c)` Fortran routine. Show name mangling stopped
by `extern "C"`, a `std::vector` passed as a pointer plus length, and an
exception that must be translated before it crosses the boundary. `g++`
links the Fortran runtime. Exit 77 when `g++` is missing.

### 58 — C descriptors
Beyond chapter 27's introduction to `ISO_Fortran_binding.h`: from C,
`CFI_establish` a pointer to existing memory, `CFI_allocate` and
`CFI_deallocate` an allocatable, set a lower bound other than 1, and pass
a deferred-length character and an assumed-rank array. The Fortran side
prints rank, bounds and values.

### 59 — Library ABI
A library whose public surface is `bind(c)` only. Fortran modules stay
private. Ship a C header, a version symbol or a `library_version`
function, and a C driver compiled against the header alone. `build.sh`
builds a shared object and runs the C driver. The README lists what must
not change in a patch release: argument order, character length passing,
and array contiguity assumptions.

### 60 — OpenMP patterns
Builds on chapter 29. `collapse` on a 2-D loop, a reduction of an array,
`simd`, `schedule(static)` versus `schedule(dynamic)` with a checksum so
the result does not depend on the schedule. A racy loop is shown in
comments and as a `@run no` program; the executed program is the race-free
rewrite. `-fopenmp` via `@flags`.

### 61 — MPI patterns
Beyond `29-parallel-ecosystem/07`–`09`: split a communicator, build a
derived datatype for a derived type, exchange a 1-D halo with
`mpi_isend`/`mpi_irecv` and `mpi_waitall`. Rank 0 prints the checksum.
Exit 77 when `mpi_f08` is not installed. Every run must finish; document
a deadlock in a comment and keep it out of the executed source.

### 62 — Coarray halos
A 1-D periodic halo: each image copies its edge to the neighbour and
`sync images` with that neighbour only. Check the result under
`-fcoarray=single` (one image) and document the multi-image command.
The wrong sync order is a comment, with the deadlock described and not
executed.

### 63 — `do concurrent` performance
A loop the compiler can parallelize and the same loop with a mistake
(`default(none)` left out, a reduction written by hand). Print a checksum.
Document `-ftree-parallelize-loops` and that gfortran may ignore the hint.
Timings stay in the README, out of the `! Output:` block.

### 64 — Hybrid grid
2-D Jacobi relaxation. MPI owns rows; OpenMP walks columns inside a rank.
Compare with the serial checksum from a pure Fortran run of the same
algorithm on one rank. Exit 77 without MPI. With MPI and one rank the
example still runs.

### 65 — GPU offload
OpenMP `target` and `map` on a saxpy, result checked on the host. The
program passes when the runtime runs the region on the host, which is
what gfortran does without an offload device. Comments record
`nvfortran -mp=gpu` and the data-movement cost. `@flags -fopenmp`.

### 66 — MPI-IO
Each rank writes its slice of a 1-D array with `mpi_file_write_at_all`;
the ranks read the whole file back and check it. Exit 77 without MPI.
Remove the file in `build.sh` after the run.

### 67 — fypp
The phase 49 axpy written once with fypp loops over kinds (`#:for`,
`#:def`), generated into `OUT`, then compiled. Exit 77 when `fypp` is
absent. Show the generated Fortran in a comment so the reader sees the
expansion without running the tool.

### 68 — Error library
A module used by two programs: a derived type carrying `stat` and a
deferred-length message, helpers for `allocate` and for `iostat`, and a
convention for which procedure allocates the message. No exceptions.
Both programs print the failure path and the success path.

### 69 — test-drive
An fpm package with more than one test program, using test-drive's
`testdrive` for checks and a collected failure count. `build.sh` runs
`fpm test` when fpm and test-drive are present and exits 77 otherwise.
A dependency-free assert module, in the style of
`30-ecosystem/04_unit_testing.f90`, is the fallback the chapter also
shows in source.

### 70 — fpm packaging
A library (not a single app): `[library]`, `[install]`, `[dependencies]`
on a registry package or a git revision, `[dev-dependencies]`, profiles,
namespace prefixes, license and version fields. `build.sh` runs
`fpm build` and `fpm test`, and exits 77 without fpm. This is the
packaging step that `30-ecosystem/01_fpm_project/` only sketches.

### 71 — Continuous integration
A workflow at `.github/workflows/check.yml` that installs gfortran 15
with `fortran-lang/setup-fortran` and runs `scripts/check_all.sh`.
Document an optional second job for `ifx` that is allowed to fail.
The chapter README lists the compilers and what a red job means for an
`@build skip` example. No new Fortran feature.

### 72 — Debugging a wrong answer
Two programs. The first, `@run no`, has an off-by-one section and a real
that is used before it is defined; comments record the sanitizer and gdb
commands from `30-ecosystem/06_debugging.md` and the symptom each shows.
The second is the correction and has a `! Output:` block.

### 73 — Profiling
A kernel that copies through a temporary, then the same kernel written
contiguous and in-place. Both print the same checksum. The README gives
the gfortran flags (`-Warray-temporaries`, `-pg`) and the perf commands,
and keeps timings out of the output block.

### 74 — Capstone
A small library for 1-D linear interpolation or a tridiagonal solve.
Modules and a private implementation (chapters 14–15), allocatable
workspace (chapter 8), a test program (phase 69's assert style), an fpm
manifest (phase 70), a `bind(c)` API and a C driver (chapter 27 and
phase 59), and a Python caller that `build.sh` skips when Python is
absent (phase 56). `build.sh` always builds the Fortran tests and the C
driver.

### 75 — Stacks
An allocatable integer stack: push, pop, and growth by doubling with
`move_alloc` (chapter 08). Empty pop returns a `stat` from phase 68's
pattern, or the same shape inlined if that chapter's module is not
linked. Print the stack after a fixed script of pushes and pops.

### 76 — Arenas
A linked structure whose `next` field is an integer index into one
`type(node), allocatable :: pool(:)`, not a pointer (chapter 21). Build
a three-node list, print the values in order, and reclaim a node by
pushing its index onto a free list. No `allocate` per node after the
pool exists.

### 77 — Heaps
A binary heap of integers. Push 5, 1, 4, 2, 3 and pop them all. The
output is `1 2 3 4 5`. A second procedure heap-sorts a fixed array and
prints the same sequence. Children are `2*i` and `2*i+1` in a
1-based array.

### 78 — Hash maps
Open addressing, integer keys, a tombstone for deletion, load factor
checked by growing the table. Insert a handful of keys, overwrite one,
delete one, and print the value looked up for each surviving key. The
hash is `mod(key, capacity)` so the probe sequence is obvious. No
external hash library.

### 79 — Union-find
Disjoint sets on elements 1..6. Union a fixed list of pairs, with path
compression and union by rank. Print the representative of each element.
The pairs are chosen so the partition is `{1, 2, 3}` and `{4, 5, 6}`.

### 80 — Graphs
An adjacency list built from the arena in phase 76, or from a simple
allocatable array of edges if that phase is not linked. BFS from vertex
1 on a fixed undirected graph. Print the distance of each vertex.
Include one unreachable vertex whose distance is printed as `-1`.

### 81 — Sorted tables
A map from integer key to integer value stored as a sorted allocatable
array. Binary search, insert in order, and a missing-key status.
Insert keys out of order and print the table in key order, then one
successful lookup and one failed lookup.

### 82 — String builders
Repeated `//` on a deferred-length character copies the whole string
every time (chapter 10). A builder keeps a buffer and a length, doubles
with `move_alloc` when it fills, and slices the used part at the end.
Append a fixed sequence of pieces and print the result. A comment shows
the quadratic loop that this replaces.

### 83 — Lexer
Scan a character string into tokens: integer, identifier, the operators
`+ - * /`, parentheses, and end of input. Skip blanks. Print one token
per line for the string `2 * (a + 10)`. An unknown character sets a
`stat` and stops the scan. This is the front end of phases 84 and 85.

### 84 — Parser
Recursive descent over the tokens from phase 83. Grammar:
`expr = term { (+|-) term }`, `term = factor { (*|/) factor }`,
`factor = integer | identifier | ( expr )`. On success print the tree
in prefix form, one node per line, for `2 * (a + 10)`. A mismatched
parenthesis sets `stat` and prints nothing else. Identifiers are leaves;
they are not looked up yet.

### 85 — Evaluator
The tree from phase 84, evaluated with an environment of two names
(`a = 3`, `b = 4`) and integer arithmetic. Print the value of
`2 * (a + 10)` and of `a + b * 2`. Division by zero sets `stat`.
Operator precedence is the parser's job; this phase only walks the tree.

### 86 — Fixed-width records
Write three records of fixed columns (id width 4, name width 8, value
width 6) into a scratch file or an internal file (chapter 23), read
them back by position, and print the fields. A short name is padded
with blanks on write and trimmed on read. This is the layout CSV
(phase 50) does not have.

### 87 — Use scanner
Read a Fortran source file given as a character constant (not the whole
repository) and print every module name after `use`, ignoring
`use, intrinsic` and comments that start with `!`. The sample text
contains `use foo, only: bar` and `use, intrinsic :: iso_fortran_env`.
The output is the single name `foo`. A comment line that mentions `use`
is not a hit.

### 88 — Derived-type dump
A derived type with an integer, a real, and a nested type. A subroutine
writes `name = value` lines to a character buffer, one component per
line, using the component names. Print the buffer. Reals that are small
integers are printed with `f0.1` only when the value is a dyadic that
phase 40 established as exact (`0.5`, `1.0`); otherwise print the
integer components and a logical `real component defined`.

### 89 — Interpolation
Samples of `x**2` at `x = 0, 1, 2, 3`. Linear interpolation at `1.5`
is not exact; print whether it lies strictly between the samples.
Cubic interpolation (or a local parabola through three points) at `1.5`
recovers `2.25` for this polynomial when the stencil includes the right
points; print `nint(4 * value)` so the expected line is an integer.
State the stencil in a comment. This is the algorithm; phase 74 is a
packaged library, not this file.

### 90 — Poisson
`−u'' = 1` on (0, 1) with `u(0) = u(1) = 0`. Three interior points,
second differences, the tridiagonal system solved by the Thomas
algorithm written out in the file. The exact solution is `x(1−x)/2`.
Print `nint` of a scaled vector, with the scale chosen so the three
numbers are integers, and show the scale in a comment.

### 91 — Heat
`u_t = u_xx` on a short interval, forward Euler in time, centred in
space, one time step. Initial data is linear in x, so the second
difference is zero and the step must leave the values unchanged. Print
the three interior values as integers. A comment records the stability
limit `dt/dx**2 <= 1/2` and does not run an unstable step.

### 92 — Advection
`u_t + u_x = 0`, first-order upwind, periodic boundaries, a block of
ones and zeros. After a whole number of cells of travel the block has
moved by that many cells. Print the grid. Choose `dt` and `dx` so the
Courant number is 1 and the shift is exact.

### 93 — Conjugate gradient
The 3×3 matrix and a right-hand side from chapter 44, with a solution
that is a small integer vector. CG in pure Fortran, no BLAS. Stop when
the residual is zero in integer arithmetic, or when `maxval(abs(residual))`
is zero after a conversion that the comment justifies. Print the
solution. This is the iterative method; chapter 44 stops at Jacobi.

### 94 — Newton systems
`f(x, y) = (x**2 − 1, y**2 − 4)`, root `(1, 2)`. Analytic Jacobian,
start at `(2, 3)`, a fixed number of iterations. Print `nint` of the
result once it is within half a unit of the root, which this start
reaches. A singular Jacobian sets `stat` and is demonstrated on a
second, trivial system in comments or as a branch that is not taken
by the printed run.

### 95 — Least squares
Fit `y = a + b x` to the points `(0, 1), (1, 3), (2, 5)`, which lie on
`y = 2x + 1`. Form the normal equations with explicit sums and solve
the 2×2 system by elimination. Print `a` and `b` as integers. Phase 43
is the LAPACK path for the same idea; this file does not link it.

### 96 — Richardson
The symmetric difference `(f(x+h) − f(x−h)) / (2h)` for `f(x) = x**2`
at `x = 1`. With `h = 0.5` the estimate is exactly 2. Print
`matches derivative: T`. A comment states why the leading error term
is zero for a quadratic, which is the fact Richardson extrapolation
uses. Do not print the raw estimate.

### 97 — Linear congruential generator
`x = mod(a*x + c, m)` with small explicit constants, a documented seed,
and a period check on a toy modulus. Draw a fixed count of points in
the unit square by scaling the integers, and count how many fall inside
the quarter circle. Print the count. The sequence is part of the
output, so the constants and the seed are fixed in the source. This is
not `random_number` (chapter 24, phase 48).

### 98 — Quadrature in two dimensions
Product Simpson rule on `x**2 + y**2` over the unit square. The integral
is `2/3`. Use the same panel logic as phase 45 on each axis. Print
whether the result matches `2/3` within `1e-6`. A comment gives the
panel counts.

### 99 — Special functions
A truncated series for `exp(1)` and a series or rational approximation
for `erf` at 0, where the value is 0. Print `exp(1)` only as the logical
`abs(series − exp(1.0)) < 1e-6`, using the intrinsic as the reference,
and `erf(0) == 0`. State the number of terms. No external special-function
library.

### 100 — Golden section
Minimise `(x − 2)**2` on `[0, 5]`. A fixed number of golden-section
steps. Print whether the reported `x` is within `0.1` of 2. The ratio
is a named constant computed once as `0.5 * (sqrt(5.0) − 1)` or the
decimal; the stop test uses the bracket width, not a printed real.

### 101 — Game of Life
A 5×5 grid, all dead except a vertical blinker of three live cells.
One generation, Conway's rules, edges stay dead. Print the grid as five
lines of `0` and `1`. The blinker becomes horizontal. A comment states
the neighbour count for the centre cell.

### 102 — Mandelbrot
For a fixed list of complex points, the escape iteration `z = z**2 + c`
with a small cap. Print the iteration count for each point, `0` if it
does not escape. Include `0`, a point that escapes on the first test,
and one that is still inside at the cap. Use `complex` (chapter 03).

### 103 — Two-body
Unit gravitational parameter, position `(1, 0)`, velocity `(0, 1)`,
acceleration `−position`. One Euler step of size `0` leaves the radius
at 1. Print `zero step: T`. One Euler step of size `0.1` is the
integrator; print `small step near 1: T` when the radius is within
`0.05` of 1. Widen that tolerance in the source if a run misses it,
and keep the printed line a logical.

### 104 — Regression
The same line as phase 95, presented as a program that reads the points
from an array and prints `slope = 2` and `intercept = 1`. Share the
method in a comment with phase 95 rather than a new derivation. This
file is the application wrapper: input table, output sentence.

### 105 — k-means
Two 1-D observations, `0` and `10`, initial centres `1` and `9`. One
assignment step and one mean update. Print the cluster id of each
observation and the new centres as integers. With these numbers the
assignment is stable and the centres become `0` and `10`.

### 106 — SIR
`S' = −beta S I / N`, `I' = beta S I / N − gamma I`, `R' = gamma I`,
Euler, a few steps, `N = 1000`, parameters that keep every compartment
non-negative for those steps. Print whether `nint(S + I + R) == N`
after the last step. Do not print the compartments themselves.

### 107 — PPM images
Write a binary or ASCII P3 image, 2×2, four known RGB triples, to a
scratch file (chapter 23). Read it back, skip the header, and print the
twelve channel values as integers. Delete nothing the test harness
needs; `close` with `status='delete'` after the check so the file does
not remain.

### 108 — Geometry
A circle of radius 1 at the origin and a segment. One segment from
`(0, 0)` to `(2, 0)` hits; one from `(2, 2)` to `(3, 2)` misses. Print
`hit` and `miss`. Solve the quadratic and treat a non-positive
discriminant as a miss. Endpoints on the circle count as hits. Use
values that are dyadic so the discriminant is exact.

### 109 — Exercises, chapters 01–10
A `problems.md` of ten short tasks, one tied to each chapter's main
construct, and a `solutions/` program per task with a `! Output:` block.
The solutions follow `CONVENTIONS.md`. They do not repeat the chapter's
own example; each one combines two ideas from that chapter. The chapter
README links the problems and does not print the answers.

### 110 — Exercises, chapters 11–20
The same shape as phase 109 for procedures, modules, derived types, and
the object-oriented chapters. One solution must be an extended type
with a type-bound procedure (chapters 18–19). One must be a generic
interface (chapter 12).

### 111 — Exercises, chapters 21–36
The same shape for pointers, I/O, IEEE, C interop in a single-file form
that does not need a C compiler (the `iso_c_binding` kinds and
`c_loc` on a Fortran pointer), coarrays under `-fcoarray=single`, and
one fixed-form fragment (chapter 31). Skip any task that needs MPI,
HDF5, or a non-default compiler.

### 112 — Formatting and lint
A `.fprettify.rc` and a fortitude configuration at the repository root,
documented from this chapter. `build.sh` runs both tools on
`75-stacks/` or on this chapter's own sample if those tools are
installed, and exits 77 otherwise. The sample is a short program that
already matches the repository style, so a clean run prints `clean`.

### 113 — Sanitizers
Extend `.github/workflows/check.yml` with a job that builds a listed
subset of chapters (the pure integer ones: 75–82, 101, 105) using
`-fsanitize=address,undefined` and without `-fcheck=all` if the two
conflict on gfortran 15; the chapter README records which flag wins
after a real run. The job is allowed to fail until that note is filled
in. Do not sanitize the `@run no` crash programs in chapters 36 and 72.

### 114 — Learning paths
A `PATHS.md` at the repository root. Three orders, each a list of
chapter numbers with one line on why it is next:

- Language: 01–36, then 49, 68, 82–85.
- Numerics: 03, 07–09, 25, 39, 40, 44–46, 89–100.
- Applications: 50, 51, 75–81, 101–108.

Each path names the unfinished phases it is waiting on, so a reader
does not open an empty directory. No new Fortran.
