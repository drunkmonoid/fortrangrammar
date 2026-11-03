! -----------------------------------------------------------------------------
! 03_do_concurrent_reduce.f90 - REDUCE locality (F2023)
!
! Run:  scripts/run.sh 28-native-parallelism/03_do_concurrent_reduce.f90
! -----------------------------------------------------------------------------
!
!   do concurrent (i = 1:n) reduce(+: total) reduce(max: biggest)
!
! A reduction variable is updated by every iteration with one operator;
! the processor may keep partial results per thread and combine them.
! Operators: +  *  .and.  .or.  .eqv.  .neqv.  max  min  iand  ior  ieor
!
! Inside the loop the variable may only be used as `v = v op expr`
! (or v = max(v, expr), etc.). The order of combination is unspecified, so
! floating-point sums can differ in the last bits between runs/compilers.

program do_concurrent_reduce
  implicit none (type, external)

  integer, parameter :: n = 1000
  integer :: i, total, biggest, mask_bits
  logical :: all_positive
  real :: values(n)

  values = [(sin(real(i)), i = 1, n)]
  total = 0
  biggest = -huge(biggest)
  all_positive = .true.
  mask_bits = 0

  do concurrent (i = 1:n) reduce(+: total) reduce(max: biggest) &
                          reduce(.and.: all_positive) reduce(ior: mask_bits)
    total = total + i
    biggest = max(biggest, mod(i * 37, 101))
    all_positive = all_positive .and. values(i) > -2.0
    mask_bits = ior(mask_bits, ishft(1, mod(i, 8)))
  end do

  print '(a, i0)', 'sum 1..1000      = ', total
  print '(a, i0)', 'max mod(37 i,101)= ', biggest
  print '(a, l1)', 'all > -2         : ', all_positive
  print '(a, b8.8)', 'ior of bits      = ', mask_bits

end program do_concurrent_reduce

! Output:
! sum 1..1000      = 500500
! max mod(37 i,101)= 100
! all > -2         : T
! ior of bits      = 11111111
