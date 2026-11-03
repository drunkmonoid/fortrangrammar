! -----------------------------------------------------------------------------
! 03_numeric_functions.f90 - rounding, conversion and range checks
!
! Run:  scripts/run.sh 26-intrinsic-catalog/03_numeric_functions.f90
! -----------------------------------------------------------------------------
!
!   aint(x)  truncate, result REAL       int(x)     truncate, INTEGER
!   anint(x) round half away, REAL       nint(x)    round half away, INTEGER
!   floor(x) toward -inf, INTEGER        ceiling(x) toward +inf, INTEGER
!   mod(a, p)    a - int(a/p)*p     (sign of a)
!   modulo(a, p) a - floor(a/p)*p   (sign of p)
!   max(a1, a2, ...), min(...)      any number of arguments, also characters
!   real(x [, kind]), dble(x), cmplx(x [, y] [, kind]), int(x [, kind])
!   aimag(z), conjg(z), real(z)
!   out_of_range(x, mold [, round])  (F2018) would converting x to the type
!                                    and kind of mold overflow?
!
! Always pass kind= to conversions whose default-kind result would lose
! information (chapter 03).

program numeric_functions
  use, intrinsic :: iso_fortran_env, only: int8, int64, dp => real64
  implicit none (type, external)

  real(dp) :: v(4) = [-2.5_dp, -1.5_dp, 1.5_dp, 2.5_dp]

  print '(a, *(1x, f5.1))', 'v       :', v
  print '(a, *(1x, f5.1))', 'aint    :', aint(v)
  print '(a, *(1x, f5.1))', 'anint   :', anint(v)
  print '(a, *(1x, i5))',   'int     :', int(v)
  print '(a, *(1x, i5))',   'nint    :', nint(v)
  print '(a, *(1x, i5))',   'floor   :', floor(v)
  print '(a, *(1x, i5))',   'ceiling :', ceiling(v)
  print '(a, *(1x, f5.1))', 'mod(v,2)   :', mod(v, 2.0_dp)
  print '(a, *(1x, f5.1))', 'modulo(v,2):', modulo(v, 2.0_dp)

  print '(a, i0, 1x, a)', 'max/min    : ', max(3, 9, -1, 7), min('pear', 'apple', 'fig')

  print '(a, l1)', 'out_of_range(300.0, 0_int8)  : ', out_of_range(300.0_dp, 0_int8)
  print '(a, l1)', 'out_of_range(100.0, 0_int8)  : ', out_of_range(100.0_dp, 0_int8)
  print '(a, l1)', 'out_of_range(1e30, 0_int64)  : ', out_of_range(1.0e30_dp, 0_int64)

end program numeric_functions

! Output:
! v       :  -2.5  -1.5   1.5   2.5
! aint    :  -2.0  -1.0   1.0   2.0
! anint   :  -3.0  -2.0   2.0   3.0
! int     :    -2    -1     1     2
! nint    :    -3    -2     2     3
! floor   :    -3    -2     1     2
! ceiling :    -2    -1     2     3
! mod(v,2)   :  -0.5  -1.5   1.5   0.5
! modulo(v,2):   1.5   0.5   1.5   0.5
! max/min    : 9 apple
! out_of_range(300.0, 0_int8)  : T
! out_of_range(100.0, 0_int8)  : F
! out_of_range(1e30, 0_int64)  : T
