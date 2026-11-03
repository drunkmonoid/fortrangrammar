! -----------------------------------------------------------------------------
! 03_elemental.f90 - ELEMENTAL procedures
!
! Run:  scripts/run.sh 13-procedure-attributes/03_elemental.f90
! -----------------------------------------------------------------------------
!
! An ELEMENTAL procedure is written for SCALAR arguments but may be called
! with arrays of any rank: it is applied element by element, like sin or +.
!
!   * All dummies are scalar, non-pointer, non-allocatable; a function result
!     is scalar.
!   * Elemental implies PURE (unless declared IMPURE, see 04_...).
!   * Array actual arguments must CONFORM; scalars are broadcast.
!   * For an elemental SUBROUTINE, intent(out/inout) actuals must be arrays
!     of the common shape (or all scalars).
!   * The order in which elements are processed is unspecified.

module elemental_demo
  implicit none (type, external)
contains

  elemental real function clamp(x, lo, hi)
    real, intent(in) :: x, lo, hi
    clamp = min(max(x, lo), hi)
  end function clamp

  elemental integer function digits_of(n)
    integer, intent(in) :: n
    integer :: m
    m = abs(n)
    digits_of = 1
    do while (m >= 10)
      m = m / 10
      digits_of = digits_of + 1
    end do
  end function digits_of

  elemental subroutine sort_pair(a, b)
    real, intent(inout) :: a, b
    real :: t
    if (a > b) then
      t = a; a = b; b = t
    end if
  end subroutine sort_pair

end module elemental_demo

program elemental
  use elemental_demo, only: clamp, digits_of, sort_pair
  implicit none (type, external)

  real :: x(5) = [-2.0, 0.5, 1.5, 3.0, 9.0]
  real :: lo(5) = [0.0, 0.0, 1.0, 1.0, 1.0]
  real :: a(3) = [3.0, 1.0, 5.0], b(3) = [2.0, 4.0, 0.0]
  integer :: m(2, 2) = reshape([7, 42, 1234, -99999], [2, 2])

  print '(a, f0.1)', 'scalar clamp(5, 0, 1)   = ', clamp(5.0, 0.0, 1.0)
  print '(a, *(1x, f0.1))', 'clamp(x, 0.0, 2.0)      =', clamp(x, 0.0, 2.0)
  print '(a, *(1x, f0.1))', 'clamp(x, lo, 2.0)       =', clamp(x, lo, 2.0)
  print '(a, *(1x, i0))', 'digits_of(rank-2 array) =', digits_of(m)

  call sort_pair(a, b)
  print '(a, *(1x, f0.1))', 'after sort_pair: a =', a
  print '(a, *(1x, f0.1))', '                 b =', b

end program elemental

! Output:
! scalar clamp(5, 0, 1)   = 1.0
! clamp(x, 0.0, 2.0)      = .0 .5 1.5 2.0 2.0
! clamp(x, lo, 2.0)       = .0 .5 1.5 2.0 2.0
! digits_of(rank-2 array) = 1 2 4 5
! after sort_pair: a = 2.0 1.0 .0
!                  b = 3.0 4.0 5.0
