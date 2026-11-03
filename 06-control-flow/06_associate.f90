! -----------------------------------------------------------------------------
! 06_associate.f90 - the ASSOCIATE construct (F2003)
!
! Run:  scripts/run.sh 06-control-flow/06_associate.f90
! -----------------------------------------------------------------------------
!
!   [name:] associate (alias => selector [, alias => selector]...)
!     ...
!   end associate [name]
!
! An associate-name is a short alias for the selector:
!   * if the selector is a VARIABLE (incl. a section or component), the alias
!     refers to the same storage: assigning to it changes the original;
!   * if the selector is an EXPRESSION, it is evaluated ONCE on entry and the
!     alias is a read-only value;
!   * the alias has the type, kind, rank and shape of the selector; array
!     aliases have lower bounds 1 (for expressions) or the selector's bounds;
!   * aliases are not declared and cannot be redeclared inside.
!
! Typical uses: shortening long component paths, naming subexpressions,
! and giving names to array sections.

program associate_construct
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  type :: particle
    real(dp) :: position(3) = 0
    real(dp) :: velocity(3) = 0
  end type particle

  type(particle) :: p(2)
  real(dp) :: matrix(4, 4)
  real(dp), parameter :: dt = 0.5_dp
  integer :: i

  p(1)%velocity = [1.0_dp, 2.0_dp, 3.0_dp]

  ! Alias for a component path: updates go to p(1).
  associate (pos => p(1)%position, vel => p(1)%velocity)
    pos = pos + vel * dt
  end associate
  print '(a, 3(1x, f0.2))', 'p(1)%position =', p(1)%position

  ! Alias for an expression: evaluated once, read-only.
  associate (speed => norm2(p(1)%velocity), half => dt / 2)
    print '(a, f0.4, a, f0.2)', 'speed = ', speed, ', half dt = ', half
    ! speed = 0   <- error: an expression alias is not definable
  end associate

  ! Alias for an array section.
  matrix = reshape([(real(i, dp), i = 1, 16)], [4, 4])
  associate (inner => matrix(2:3, 2:3))
    inner = 0
    print '(a, *(1x, i0))', 'shape(inner):', shape(inner)
  end associate
  print '(a, 4(1x, f0.0))', 'matrix row 2:', matrix(2, :)

end program associate_construct

! Output:
! p(1)%position = .50 1.00 1.50
! speed = 3.7417, half dt = .25
! shape(inner): 2 2
! matrix row 2: 2. 0. 0. 14.
