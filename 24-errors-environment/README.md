# 24 — Errors and the Program Environment

Handling run-time failures without exceptions, and talking to the outside
world: arguments, environment, other programs, clocks, random numbers.

## Examples

| File | Topic |
|---|---|
| [01_stat_errmsg.f90](01_stat_errmsg.f90) | `stat=`/`errmsg=`, `iostat=`/`iomsg=` |
| [02_error_handling_patterns.f90](02_error_handling_patterns.f90) | Optional status, status + message, error objects |
| [03_command_line.f90](03_command_line.f90) | `command_argument_count`, `get_command_argument`, option parsing |
| [04_environment_variables.f90](04_environment_variables.f90) | `get_environment_variable` |
| [05_execute_command_line.f90](05_execute_command_line.f90) | `execute_command_line`, `exitstat`, `cmdstat` |
| [06_date_and_time.f90](06_date_and_time.f90) | `date_and_time`, `cpu_time`, `system_clock` |
| [07_random_numbers.f90](07_random_numbers.f90) | `random_number`, `random_seed`, `random_init` |

Termination (`stop`, `error stop`, exit codes) is in chapter 06.

## Status arguments

| Facility | Status | Message | Notes |
|---|---|---|---|
| `allocate` / `deallocate` | `stat=` | `errmsg=` | |
| I/O statements | `iostat=` | `iomsg=` | `iostat_end`, `iostat_eor` < 0 |
| `move_alloc` | `stat=` | `errmsg=` | F2018 |
| `execute_command_line` | `exitstat=`, `cmdstat=` | `cmdmsg=` | |
| `get_command`, `get_command_argument`, `get_environment_variable` | `status=` | `errmsg=` (F2023) | `-1` = truncated |
| coarray statements | `stat=` | `errmsg=` | chapter 28 |

## Environment intrinsics

| Intrinsic | Purpose |
|---|---|
| `command_argument_count()` | number of arguments |
| `get_command_argument(i, value, length, status)` | argument `i` (0 = program) |
| `get_command(command, length, status)` | the whole command line |
| `get_environment_variable(name, value, length, status, trim_name)` | read a variable |
| `execute_command_line(cmd, wait, exitstat, cmdstat, cmdmsg)` | run a shell command |
| `date_and_time(date, time, zone, values)` | calendar time |
| `cpu_time(t)` | processor time |
| `system_clock(count, count_rate, count_max)` | wall clock ticks |
| `random_number(x)` | uniform `[0, 1)` |
| `random_seed(size, put, get)` | generator state |
| `random_init(repeatable, image_distinct)` | F2018 initialisation |

## Key points

- Every statement that can fail accepts a status argument; without it a
  failure terminates the program.
- Messages are only defined on failure — check the status first.
- An optimiser may delete an allocation whose array is never used; such
  an allocation then cannot fail (see 01_stat_errmsg.f90).
- Query lengths first, then allocate exact-length strings for arguments
  and environment values.
- Internal-file reads need a character variable, not a function result.
- Time code with `system_clock` and `int64` counters.
- Equal seeds reproduce sequences only on the same compiler.
