! -----------------------------------------------------------------------------
! 01_type_bound_procedures.f90 - methods: procedures bound to a type
!
! Run:  scripts/run.sh 18-oop-polymorphism/01_type_bound_procedures.f90
! -----------------------------------------------------------------------------
!
!   type :: counter
!     integer :: n = 0
!   contains
!     procedure :: increment            ! binding name = procedure name
!     procedure :: get => counter_get   ! binding name => implementation
!   end type
!
!   call c%increment()                  ! object%binding(args)
!   x = c%get()
!
! * The object is passed automatically as the FIRST argument (the "passed
!   object dummy"), which must be declared CLASS(type) - not TYPE(type) -
!   so that extensions of the type can inherit the binding.
! * The name `self` (or `this`) is a convention, not a keyword.
! * Bindings are public by default; `private` after CONTAINS changes that.
! * `procedure :: a, b, c` binds several at once.

module counters
  implicit none (type, external)
  private
  public :: counter

  type :: counter
    integer :: n = 0
  contains
    procedure :: increment
    procedure :: add
    procedure :: get => counter_get
    procedure :: reset
  end type counter

contains

  subroutine increment(self)
    class(counter), intent(inout) :: self
    self%n = self%n + 1
  end subroutine increment

  subroutine add(self, k)
    class(counter), intent(inout) :: self
    integer, intent(in) :: k
    self%n = self%n + k
  end subroutine add

  integer function counter_get(self)
    class(counter), intent(in) :: self
    counter_get = self%n
  end function counter_get

  subroutine reset(self)
    class(counter), intent(inout) :: self
    self%n = 0
  end subroutine reset

end module counters

program type_bound_procedures
  use counters, only: counter
  implicit none (type, external)

  type(counter) :: c

  call c%increment()
  call c%increment()
  call c%add(10)
  print '(a, i0)', 'c%get() = ', c%get()
  call c%reset()
  print '(a, i0)', 'after reset: ', c%get()

end program type_bound_procedures

! Output:
! c%get() = 12
! after reset: 0
