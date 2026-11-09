! success.f90 - allocate a positive length and report stat 0
!
! Built by build.sh.

program success
  use result_m, only: result_t, fail, failed, check_allocate
  implicit none (type, external)

  type(result_t) :: r
  integer, allocatable :: a(:), b(:)
  integer :: stat
  character(len=128) :: errmsg

  call fill(4, a, r)
  if (failed(r)) then
    print '(a)', 'unexpected failure'
    error stop 1
  end if
  print '(a, i0)', 'stat = ', r%stat
  print '(a, 4(1x, i0))', 'a =', a

  allocate (b(2), stat=stat, errmsg=errmsg)
  call check_allocate(stat, trim(errmsg), r)
  print '(a, l1)', 'second allocate ok: ', .not. failed(r)

contains

  subroutine fill(n, a, r)
    integer, intent(in) :: n
    integer, allocatable, intent(out) :: a(:)
    type(result_t), intent(out) :: r
    integer :: i, stat
    character(len=128) :: errmsg

    if (n < 0) then
      call fail(r, 1, 'length < 0')
      return
    end if
    allocate (a(n), stat=stat, errmsg=errmsg)
    call check_allocate(stat, trim(errmsg), r)
    if (failed(r)) return
    do i = 1, n
      a(i) = i
    end do
  end subroutine fill

end program success
