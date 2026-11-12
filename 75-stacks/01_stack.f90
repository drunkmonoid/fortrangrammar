! -----------------------------------------------------------------------------
! 01_stack.f90 - Growable integer stack using move_alloc
!
! Run:  scripts/run.sh 75-stacks/01_stack.f90
! -----------------------------------------------------------------------------
!
! Demonstrates dynamic array growth using move_alloc (from chapter 08).
! When capacity is reached, an array of double size is allocated, existing
! elements are copied, and move_alloc reassigns the buffer with zero
! pointer-overhead or extra memory retention.

module stack_m
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)
  private
  public :: stack_t

  type :: stack_t
    private
    integer, allocatable :: data(:)
    integer :: top = 0
  contains
    procedure :: push
    procedure :: pop
    procedure :: count => stack_count
    procedure :: print_elements
  end type stack_t

contains

  subroutine push(self, val)
    class(stack_t), intent(inout) :: self
    integer, intent(in) :: val
    integer, allocatable :: tmp(:)
    integer :: new_cap

    if (.not. allocated(self%data)) then
      allocate(self%data(4))
    else if (self%top == size(self%data)) then
      new_cap = size(self%data) * 2
      allocate(tmp(new_cap))
      tmp(1:self%top) = self%data(1:self%top)
      call move_alloc(from=tmp, to=self%data)
    end if

    self%top = self%top + 1
    self%data(self%top) = val
  end subroutine push

  subroutine pop(self, val, stat)
    class(stack_t), intent(inout) :: self
    integer, intent(out) :: val
    integer, intent(out) :: stat

    if (self%top == 0) then
      stat = -1
      val = 0
      return
    end if

    val = self%data(self%top)
    self%top = self%top - 1
    stat = 0
  end subroutine pop

  pure function stack_count(self) result(cnt)
    class(stack_t), intent(in) :: self
    integer :: cnt
    cnt = self%top
  end function stack_count

  subroutine print_elements(self)
    class(stack_t), intent(in) :: self
    write(output_unit, '(a,*(1x,i0))') 'Elements:', self%data(1:self%top)
  end subroutine print_elements

end module stack_m

program stack_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  use stack_m, only: stack_t
  implicit none (type, external)

  type(stack_t) :: s
  integer :: val, stat

  ! Fixed script of operations
  call s%push(10)
  call s%push(20)
  call s%push(30)
  call s%push(40)
  call s%push(50)  ! Triggers capacity doubling from 4 to 8

  call s%pop(val, stat)
  write(output_unit, '(a,1x,i0)') 'Popped:', val

  call s%push(60)
  call s%push(70)

  call s%pop(val, stat)
  write(output_unit, '(a,1x,i0)') 'Popped:', val
  call s%pop(val, stat)
  write(output_unit, '(a,1x,i0)') 'Popped:', val

  write(output_unit, '(a,1x,i0)') 'Stack size:', s%count()
  call s%print_elements()

  ! Pop empty stack test
  call s%pop(val, stat)
  call s%pop(val, stat)
  call s%pop(val, stat)
  call s%pop(val, stat)
  call s%pop(val, stat)
  write(output_unit, '(a,1x,i0)') 'Empty pop stat:', stat

end program stack_demo

! Output:
! Popped: 50
! Popped: 70
! Popped: 60
! Stack size: 4
! Elements: 10 20 30 40
! Empty pop stat: -1
