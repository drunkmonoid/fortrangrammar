! -----------------------------------------------------------------------------
! 03_assumed_deferred.f90 - assumed (*) and deferred (:) len parameters
!
! Run:  scripts/run.sh 17-parameterized-types/03_assumed_deferred.f90
! -----------------------------------------------------------------------------
!
!   type(vec(*)) :: v          ASSUMED: a dummy argument takes the actual
!                              argument's len parameter (like len=*)
!   type(vec(:)), allocatable :: w
!                              DEFERRED: set when allocated or assigned
!                              (like len=:)
!   allocate (vec(n=10) :: w)  allocate with a type-spec giving the value
!
! Only LEN parameters can be assumed or deferred; KIND parameters are always
! constants.

module pdt_vectors
  implicit none (type, external)

  type :: vec(n)
    integer, len :: n
    real :: v(n)
  end type vec

contains

  real function total(x)
    type(vec(*)), intent(in) :: x          ! any length
    total = sum(x%v)
  end function total

  subroutine make(x, n)
    type(vec(:)), allocatable, intent(out) :: x
    integer, intent(in) :: n
    integer :: i
    allocate (vec(n=n) :: x)
    x%v = [(real(i), i = 1, n)]
  end subroutine make

end module pdt_vectors

program assumed_deferred
  use pdt_vectors, only: vec, total, make
  implicit none (type, external)

  type(vec(3)) :: a
  type(vec(:)), allocatable :: b

  a%v = [1.0, 2.0, 3.0]
  print '(a, i0, a, f0.1)', 'a%n = ', a%n, ', total(a) = ', total(a)

  call make(b, 5)
  print '(a, i0, a, f0.1)', 'b%n = ', b%n, ', total(b) = ', total(b)

end program assumed_deferred

! Output:
! a%n = 3, total(a) = 6.0
! b%n = 5, total(b) = 15.0
