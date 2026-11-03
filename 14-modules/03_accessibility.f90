! -----------------------------------------------------------------------------
! 03_accessibility.f90 - PUBLIC and PRIVATE
!
! Run:  scripts/run.sh 14-modules/03_accessibility.f90
! -----------------------------------------------------------------------------
!
!   private                    make PRIVATE the default for this module
!   public :: a, b             export these
!   real, public :: x          attribute form
!   private :: helper
!
! * Without a default statement, everything is PUBLIC.
! * Recommended: `private` at the top, then an explicit public list - the
!   module's API is written in one place and helpers cannot leak.
! * Accessibility applies to names: a public procedure may have private
!   dummy types only if the type itself is public (otherwise nobody could
!   call it); derived-type components have their own accessibility
!   (chapter 16).
! * Entities imported with USE are re-exported unless made private.
!   `public :: name` on a used name re-exports it on purpose (a facade).

module bank
  use, intrinsic :: iso_fortran_env, only: int64
  implicit none (type, external)
  private                                   ! default: hidden

  public :: deposit, balance, int64         ! the API (int64 re-exported)

  integer(int64) :: cents = 0               ! private state

contains

  subroutine deposit(amount)
    integer(int64), intent(in) :: amount
    call validate(amount)
    cents = cents + amount
  end subroutine deposit

  integer(int64) function balance()
    balance = cents
  end function balance

  subroutine validate(amount)               ! private helper
    integer(int64), intent(in) :: amount
    if (amount <= 0) error stop 'deposit must be positive'
  end subroutine validate

end module bank

program accessibility
  use bank, only: deposit, balance, int64   ! int64 comes through bank
  implicit none (type, external)

  call deposit(1500_int64)
  call deposit(250_int64)
  print '(a, i0)', 'balance in cents: ', balance()
  ! cents = 0            <- error: cents is private to bank
  ! call validate(1)     <- error: validate is private

end program accessibility

! Output:
! balance in cents: 1750
