! -----------------------------------------------------------------------------
! 01_heap.f90 - Binary min-heap and heap sort using 1-based array indexing
!
! Run:  scripts/run.sh 77-heaps/01_heap.f90
! -----------------------------------------------------------------------------
!
! In a 1-based array, a binary tree node at index i has:
!   - Parent at i / 2
!   - Left child at 2 * i
!   - Right child at 2 * i + 1
!
! This chapter demonstrates:
!   - Min-heap insertion (sift-up) and extraction (sift-down) in O(log N)
!   - In-place heap sort in O(N log N)

module heap_m
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)
  private
  public :: min_heap_t, heap_sort

  type :: min_heap_t
    private
    integer, allocatable :: tree(:)
    integer :: n = 0
  contains
    procedure :: init
    procedure :: push
    procedure :: pop
    procedure :: count => heap_count
  end type min_heap_t

contains

  subroutine init(self, capacity)
    class(min_heap_t), intent(inout) :: self
    integer, intent(in) :: capacity
    allocate(self%tree(capacity))
    self%n = 0
  end subroutine init

  subroutine push(self, val)
    class(min_heap_t), intent(inout) :: self
    integer, intent(in) :: val
    integer :: i, parent, tmp

    self%n = self%n + 1
    self%tree(self%n) = val
    i = self%n

    ! Sift up
    do while (i > 1)
      parent = i / 2
      if (self%tree(i) < self%tree(parent)) then
        tmp = self%tree(i)
        self%tree(i) = self%tree(parent)
        self%tree(parent) = tmp
        i = parent
      else
        exit
      end if
    end do
  end subroutine push

  function pop(self) result(val)
    class(min_heap_t), intent(inout) :: self
    integer :: val
    integer :: i, left, right, smallest, tmp

    if (self%n == 0) error stop "Pop from empty heap"

    val = self%tree(1)
    self%tree(1) = self%tree(self%n)
    self%n = self%n - 1

    ! Sift down
    i = 1
    do while (2 * i <= self%n)
      left = 2 * i
      right = 2 * i + 1
      smallest = i

      if (self%tree(left) < self%tree(smallest)) smallest = left
      if (right <= self%n) then
        if (self%tree(right) < self%tree(smallest)) smallest = right
      end if

      if (smallest /= i) then
        tmp = self%tree(i)
        self%tree(i) = self%tree(smallest)
        self%tree(smallest) = tmp
        i = smallest
      else
        exit
      end if
    end do
  end function pop

  pure function heap_count(self) result(cnt)
    class(min_heap_t), intent(in) :: self
    integer :: cnt
    cnt = self%n
  end function heap_count

  subroutine heap_sort(arr)
    integer, intent(inout) :: arr(:)
    type(min_heap_t) :: h
    integer :: i, n

    n = size(arr)
    call h%init(n)
    do i = 1, n
      call h%push(arr(i))
    end do
    do i = 1, n
      arr(i) = h%pop()
    end do
  end subroutine heap_sort

end module heap_m

program heap_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  use heap_m, only: min_heap_t, heap_sort
  implicit none (type, external)

  type(min_heap_t) :: h
  integer :: i, val
  integer :: numbers(5)

  call h%init(10)

  ! Push sequence 5, 1, 4, 2, 3
  call h%push(5)
  call h%push(1)
  call h%push(4)
  call h%push(2)
  call h%push(3)

  ! Pop all elements in ascending order
  write(output_unit, '(a)', advance='no') 'Popped:'
  do while (h%count() > 0)
    val = h%pop()
    write(output_unit, '(1x,i0)', advance='no') val
  end do
  write(output_unit, *)

  ! Heap sort an arbitrary array
  numbers = [5, 1, 4, 2, 3]
  call heap_sort(numbers)

  write(output_unit, '(a,*(1x,i0))') 'Heap sorted:', numbers

end program heap_demo

! Output:
! Popped: 1 2 3 4 5
! Heap sorted: 1 2 3 4 5
