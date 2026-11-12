! -----------------------------------------------------------------------------
! 01_union_find.f90 - Disjoint set union with path compression and union by rank
!
! Run:  scripts/run.sh 79-union-find/01_union_find.f90
! -----------------------------------------------------------------------------
!
! Union-Find (Disjoint Set Union) partitions elements into disjoint equivalence
! classes with nearly constant amortized time per operation O(alpha(N)):
!   - Path compression flattens tree depth during find operations
!   - Union by rank attaches shallower trees under deeper roots

module union_find_m
  implicit none (type, external)
  private
  public :: dsu_t

  type :: dsu_t
    private
    integer, allocatable :: parent(:)
    integer, allocatable :: rank(:)
    integer :: n = 0
  contains
    procedure :: init
    procedure :: find
    procedure :: union_sets
    procedure :: connected
  end type dsu_t

contains

  subroutine init(self, n)
    class(dsu_t), intent(inout) :: self
    integer, intent(in) :: n
    integer :: i

    self%n = n
    allocate(self%parent(n))
    allocate(self%rank(n))
    do i = 1, n
      self%parent(i) = i
      self%rank(i) = 0
    end do
  end subroutine init

  recursive function find(self, x) result(root)
    class(dsu_t), intent(inout) :: self
    integer, intent(in) :: x
    integer :: root

    if (self%parent(x) /= x) then
      ! Path compression
      self%parent(x) = self%find(self%parent(x))
    end if
    root = self%parent(x)
  end function find

  subroutine union_sets(self, a, b)
    class(dsu_t), intent(inout) :: self
    integer, intent(in) :: a, b
    integer :: root_a, root_b

    root_a = self%find(a)
    root_b = self%find(b)

    if (root_a == root_b) return

    ! Union by rank
    if (self%rank(root_a) < self%rank(root_b)) then
      self%parent(root_a) = root_b
    else if (self%rank(root_a) > self%rank(root_b)) then
      self%parent(root_b) = root_a
    else
      self%parent(root_b) = root_a
      self%rank(root_a) = self%rank(root_a) + 1
    end if
  end subroutine union_sets

  function connected(self, a, b) result(is_conn)
    class(dsu_t), intent(inout) :: self
    integer, intent(in) :: a, b
    logical :: is_conn

    is_conn = (self%find(a) == self%find(b))
  end function connected

end module union_find_m

program union_find_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  use union_find_m, only: dsu_t
  implicit none (type, external)

  type(dsu_t) :: dsu
  integer :: reps(6), i

  call dsu%init(6)

  ! Union operations partitioning into {1, 2, 3} and {4, 5, 6}
  call dsu%union_sets(1, 2)
  call dsu%union_sets(2, 3)
  call dsu%union_sets(4, 5)
  call dsu%union_sets(5, 6)

  ! Collect representatives
  do i = 1, 6
    reps(i) = dsu%find(i)
  end do

  write(output_unit, '(a,*(1x,i0))') 'Representatives:', reps
  write(output_unit, '(a,1x,l1)') 'Connected(1, 3):', dsu%connected(1, 3)
  write(output_unit, '(a,1x,l1)') 'Connected(4, 6):', dsu%connected(4, 6)
  write(output_unit, '(a,1x,l1)') 'Connected(1, 4):', dsu%connected(1, 4)

end program union_find_demo

! Output:
! Representatives: 1 1 1 4 4 4
! Connected(1, 3): T
! Connected(4, 6): T
! Connected(1, 4): F
