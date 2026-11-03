! -----------------------------------------------------------------------------
! 01_explicit_interfaces.f90 - explicit vs implicit interfaces
!
! Run:  scripts/run.sh 12-procedures-interfaces/01_explicit_interfaces.f90
! -----------------------------------------------------------------------------
!
! The INTERFACE of a procedure is its name, kind (function/subroutine),
! dummy argument names, types, kinds, ranks and attributes, and its result.
!
! The caller has an EXPLICIT interface when the procedure is:
!   * a module procedure (in a module it USEs or the same module),
!   * an internal procedure,
!   * an intrinsic,
!   * declared with an interface block or a PROCEDURE(iface) statement.
! Otherwise (external procedure, no interface block) the interface is
! IMPLICIT: the compiler guesses from the call and checks nothing. With
! implicit none (external) such calls are rejected.
!
! An explicit interface is REQUIRED when the procedure has any of:
!   optional / keyword use, assumed-shape, assumed-rank, allocatable,
!   pointer or target dummies, polymorphic or coarray dummies, value,
!   array / pointer / allocatable / deferred-length results, bind(c),
!   or is elemental / generic / an operator.
!
! An interface block repeats the procedure's header and declarations
! (without the body). Writing them by hand duplicates code that can drift:
! keep them for EXTERNAL procedures and C functions only.

program explicit_interfaces
  implicit none (type, external)

  ! Interface block for an external function defined below.
  interface
    function normalise(v) result(u)
      implicit none
      real, intent(in) :: v(:)          ! assumed shape: needs this interface
      real :: u(size(v))
    end function normalise
  end interface

  print '(a, *(1x, f0.3))', 'normalise([3,4]) =', normalise([3.0, 4.0])

end program explicit_interfaces

function normalise(v) result(u)
  implicit none (type, external)
  real, intent(in) :: v(:)
  real :: u(size(v))

  u = v / norm2(v)
end function normalise

! Output:
! normalise([3,4]) = .600 .800
