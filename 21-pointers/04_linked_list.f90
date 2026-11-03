! -----------------------------------------------------------------------------
! 04_linked_list.f90 - a doubly linked list with pointer components
!
! Run:  scripts/run.sh 21-pointers/04_linked_list.f90
! -----------------------------------------------------------------------------
!
! Pointer components allow structures with SHARING and CYCLES, which
! allocatable components cannot express: here every node has both `next`
! and `prev`, so each interior node is referenced twice.
!
! The price: you own the memory. The list type below frees its nodes in a
! FINAL procedure, so a list variable that goes out of scope cleans up.
! Copying such a type with intrinsic assignment would copy the POINTERS
! (shallow copy) - two lists sharing nodes, double-free on finalization.
! Real code disables or overrides assignment; here we simply never copy.

module dlist
  implicit none (type, external)
  private
  public :: list

  type :: node
    integer :: value
    type(node), pointer :: next => null(), prev => null()
  end type node

  type :: list
    private
    type(node), pointer :: head => null(), tail => null()
    integer :: n = 0
  contains
    procedure :: push_back, push_front, remove_first, print_forward, print_backward
    final :: destroy
  end type list

contains

  subroutine push_back(self, value)
    class(list), intent(inout) :: self
    integer, intent(in) :: value
    type(node), pointer :: new

    allocate (new)
    new%value = value
    new%prev => self%tail
    if (associated(self%tail)) then
      self%tail%next => new
    else
      self%head => new
    end if
    self%tail => new
    self%n = self%n + 1
  end subroutine push_back

  subroutine push_front(self, value)
    class(list), intent(inout) :: self
    integer, intent(in) :: value
    type(node), pointer :: new

    allocate (new)
    new%value = value
    new%next => self%head
    if (associated(self%head)) then
      self%head%prev => new
    else
      self%tail => new
    end if
    self%head => new
    self%n = self%n + 1
  end subroutine push_front

  subroutine remove_first(self, value)
    class(list), intent(inout) :: self
    integer, intent(in) :: value
    type(node), pointer :: cur

    cur => self%head
    do while (associated(cur))
      if (cur%value == value) then
        if (associated(cur%prev)) then
          cur%prev%next => cur%next
        else
          self%head => cur%next
        end if
        if (associated(cur%next)) then
          cur%next%prev => cur%prev
        else
          self%tail => cur%prev
        end if
        deallocate (cur)
        self%n = self%n - 1
        return
      end if
      cur => cur%next
    end do
  end subroutine remove_first

  subroutine print_forward(self)
    class(list), intent(in) :: self
    type(node), pointer :: cur
    write (*, '(a, i0, a)', advance='no') 'forward  (', self%n, '):'
    cur => self%head
    do while (associated(cur))
      write (*, '(1x, i0)', advance='no') cur%value
      cur => cur%next
    end do
    print '(a)', ''
  end subroutine print_forward

  subroutine print_backward(self)
    class(list), intent(in) :: self
    type(node), pointer :: cur
    write (*, '(a, i0, a)', advance='no') 'backward (', self%n, '):'
    cur => self%tail
    do while (associated(cur))
      write (*, '(1x, i0)', advance='no') cur%value
      cur => cur%prev
    end do
    print '(a)', ''
  end subroutine print_backward

  subroutine destroy(self)
    type(list), intent(inout) :: self
    type(node), pointer :: cur, next
    integer :: freed
    freed = 0
    cur => self%head
    do while (associated(cur))
      next => cur%next
      deallocate (cur)
      freed = freed + 1
      cur => next
    end do
    nullify (self%head, self%tail)
    if (freed > 0) print '(a, i0, a)', 'final: freed ', freed, ' nodes'
  end subroutine destroy

end module dlist

program linked_list
  use dlist, only: list
  implicit none (type, external)

  block
    type(list) :: l
    integer :: i
    do i = 1, 5
      call l%push_back(10 * i)
    end do
    call l%push_front(0)
    call l%print_forward()
    call l%remove_first(30)
    call l%remove_first(0)
    call l%remove_first(50)
    call l%print_forward()
    call l%print_backward()
  end block                                ! l is finalized here

end program linked_list

! Output:
! forward  (6): 0 10 20 30 40 50
! forward  (3): 10 20 40
! backward (3): 40 20 10
! final: freed 3 nodes
