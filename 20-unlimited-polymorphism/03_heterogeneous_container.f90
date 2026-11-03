! -----------------------------------------------------------------------------
! 03_heterogeneous_container.f90 - a list that stores values of any type
!
! Run:  scripts/run.sh 20-unlimited-polymorphism/03_heterogeneous_container.f90
! -----------------------------------------------------------------------------
!
! Because an array of class(*) shares one dynamic type, a container wraps
! each element: type :: item; class(*), allocatable :: value; end type.
! The container stores and returns values; the caller recovers their types
! with SELECT TYPE. Memory is managed entirely by allocatables.
! A class(*) dummy is SCALAR here, so arrays cannot be pushed; an
! assumed-rank class(*) dummy, x(..), would accept them.
!
! The list has a fixed capacity to keep this example within what gfortran 15
! handles correctly. Growing an array of class(*) components - by
! `items = [items, item(v)]`, or by move_alloc - is standard Fortran but
! currently crashes or loses character lengths in gfortran. On other
! compilers, grow the array as in chapter 08's int_vector.
!
! This is the run-time-typed alternative to templates (Fortran has no
! compile-time generics yet; they are planned for F202Y).

module any_list_mod
  implicit none (type, external)
  private
  public :: any_list

  integer, parameter :: capacity = 64

  type :: item
    class(*), allocatable :: value
  end type item

  type :: any_list
    private
    type(item) :: items(capacity)
    integer :: n = 0
  contains
    procedure :: push
    procedure :: size => list_size
    procedure :: get
  end type any_list

contains

  subroutine push(self, value)
    class(any_list), intent(inout) :: self
    class(*), intent(in) :: value

    if (self%n == capacity) error stop 'any_list: capacity exceeded'
    self%n = self%n + 1
    allocate (self%items(self%n)%value, source=value)
  end subroutine push

  integer function list_size(self)
    class(any_list), intent(in) :: self
    list_size = self%n
  end function list_size

  subroutine get(self, i, value)
    class(any_list), intent(in) :: self
    integer, intent(in) :: i
    class(*), allocatable, intent(out) :: value
    allocate (value, source=self%items(i)%value)
  end subroutine get

end module any_list_mod

program heterogeneous_container
  use any_list_mod, only: any_list
  implicit none (type, external)

  type(any_list) :: list
  class(*), allocatable :: v
  integer :: i
  real :: real_sum

  call list%push(10)
  call list%push(2.5)
  call list%push('hello')
  call list%push((1.0, 2.0))         ! complex: stored, but not handled below
  call list%push(.false.)
  call list%push(4.5)

  real_sum = 0
  do i = 1, list%size()
    call list%get(i, v)
    select type (v)
    type is (integer)
      print '(a, i0, a, i0)', 'item ', i, ': integer ', v
    type is (real)
      print '(a, i0, a, f0.2)', 'item ', i, ': real ', v
      real_sum = real_sum + v
    type is (character(len=*))
      print '(a, i0, 3a)', 'item ', i, ': string "', v, '"'
    class default
      print '(a, i0, a)', 'item ', i, ': (unhandled type)'
    end select
  end do
  print '(a, f0.2)', 'sum of reals: ', real_sum

end program heterogeneous_container


! Output:
! item 1: integer 10
! item 2: real 2.50
! item 3: string "hello"
! item 4: (unhandled type)
! item 5: (unhandled type)
! item 6: real 4.50
! sum of reals: 7.00
