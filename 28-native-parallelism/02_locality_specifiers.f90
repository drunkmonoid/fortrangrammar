! -----------------------------------------------------------------------------
! 02_locality_specifiers.f90 - LOCAL, LOCAL_INIT, SHARED, DEFAULT(NONE)
!
! Run:  scripts/run.sh 28-native-parallelism/02_locality_specifiers.f90
! -----------------------------------------------------------------------------
!
! F2018 lets you say how each variable behaves inside DO CONCURRENT:
!
!   local(x)        every iteration gets its own x, undefined on entry and
!                   discarded afterwards (a private temporary)
!   local_init(x)   like local, but each copy starts with x's value before
!                   the loop
!   shared(y)       one y for all iterations (the default for variables not
!                   otherwise specified) - iterations must not conflict
!   default(none)   every variable used must appear in a locality spec;
!                   catches forgotten temporaries at compile time
!   reduce(op: s)   F2023 reduction, see 03_do_concurrent_reduce.f90
!
! Without local(), a scalar temporary assigned in the body is SHARED and
! is a data race once the loop runs in parallel.

program locality_specifiers
  implicit none (type, external)

  integer, parameter :: n = 5
  real :: x(n), y(n), tmp, offset
  integer :: i

  x = [(real(i), i = 1, n)]
  offset = 100
  tmp = -1

  do concurrent (i = 1:n) local(tmp) local_init(offset) shared(x, y) default(none)
    tmp = x(i) * 2            ! private scratch per iteration
    offset = offset + i       ! private copy initialised to 100
    y(i) = tmp + offset
  end do

  print '(a, *(1x, f0.0))', 'y =', y
  print '(a, f0.0, a, f0.0)', 'outside: tmp = ', tmp, ', offset = ', offset
  ! LOCAL and LOCAL_INIT variables inside the loop are separate construct
  ! entities, so the outside tmp and offset are untouched (-1 and 100).

end program locality_specifiers

! Output:
! y = 103. 106. 109. 112. 115.
! outside: tmp = -1., offset = 100.
