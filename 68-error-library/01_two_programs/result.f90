! result.f90 - a status and a message, shared by two programs
!
! Built by build.sh. stat 0 is success. A nonzero stat owns the message.

module result_m
  implicit none (type, external)
  private
  public :: result_t, ok, fail, failed, check_allocate

  type :: result_t
    integer :: stat = 0
    character(len=:), allocatable :: message
  end type result_t

contains

  subroutine ok(r)
    type(result_t), intent(out) :: r
    r%stat = 0
  end subroutine ok

  subroutine fail(r, stat, message)
    type(result_t), intent(out) :: r
    integer, intent(in) :: stat
    character(len=*), intent(in) :: message
    r%stat = stat
    r%message = message
  end subroutine fail

  pure logical function failed(r)
    type(result_t), intent(in) :: r
    failed = r%stat /= 0
  end function failed

  subroutine check_allocate(stat, errmsg, r)
    integer, intent(in) :: stat
    character(len=*), intent(in) :: errmsg
    type(result_t), intent(out) :: r
    if (stat == 0) then
      call ok(r)
    else
      call fail(r, stat, errmsg)
    end if
  end subroutine check_allocate

end module result_m
