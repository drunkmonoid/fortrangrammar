! -----------------------------------------------------------------------------
! 02_abstract_interfaces.f90 - ABSTRACT INTERFACE and PROCEDURE(...)
!
! Run:  scripts/run.sh 12-procedures-interfaces/02_abstract_interfaces.f90
! -----------------------------------------------------------------------------
!
!   abstract interface
!     real function real_fn(x)          ! a NAMED SIGNATURE, not a procedure
!       real, intent(in) :: x
!     end function real_fn
!   end interface
!
!   procedure(real_fn) :: f             ! dummy procedure with that signature
!   procedure(real_fn), pointer :: p    ! procedure pointer (04_...)
!   procedure(real_fn), deferred ...    ! deferred binding (chapter 19)
!
! An abstract interface defines a procedure TYPE: it can be named in
! PROCEDURE(...) declarations but never called directly. Use one whenever
! several procedures share a signature - callbacks, strategy objects,
! integrands, comparators.
!
! PROCEDURE(name) also accepts an existing procedure as the template:
!   procedure(sin) :: g     ! "a procedure like the intrinsic sin"

module signatures
  implicit none (type, external)

  abstract interface
    pure real function unary_fn(x)
      real, intent(in) :: x
    end function unary_fn

    subroutine event_handler(name, value)
      character(len=*), intent(in) :: name
      integer, intent(in) :: value
    end subroutine event_handler
  end interface

contains

  pure real function square(x)
    real, intent(in) :: x
    square = x * x
  end function square

  pure real function half(x)
    real, intent(in) :: x
    half = x / 2
  end function half

  subroutine print_event(name, value)
    character(len=*), intent(in) :: name
    integer, intent(in) :: value
    print '(3a, i0)', 'event ', name, ' = ', value
  end subroutine print_event

  subroutine apply_all(f, x)
    procedure(unary_fn) :: f            ! dummy procedure
    real, intent(inout) :: x(:)
    integer :: i
    do i = 1, size(x)
      x(i) = f(x(i))
    end do
  end subroutine apply_all

  subroutine fire(handler)
    procedure(event_handler) :: handler
    call handler('tick', 1)
    call handler('tock', 2)
  end subroutine fire

end module signatures

program abstract_interfaces
  use signatures, only: square, half, print_event, apply_all, fire
  implicit none (type, external)

  real :: x(3) = [1.0, 2.0, 3.0]

  call apply_all(square, x)
  print '(a, *(1x, f0.1))', 'squared:', x
  call apply_all(half, x)
  print '(a, *(1x, f0.1))', 'halved :', x
  call fire(print_event)

end program abstract_interfaces

! Output:
! squared: 1.0 4.0 9.0
! halved : .5 2.0 4.5
! event tick = 1
! event tock = 2
