! -----------------------------------------------------------------------------
! 06_where.f90 - masked array assignment: WHERE
!
! Run:  scripts/run.sh 07-arrays-fundamentals/06_where.f90
! -----------------------------------------------------------------------------
!
!   where (mask) array = expr                         statement form
!
!   [name:] where (mask1)                             construct form
!     assignments
!   elsewhere (mask2) [name]                          masked elsewhere
!     assignments
!   elsewhere [name]                                  everything else
!     assignments
!   end where [name]
!
! * The mask is a logical array; every assignment inside must conform to it.
! * Only array ASSIGNMENTS (and nested WHERE) are allowed inside.
! * The mask is evaluated ONCE, before any assignment.
! * Elemental operations inside are only evaluated where the mask is true,
!   so where (x > 0) y = log(x) is safe.
! * Non-elemental function calls (e.g. sum(x)) are evaluated in full.
!
! For element-wise choice inside an expression, use merge(tsource,
! fsource, mask) - but merge evaluates BOTH alternatives everywhere.

program where_demo
  implicit none (type, external)

  real :: x(6), y(6)
  integer :: grade(6)

  x = [-2.0, 0.0, 1.0, 2.7182817, 10.0, -0.5]

  ! Statement form: log only where defined.
  y = 0.0
  where (x > 0.0) y = log(x)
  print '(a, *(1x, f0.3))', 'log where x>0 :', y

  ! Construct with elsewhere branches.
  classify: where (x < 0.0)
    grade = -1
  elsewhere (x == 0.0) classify
    grade = 0
  elsewhere classify
    grade = 1
  end where classify
  print '(a, *(1x, i0))', 'sign classes  :', grade

  ! Nested WHERE.
  where (x > 0.0)
    where (x > 5.0)
      y = 5.0
    elsewhere
      y = x
    end where
  elsewhere
    y = 0.0
  end where
  print '(a, *(1x, f0.3))', 'clamped 0..5  :', y

  ! merge(): element-wise choice in an expression.
  print '(a, *(1x, f0.1))', 'merge(x,0,x>0):', merge(x, 0.0, x > 0.0)

end program where_demo

! Output:
! log where x>0 : .000 .000 .000 1.000 2.303 .000
! sign classes  : -1 0 1 1 1 -1
! clamped 0..5  : .000 .000 1.000 2.718 5.000 .000
! merge(x,0,x>0): .0 .0 1.0 2.7 10.0 .0
