! -----------------------------------------------------------------------------
! 06_date_and_time.f90 - clocks and calendars
!
! Run:  scripts/run.sh 24-errors-environment/06_date_and_time.f90
! -----------------------------------------------------------------------------
!
!   call date_and_time([date] [, time] [, zone] [, values])
!       date 'CCYYMMDD', time 'hhmmss.sss', zone '+hhmm'
!       values(8): year, month, day, UTC offset (minutes), hour, minute,
!                  second, millisecond
!   call cpu_time(t)
!       processor time in seconds (CPU time of the PROCESS - with threads it
!       may exceed wall time). Use differences only.
!   call system_clock([count] [, count_rate] [, count_max])
!       WALL-CLOCK ticks. Elapsed seconds = (c2 - c1) / rate. Use int64
!       arguments for the best resolution (gfortran: nanoseconds) and to
!       avoid wrap-around.
!
! For benchmarks measure with system_clock; report cpu_time as well to see
! parallel speedup.

program date_and_time_demo
  use, intrinsic :: iso_fortran_env, only: int64, real64
  implicit none (type, external)

  character(len=8) :: date
  character(len=10) :: time
  character(len=5) :: zone
  integer :: values(8)
  integer(int64) :: c1, c2, rate
  real(real64) :: t1, t2, s
  integer :: i

  call date_and_time(date, time, zone, values)
  print '(a, a, 1x, a, 1x, a)', 'date/time/zone: ', date, time, zone
  print '(a, i4.4, "-", i2.2, "-", i2.2, 1x, i2.2, ":", i2.2, ":", i2.2)', &
      'formatted     : ', values(1:3), values(5:7)

  call system_clock(count_rate=rate)
  print '(a, i0, a)', 'system_clock rate: ', rate, ' ticks/s'

  call system_clock(c1)
  call cpu_time(t1)
  s = 0
  do i = 1, 5000000
    s = s + sin(real(i, real64))
  end do
  call cpu_time(t2)
  call system_clock(c2)
  print '(a, f0.4, a, f0.4, a, es10.3, a)', 'wall: ', real(c2 - c1, real64) / rate, &
      ' s, cpu: ', t2 - t1, ' s   (result ', s, ')'

end program date_and_time_demo
