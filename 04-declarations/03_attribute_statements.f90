! -----------------------------------------------------------------------------
! 03_attribute_statements.f90 - attributes given as separate statements
!
! Run:  scripts/run.sh 04-declarations/03_attribute_statements.f90
! -----------------------------------------------------------------------------
!
! Most attributes can also be given by a stand-alone statement, which adds
! the attribute to names declared elsewhere:
!
!   dimension a(10)          allocatable :: b(:)      pointer :: p
!   target :: t              parameter (n = 3)        save :: s
!   intent(in) :: x          optional :: y            value :: v
!   public :: f              private :: g             protected :: c
!   volatile :: r            asynchronous :: buf      contiguous :: q
!   external :: ext          intrinsic :: sin         bind(c) :: cvar
!   codimension :: co[*]
!
! Both styles are standard; this tutorial puts attributes in the
! declaration ("entity-oriented" style) so that everything about a name is
! in one place. Attribute statements are still common for `public` /
! `private` lists in modules, where they read like an export list.
!
! Note PARAMETER's statement form needs parentheses: parameter (n = 3).

program attribute_statements
  implicit none (type, external)

  ! Attribute-statement style (shown, not recommended):
  integer :: n
  parameter (n = 3)
  real :: a
  dimension a(n)
  real :: b
  allocatable :: b(:)
  real :: t
  target :: t
  real, pointer :: p

  ! Equivalent entity-oriented style (recommended):
  integer, parameter :: m = 3
  real :: a2(m)
  real, allocatable :: b2(:)
  real, target :: t2

  a = 1.0; a2 = 1.0
  allocate (b(n), b2(m))
  b = 2.0; b2 = 2.0
  t = 3.0; t2 = 3.0
  p => t

  print '(a, *(1x, f0.1))', 'a, b, p:', a, b, p
  print '(a, *(1x, f0.1))', 'a2, b2, t2:', a2, b2, t2

end program attribute_statements

! Output:
! a, b, p: 1.0 1.0 1.0 2.0 2.0 2.0 3.0
! a2, b2, t2: 1.0 1.0 1.0 2.0 2.0 2.0 3.0
