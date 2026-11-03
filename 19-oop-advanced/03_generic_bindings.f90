! -----------------------------------------------------------------------------
! 03_generic_bindings.f90 - type-bound GENERIC bindings
!
! Run:  scripts/run.sh 19-oop-advanced/03_generic_bindings.f90
! -----------------------------------------------------------------------------
!
!   type :: logger
!   contains
!     procedure, private :: log_int, log_real, log_text   ! specifics
!     generic :: log => log_int, log_real, log_text       ! one public name
!   end type
!
!   call lg%log(42); call lg%log(3.14); call lg%log('text')
!
! * A generic binding resolves by TKR of the non-passed arguments, like a
!   generic interface (chapter 12).
! * The specific bindings are often PRIVATE: users only see the generic.
! * Extensions may ADD specifics to an inherited generic, or override the
!   specific bindings it refers to.

module logging
  implicit none (type, external)
  private
  public :: logger

  type :: logger
    character(len=8) :: prefix = 'log'
    integer :: lines = 0
  contains
    procedure, private :: log_int, log_real, log_text, log_ints
    generic :: log => log_int, log_real, log_text, log_ints
  end type logger

contains

  subroutine log_int(self, x)
    class(logger), intent(inout) :: self
    integer, intent(in) :: x
    self%lines = self%lines + 1
    print '(a, ": int  ", i0)', trim(self%prefix), x
  end subroutine log_int

  subroutine log_real(self, x)
    class(logger), intent(inout) :: self
    real, intent(in) :: x
    self%lines = self%lines + 1
    print '(a, ": real ", g0)', trim(self%prefix), x
  end subroutine log_real

  subroutine log_text(self, x)
    class(logger), intent(inout) :: self
    character(len=*), intent(in) :: x
    self%lines = self%lines + 1
    print '(a, ": text ", a)', trim(self%prefix), x
  end subroutine log_text

  subroutine log_ints(self, x)
    class(logger), intent(inout) :: self
    integer, intent(in) :: x(:)
    self%lines = self%lines + 1
    print '(a, ": ints", *(1x, i0))', trim(self%prefix), x
  end subroutine log_ints

end module logging

program generic_bindings
  use logging, only: logger
  implicit none (type, external)

  type(logger) :: lg

  call lg%log(42)
  call lg%log(2.5)
  call lg%log('hello')
  call lg%log([1, 2, 3])
  print '(a, i0)', 'lines logged: ', lg%lines
  ! call lg%log_int(1)   <- error: the specific binding is private

end program generic_bindings

! Output:
! log: int  42
! log: real 2.50000000
! log: text hello
! log: ints 1 2 3
! lines logged: 4
