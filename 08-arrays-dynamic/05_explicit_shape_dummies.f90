! -----------------------------------------------------------------------------
! 05_explicit_shape_dummies.f90 - explicit-shape dummy arguments
!
! Run:  scripts/run.sh 08-arrays-dynamic/05_explicit_shape_dummies.f90
! -----------------------------------------------------------------------------
!
!   subroutine s(n, m, a)
!     integer, intent(in) :: n, m
!     real, intent(inout) :: a(n, m)      ! shape given by other arguments
!
! The dummy is a view of n*m consecutive elements starting at the actual
! argument's first element ("sequence association"). Consequences:
!   * the caller can pass an array of a DIFFERENT shape or rank, as long as
!     it has enough elements - this is how a 1-D buffer can be treated as a
!     matrix, and how many BLAS/LAPACK interfaces work;
!   * if the actual argument is not contiguous (e.g. a strided section),
!     the compiler makes a temporary contiguous COPY, passes it, and copies
!     back afterwards (copy-in/copy-out) - correct but possibly slow;
!   * nothing checks that n and m are right.
!
! Prefer assumed-shape (06_assumed_shape.f90) in new Fortran code; use
! explicit shape for C interop and legacy-style libraries.

module explicit_shape
  implicit none (type, external)
contains

  subroutine show_matrix(n, m, a)
    integer, intent(in) :: n, m
    real, intent(in) :: a(n, m)
    integer :: i

    do i = 1, n
      print '(*(f5.0))', a(i, :)
    end do
  end subroutine show_matrix

  subroutine scale_all(n, a, factor)
    integer, intent(in) :: n
    real, intent(inout) :: a(n)
    real, intent(in) :: factor

    a = a * factor
  end subroutine scale_all

end module explicit_shape

program explicit_shape_dummies
  use explicit_shape, only: show_matrix, scale_all
  implicit none (type, external)

  real :: buffer(6), grid(3, 2)
  integer :: i

  buffer = [(real(i), i = 1, 6)]

  print '(a)', 'a rank-1 buffer seen as a 2x3 matrix:'
  call show_matrix(2, 3, buffer)

  print '(a)', 'the same buffer seen as 3x2:'
  call show_matrix(3, 2, buffer)

  ! A rank-2 array passed to a rank-1 dummy (sequence association).
  grid = reshape(buffer, shape(grid))
  call scale_all(size(grid), grid, 10.0)
  print '(a, *(1x, f0.0))', 'grid scaled through rank-1 dummy:', grid

  ! A strided section: copy-in/copy-out happens behind the scenes.
  call scale_all(3, buffer(1::2), -1.0)
  print '(a, *(1x, f0.0))', 'odd elements negated:', buffer

end program explicit_shape_dummies

! Output:
! a rank-1 buffer seen as a 2x3 matrix:
!    1.   3.   5.
!    2.   4.   6.
! the same buffer seen as 3x2:
!    1.   4.
!    2.   5.
!    3.   6.
! grid scaled through rank-1 dummy: 10. 20. 30. 40. 50. 60.
! odd elements negated: -1. 2. -3. 4. -5. 6.
