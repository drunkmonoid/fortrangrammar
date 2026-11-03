! -----------------------------------------------------------------------------
! 06_assumed_shape.f90 - assumed-shape dummy arguments (the modern default)
!
! Run:  scripts/run.sh 08-arrays-dynamic/06_assumed_shape.f90
! -----------------------------------------------------------------------------
!
!   real, intent(in) :: a(:)          rank 1, any size
!   real, intent(in) :: m(:, :)       rank 2, any shape
!   real, intent(in) :: z(0:)         lower bound 0 inside the procedure
!
! * The shape travels with the argument (via a descriptor): use size(),
!   shape(), ubound() inside. No extra size arguments.
! * The RANK must match the actual argument exactly.
! * Strided sections are passed WITHOUT copying; the descriptor holds the
!   stride.
! * Inside, the lower bound is 1 (or whatever you declare), NOT the actual
!   argument's lower bound.
! * Requires an EXPLICIT INTERFACE at the call site - automatic for module
!   and internal procedures, which is one more reason to use modules.

module assumed_shape
  implicit none (type, external)
contains

  real function mean(x)
    real, intent(in) :: x(:)

    mean = sum(x) / max(size(x), 1)
  end function mean

  subroutine describe(m)
    real, intent(in) :: m(:, :)

    print '(a, *(1x, i0))', '  shape:', shape(m)
    print '(a, *(1x, i0))', '  lbound:', lbound(m)
  end subroutine describe

  subroutine bounds_inside(a, z)
    integer, intent(in) :: a(:)
    integer, intent(in) :: z(0:)

    print '(a, i0, a, i0)', '  a(:)  sees bounds ', lbound(a, 1), ':', ubound(a, 1)
    print '(a, i0, a, i0)', '  z(0:) sees bounds ', lbound(z, 1), ':', ubound(z, 1)
  end subroutine bounds_inside

end module assumed_shape

program assumed_shape_demo
  use assumed_shape, only: mean, describe, bounds_inside
  implicit none (type, external)

  real :: v(10), grid(4, 5)
  integer :: custom(-3:3)
  integer :: i

  v = [(real(i), i = 1, 10)]
  grid = 1.0
  custom = [(i, i = -3, 3)]

  print '(a, f0.2)', 'mean(v)            = ', mean(v)
  print '(a, f0.2)', 'mean(v(::2)) strided = ', mean(v(::2))
  print '(a, f0.2)', 'mean of a column   = ', mean(grid(:, 2))
  print '(a, f0.2)', 'mean of empty      = ', mean(v(1:0))

  print '(a)', 'describe(grid(2:3, :)):'
  call describe(grid(2:3, :))

  print '(a)', 'bounds of custom(-3:3) inside the procedure:'
  call bounds_inside(custom, custom)

end program assumed_shape_demo

! Output:
! mean(v)            = 5.50
! mean(v(::2)) strided = 5.00
! mean of a column   = 1.00
! mean of empty      = .00
! describe(grid(2:3, :)):
!   shape: 2 5
!   lbound: 1 1
! bounds of custom(-3:3) inside the procedure:
!   a(:)  sees bounds 1:7
!   z(0:) sees bounds 0:6
