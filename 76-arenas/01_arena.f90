! -----------------------------------------------------------------------------
! 01_arena.f90 - Array-backed arena for node allocation and indexing
!
! Run:  scripts/run.sh 76-arenas/01_arena.f90
! -----------------------------------------------------------------------------
!
! An arena allocates all node memory upfront in a single contiguous pool.
! Links are integer indices rather than Fortran pointers (chapter 21),
! which:
!   - Eliminates pointer aliasing and heap fragmentation
!   - Avoids per-node allocate/deallocate overhead
!   - Improves cache locality
! Reclaimed nodes are returned to an integer free list stack for O(1) reuse.

module arena_m
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)
  private
  public :: arena_t

  type :: node_t
    integer :: value = 0
    integer :: next = 0  ! 0 denotes end of list (null)
  end type node_t

  type :: arena_t
    private
    type(node_t), allocatable :: pool(:)
    integer, allocatable :: free_stack(:)
    integer :: free_top = 0
    integer :: next_free = 1
  contains
    procedure :: init
    procedure :: alloc_node
    procedure :: free_node
    procedure :: get_value
    procedure :: get_next
    procedure :: set_next
  end type arena_t

contains

  subroutine init(self, capacity)
    class(arena_t), intent(inout) :: self
    integer, intent(in) :: capacity

    allocate(self%pool(capacity))
    allocate(self%free_stack(capacity))
    self%free_top = 0
    self%next_free = 1
  end subroutine init

  function alloc_node(self, val) result(idx)
    class(arena_t), intent(inout) :: self
    integer, intent(in) :: val
    integer :: idx

    if (self%free_top > 0) then
      idx = self%free_stack(self%free_top)
      self%free_top = self%free_top - 1
    else
      idx = self%next_free
      self%next_free = self%next_free + 1
    end if

    self%pool(idx)%value = val
    self%pool(idx)%next = 0
  end function alloc_node

  subroutine free_node(self, idx)
    class(arena_t), intent(inout) :: self
    integer, intent(in) :: idx

    self%pool(idx)%value = 0
    self%pool(idx)%next = 0
    self%free_top = self%free_top + 1
    self%free_stack(self%free_top) = idx
  end subroutine free_node

  pure function get_value(self, idx) result(val)
    class(arena_t), intent(in) :: self
    integer, intent(in) :: idx
    integer :: val
    val = self%pool(idx)%value
  end function get_value

  pure function get_next(self, idx) result(nxt)
    class(arena_t), intent(in) :: self
    integer, intent(in) :: idx
    integer :: nxt
    nxt = self%pool(idx)%next
  end function get_next

  subroutine set_next(self, idx, nxt)
    class(arena_t), intent(inout) :: self
    integer, intent(in) :: idx, nxt
    self%pool(idx)%next = nxt
  end subroutine set_next

end module arena_m

program arena_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  use arena_m, only: arena_t
  implicit none (type, external)

  type(arena_t) :: arena
  integer :: n1, n2, n3, n4, cur

  call arena%init(10)

  ! Build a three-node linked list: n1 (10) -> n2 (20) -> n3 (30)
  n1 = arena%alloc_node(10)
  n2 = arena%alloc_node(20)
  n3 = arena%alloc_node(30)

  call arena%set_next(n1, n2)
  call arena%set_next(n2, n3)

  ! Traverse and print values in order
  write(output_unit, '(a)', advance='no') 'Initial list:'
  cur = n1
  do while (cur /= 0)
    write(output_unit, '(1x,i0)', advance='no') arena%get_value(cur)
    cur = arena%get_next(cur)
  end do
  write(output_unit, *)

  ! Reclaim middle node n2: bypass n2 and push index onto free list
  call arena%set_next(n1, n3)
  call arena%free_node(n2)

  ! Traverse list after removal
  write(output_unit, '(a)', advance='no') 'List after removal:'
  cur = n1
  do while (cur /= 0)
    write(output_unit, '(1x,i0)', advance='no') arena%get_value(cur)
    cur = arena%get_next(cur)
  end do
  write(output_unit, *)

  ! Allocate new node, verifying index reuse
  n4 = arena%alloc_node(99)
  write(output_unit, '(a,1x,i0)') 'Reused node index:', n4

end program arena_demo

! Output:
! Initial list: 10 20 30
! List after removal: 10 30
! Reused node index: 2
