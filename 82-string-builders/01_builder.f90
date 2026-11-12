! -----------------------------------------------------------------------------
! 01_builder.f90 - Amortized O(1) string builder using doubling + move_alloc
!
! Run:  scripts/run.sh 82-string-builders/01_builder.f90
! -----------------------------------------------------------------------------
!
! Repeatedly concatenating onto a deferred-length string inside a loop:
!   character(len=:), allocatable :: s
!   s = ""
!   do i = 1, n
!     s = s // pieces(i)   ! O(N^2) total copies: reallocates and copies all of s each time
!   end do
!
! A string builder maintains a geometric-growth buffer and a current used
! length, doubling capacity via move_alloc when full and slicing buf(1:used)
! at the end.

module string_builder_m
  implicit none (type, external)
  private
  public :: string_builder_t

  type :: string_builder_t
    private
    character(len=:), allocatable :: buf
    integer :: used = 0
  contains
    procedure :: append
    procedure :: to_string
    procedure :: length => builder_length
    procedure :: capacity => builder_capacity
  end type string_builder_t

contains

  subroutine append(self, text)
    class(string_builder_t), intent(inout) :: self
    character(len=*), intent(in) :: text
    character(len=:), allocatable :: tmp
    integer :: text_len, needed, cap

    text_len = len(text)
    if (text_len == 0) return

    if (.not. allocated(self%buf)) then
      cap = max(8, text_len)
      allocate(character(len=cap) :: self%buf)
      self%used = 0
    end if

    needed = self%used + text_len
    cap = len(self%buf)
    if (needed > cap) then
      do while (cap < needed)
        cap = cap * 2
      end do
      allocate(character(len=cap) :: tmp)
      if (self%used > 0) then
        tmp(1:self%used) = self%buf(1:self%used)
      end if
      call move_alloc(from=tmp, to=self%buf)
    end if

    self%buf(self%used + 1 : needed) = text
    self%used = needed
  end subroutine append

  pure function to_string(self) result(res)
    class(string_builder_t), intent(in) :: self
    character(len=:), allocatable :: res

    if (.not. allocated(self%buf) .or. self%used == 0) then
      res = ''
    else
      res = self%buf(1:self%used)
    end if
  end function to_string

  pure function builder_length(self) result(n)
    class(string_builder_t), intent(in) :: self
    integer :: n
    n = self%used
  end function builder_length

  pure function builder_capacity(self) result(cap)
    class(string_builder_t), intent(in) :: self
    integer :: cap
    if (allocated(self%buf)) then
      cap = len(self%buf)
    else
      cap = 0
    end if
  end function builder_capacity

end module string_builder_m

program string_builder_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  use string_builder_m, only: string_builder_t
  implicit none (type, external)

  type(string_builder_t) :: sb

  call sb%append('Fortran')
  call sb%append(' ')
  call sb%append('2023')
  call sb%append(' ')
  call sb%append('string')
  call sb%append(' ')
  call sb%append('builder')

  write(output_unit, '(2a)') 'Built: ', sb%to_string()
  write(output_unit, '(a,1x,i0)') 'Length:', sb%length()
  write(output_unit, '(a,1x,i0)') 'Capacity:', sb%capacity()

end program string_builder_demo

! Output:
! Built: Fortran 2023 string builder
! Length: 27
! Capacity: 32
