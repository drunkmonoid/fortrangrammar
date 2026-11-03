! -----------------------------------------------------------------------------
! 03_component_accessibility.f90 - private components and private types
!
! Run:  scripts/run.sh 16-derived-types/03_component_accessibility.f90
! -----------------------------------------------------------------------------
!
!   type, public :: account           the type name is public
!     private                         components private by default...
!     integer :: cents = 0
!     character(len=20), public :: owner = ''   ...except this one
!   end type
!
!   type, private :: internal_node    the type itself is private
!
! * PRIVATE components are accessible only inside the defining MODULE.
!   Outside, objects can be declared, passed around and assigned as a
!   whole, but those components cannot be named - this is encapsulation.
! * A structure constructor cannot be used outside the module if it would
!   need a private component; provide a custom constructor or procedures.
! * `private` inside a type before CONTAINS affects components; a separate
!   `private` after CONTAINS affects type-bound procedures (chapter 18).

module accounts
  implicit none (type, external)
  private
  public :: account, open_account, deposit, balance

  type :: account
    private
    integer :: cents = 0
    character(len=20), public :: owner = ''
  end type account

contains

  function open_account(owner, initial_cents) result(a)
    character(len=*), intent(in) :: owner
    integer, intent(in) :: initial_cents
    type(account) :: a
    a%owner = owner
    a%cents = max(initial_cents, 0)
  end function open_account

  subroutine deposit(a, cents)
    type(account), intent(inout) :: a
    integer, intent(in) :: cents
    if (cents > 0) a%cents = a%cents + cents
  end subroutine deposit

  integer function balance(a)
    type(account), intent(in) :: a
    balance = a%cents
  end function balance

end module accounts

program component_accessibility
  use accounts, only: account, open_account, deposit, balance
  implicit none (type, external)

  type(account) :: acc, copy

  acc = open_account('Grace', 1000)
  call deposit(acc, 250)
  call deposit(acc, -999)                 ! rejected inside the module
  copy = acc                               ! whole-object assignment is fine
  print '(3a, i0)', 'owner: ', trim(copy%owner), ', balance: ', balance(copy)
  ! acc%cents = 0                 <- error: cents is a private component
  ! acc = account(0, 'Eve')       <- error: constructor needs private cents

end program component_accessibility

! Output:
! owner: Grace, balance: 1250
