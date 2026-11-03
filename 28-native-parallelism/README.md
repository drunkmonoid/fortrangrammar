# 28 — Native Parallelism: DO CONCURRENT and Coarrays

Parallelism built into the language itself: loop-level concurrency and
the SPMD coarray model with images, synchronisation, collectives, locks,
events, atomics and teams.

## Examples

| File | Topic |
|---|---|
| [01_do_concurrent.f90](01_do_concurrent.f90) | `do concurrent` headers, masks, restrictions |
| [02_locality_specifiers.f90](02_locality_specifiers.f90) | `local`, `local_init`, `shared`, `default(none)` (F2018) |
| [03_do_concurrent_reduce.f90](03_do_concurrent_reduce.f90) | `reduce(op: var)` (F2023) |
| [04_coarray_basics.f90](04_coarray_basics.f90) | `x[*]`, `this_image`, `num_images`, `x[k]`, allocatable coarrays |
| [05_synchronisation.f90](05_synchronisation.f90) | `sync all`, `sync images`, `critical` |
| [06_collectives.f90](06_collectives.f90) | `co_sum`, `co_max`, `co_min`, `co_reduce`, `co_broadcast` |
| [07_locks_events_atomics.f90](07_locks_events_atomics.f90) | `lock`/`unlock`, `event post`/`wait`, `atomic_*` |
| [08_teams.f90](08_teams.f90) | `form team`, `change team`, `team_number` (compile-only here) |
| [09_failed_images.f90](09_failed_images.f90) | `failed_images`, `image_status`, `stat=` |

## Running with more than one image

The checks use `gfortran -fcoarray=single` (one image, no extra library).
For real parallel runs install [OpenCoarrays](https://github.com/sourceryinstitute/OpenCoarrays):

```sh
caf 28-native-parallelism/06_collectives.f90 -o collectives
cafrun -n 4 ./collectives
```

Intel `ifx -coarray` and HPE/Cray compilers support coarrays natively.

## Image control statements

| Statement | Purpose |
|---|---|
| `sync all` | barrier |
| `sync images (list \| *)` | pairwise synchronisation |
| `sync memory` | memory fence |
| `critical … end critical` | mutual exclusion |
| `lock (l)` / `unlock (l)` | explicit locks (`lock_type`) |
| `event post (e[k])` / `event wait (e)` | counting events (`event_type`) |
| `form team`, `change team … end team`, `sync team` | teams (`team_type`) |
| `allocate` / `deallocate` of coarrays | collective, implicit sync |
| `stop`, `end program`, `fail image` | termination |

All accept `stat=` and `errmsg=`.

## Compiler support (gfortran 15)

| Feature | Status |
|---|---|
| `do concurrent`, masks, `local`/`local_init`/`shared`/`default(none)` | ✅ |
| `reduce` locality (F2023) | ✅ |
| `integer ::` type-spec in the `do concurrent` header | ❌ |
| coarrays, sync, critical, collectives, locks, events, atomics | ✅ (`-fcoarray=single` or `lib`) |
| teams under `-fcoarray=single` | compiles; `form team` ends the program silently |

## Key points

- `do concurrent` is a promise of independence; the compiler may run
  iterations in any order or in parallel.
- Use `default(none)` and `local(...)` to make temporaries explicit.
- Coarrays are one-sided: `x[k]` reads or writes image `k` directly;
  separate conflicting accesses with image control statements.
- Collectives need no coarray arguments and beat manual loops.
- Atomics and events build lock-free protocols between images.
