! -----------------------------------------------------------------------------
! 01_sorted_table.f90 - Sorted array map with binary search and in-order insertion
!
! Run:  scripts/run.sh 81-sorted-tables/01_sorted_table.f90
! -----------------------------------------------------------------------------
!
! A sorted array map (flat map) stores key-value pairs sorted strictly by key.
! It provides:
!   - O(log N) binary search lookup
!   - Cache-optimal contiguous traversal
!   - Ideal memory efficiency for small-to-medium tables with frequent reads

module sorted_table_m
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)
  private
  public :: sorted_table_t

  type :: pair_t
    integer :: key = 0
    integer :: val = 0
  end type pair_t

  type :: sorted_table_t
    private
    type(pair_t), allocatable :: entries(:)
    integer :: n = 0
  contains
    procedure :: init
    procedure :: insert
    procedure :: get
    procedure :: print_table
    procedure :: binary_search
  end type sorted_table_t

contains

  subroutine init(self, initial_cap)
    class(sorted_table_t), intent(inout) :: self
    integer, intent(in) :: initial_cap
    allocate(self%entries(initial_cap))
    self%n = 0
  end subroutine init

  subroutine binary_search(self, key, found, pos)
    class(sorted_table_t), intent(in) :: self
    integer, intent(in) :: key
    logical, intent(out) :: found
    integer, intent(out) :: pos
    integer :: low, high, mid

    low = 1
    high = self%n
    found = .false.
    pos = 1

    do while (low <= high)
      mid = (low + high) / 2
      if (self%entries(mid)%key == key) then
        found = .true.
        pos = mid
        return
      else if (self%entries(mid)%key < key) then
        low = mid + 1
      else
        high = mid - 1
      end if
    end do

    found = .false.
    pos = low
  end subroutine binary_search

  subroutine insert(self, key, val)
    class(sorted_table_t), intent(inout) :: self
    integer, intent(in) :: key, val
    logical :: found
    integer :: pos, i
    type(pair_t), allocatable :: tmp(:)

    call self%binary_search(key, found, pos)

    if (found) then
      self%entries(pos)%val = val
      return
    end if

    ! Grow capacity if needed
    if (self%n == size(self%entries)) then
      allocate(tmp(size(self%entries) * 2))
      tmp(1:self%n) = self%entries(1:self%n)
      call move_alloc(from=tmp, to=self%entries)
    end if

    ! Shift elements to the right to maintain sorted order
    do i = self%n, pos, -1
      self%entries(i+1) = self%entries(i)
    end do

    self%entries(pos)%key = key
    self%entries(pos)%val = val
    self%n = self%n + 1
  end subroutine insert

  function get(self, key, val) result(stat)
    class(sorted_table_t), intent(in) :: self
    integer, intent(in) :: key
    integer, intent(out) :: val
    integer :: stat
    logical :: found
    integer :: pos

    call self%binary_search(key, found, pos)
    if (found) then
      val = self%entries(pos)%val
      stat = 0
    else
      val = 0
      stat = -1
    end if
  end function get

  subroutine print_table(self)
    class(sorted_table_t), intent(in) :: self
    integer :: i

    write(output_unit, '(a)', advance='no') 'Sorted keys:'
    do i = 1, self%n
      write(output_unit, '(1x,i0)', advance='no') self%entries(i)%key
    end do
    write(output_unit, *)

    write(output_unit, '(a)', advance='no') 'Sorted values:'
    do i = 1, self%n
      write(output_unit, '(1x,i0)', advance='no') self%entries(i)%val
    end do
    write(output_unit, *)
  end subroutine print_table

end module sorted_table_m

program sorted_table_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  use sorted_table_m, only: sorted_table_t
  implicit none (type, external)

  type(sorted_table_t) :: table
  integer :: val, stat

  call table%init(4)

  ! Insert keys out of order: 30, 10, 50, 20, 40
  call table%insert(30, 300)
  call table%insert(10, 100)
  call table%insert(50, 500)
  call table%insert(20, 200)
  call table%insert(40, 400)

  ! Print table in sorted order
  call table%print_table()

  ! Successful lookup
  stat = table%get(30, val)
  write(output_unit, '(a,i0,a,i0)') 'Lookup 30: val = ', val, ', stat = ', stat

  ! Failed lookup
  stat = table%get(99, val)
  write(output_unit, '(a,i0)') 'Lookup 99 (missing): stat = ', stat

end program sorted_table_demo

! Output:
! Sorted keys: 10 20 30 40 50
! Sorted values: 100 200 300 400 500
! Lookup 30: val = 300, stat = 0
! Lookup 99 (missing): stat = -1
