! -----------------------------------------------------------------------------
! 04_move_alloc.f90 - MOVE_ALLOC and growable arrays
!
! Run:  scripts/run.sh 08-arrays-dynamic/04_move_alloc.f90
! -----------------------------------------------------------------------------
!
!   call move_alloc(from, to [, stat, errmsg])
!
! Transfers the allocation from FROM to TO without copying data:
!   * TO is deallocated first if needed, then takes over FROM's storage
!     (shape, bounds, values);
!   * FROM becomes unallocated;
!   * both must be allocatable with the same type and rank.
!   * stat/errmsg (F2018) only matter for coarrays.
!
! The classic use is growing a buffer: allocate a bigger temporary, copy the
! old values once, then move the allocation back. Doubling the capacity each
! time keeps appends amortised O(1).

module growable
  implicit none (type, external)
  private
  public :: int_vector

  type :: int_vector
    integer, allocatable :: data(:)
    integer :: n = 0
  contains
    procedure :: push
    procedure :: view
  end type int_vector

contains

  subroutine push(self, value)
    class(int_vector), intent(inout) :: self
    integer, intent(in) :: value
    integer, allocatable :: bigger(:)

    if (.not. allocated(self%data)) allocate (self%data(4))
    if (self%n == size(self%data)) then
      allocate (bigger(2 * size(self%data)))
      bigger(1:self%n) = self%data(1:self%n)
      call move_alloc(from=bigger, to=self%data)      ! no second copy
      print '(a, i0)', '  grew capacity to ', size(self%data)
    end if
    self%n = self%n + 1
    self%data(self%n) = value
  end subroutine push

  function view(self) result(values)
    class(int_vector), intent(in) :: self
    integer, allocatable :: values(:)
    values = self%data(1:self%n)
  end function view

end module growable

program move_alloc_demo
  use growable, only: int_vector
  implicit none (type, external)

  type(int_vector) :: v
  integer, allocatable :: a(:), b(:)
  integer :: i

  ! Basic semantics.
  a = [1, 2, 3]
  call move_alloc(a, b)
  print '(a, l1, a, *(1x, i0))', 'a allocated: ', allocated(a), ', b =', b

  ! Growable vector.
  do i = 1, 10
    call v%push(i * 10)
  end do
  print '(a, *(1x, i0))', 'vector:', v%view()

end program move_alloc_demo

! Output:
! a allocated: F, b = 1 2 3
!   grew capacity to 8
!   grew capacity to 16
! vector: 10 20 30 40 50 60 70 80 90 100
