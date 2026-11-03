! -----------------------------------------------------------------------------
! 04_named_constants.f90 - PARAMETER and constant expressions
!
! Run:  scripts/run.sh 04-declarations/04_named_constants.f90
! -----------------------------------------------------------------------------
!
! A named constant (PARAMETER) has a value fixed at compile time. Its
! initialiser must be a CONSTANT EXPRESSION, built from:
!   * literals and other named constants,
!   * intrinsic operators,
!   * array and structure constructors,
!   * elemental and most transformational intrinsic functions with constant
!     arguments (sqrt, atan, sum, reshape, size, kind, len, trim, ...),
!   * inquiry functions about things known at compile time.
! User-defined functions are NOT allowed.
!
! Implied-shape arrays (F2008): `parameter :: a(*) = [...]` takes the shape
! from the initialiser; `(*, *)` for rank 2. Implied-length characters:
! `character(len=*), parameter :: s = '...'`.
!
! Named constants can be array bounds, kind values, character lengths,
! CASE values and initialisers of other constants.

program named_constants
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  real(dp), parameter :: pi = 4 * atan(1.0_dp)
  real(dp), parameter :: two_pi = 2 * pi
  real(dp), parameter :: deg = pi / 180
  integer, parameter :: n = 3
  integer, parameter :: n_squared = n**2

  ! Arrays, including implied shape.
  integer, parameter :: primes(*) = [2, 3, 5, 7, 11, 13]
  integer, parameter :: count_primes = size(primes)
  real(dp), parameter :: identity(*, *) = &
      reshape([1, 0, 0, 0, 1, 0, 0, 0, 1], [n, n])
  integer, parameter :: total = sum(primes)

  ! Characters.
  character(len=*), parameter :: name = 'constant'
  character(len=*), parameter :: shout = trim(name) // '!'
  integer, parameter :: name_len = len(name)

  ! Kind values must be constants.
  integer, parameter :: big = selected_int_kind(15)
  integer(big), parameter :: huge_count = 10_big**14

  ! A constant used as an array bound.
  real(dp) :: workspace(n_squared)

  workspace = deg

  print '(a, f0.12)', 'two_pi = ', two_pi
  print '(a, *(1x, i0))', 'primes:', primes
  print '(a, i0, a, i0)', 'count = ', count_primes, ', sum = ', total
  print '(a, *(1x, f0.0))', 'identity row 2:', identity(2, :)
  print '(a, a, 1x, i0)', 'shout, len(name): ', shout, name_len
  print '(a, i0)', 'huge_count = ', huge_count
  print '(a, i0, a, f0.6)', 'workspace(', size(workspace), ') = ', workspace(1)

  ! pi = 3.0_dp   <- compile error: a named constant is not a variable

end program named_constants

! Output:
! two_pi = 6.283185307180
! primes: 2 3 5 7 11 13
! count = 6, sum = 41
! identity row 2: 0. 1. 0.
! shout, len(name): constant! 8
! huge_count = 100000000000000
! workspace(9) = .017453
