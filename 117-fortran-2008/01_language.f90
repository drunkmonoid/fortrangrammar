! @flags -std=f2008
! -----------------------------------------------------------------------------
! 01_language.f90 - block, do concurrent, contiguous, newunit, g0
!
! Run:  scripts/run.sh 117-fortran-2008/01_language.f90
! -----------------------------------------------------------------------------
!
! execute_command_line('true') is the shell utility. Its status is 0.

module sum_m
  implicit none

contains

  integer function total(x)
    integer, contiguous, intent(in) :: x(:)
    total = sum(x)
  end function total

end module sum_m

program f2008_language
  use sum_m
  implicit none

  integer :: values(4), i, acc, unit, stored, stat

  do concurrent (i = 1:4)
    values(i) = i
  end do
  acc = total(values)
  block
    integer :: extra
    extra = 1
    acc = acc + extra
  end block

  open (newunit=unit, status='scratch', form='formatted')
  write (unit, '(g0)') 8
  rewind (unit)
  read (unit, *) stored
  close (unit)

  call execute_command_line('true', exitstat=stat)
  print '(i0, 1x, i0, 1x, i0)', acc, stored, stat

end program f2008_language

! Output:
! 11 8 0
