! failure.f90 - reject a negative length before allocate
!
! Built by build.sh.

program failure
  use result_m, only: result_t, fail, failed
  implicit none (type, external)

  type(result_t) :: r
  integer, allocatable :: a(:)

  call fill(-1, a, r)
  print '(a, l1)', 'failed: ', failed(r)
  print '(a, i0)', 'stat = ', r%stat
  print '(a, a)', 'message = ', r%message

contains

  subroutine fill(n, a, r)
    integer, intent(in) :: n
    integer, allocatable, intent(out) :: a(:)
    type(result_t), intent(out) :: r

    if (n < 0) then
      call fail(r, 1, 'length < 0')
      return
    end if
    allocate (a(n))
    a = 0
    call fail(r, 0, '')
  end subroutine fill

end program failure
