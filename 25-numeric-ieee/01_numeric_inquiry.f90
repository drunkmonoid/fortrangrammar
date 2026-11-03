! -----------------------------------------------------------------------------
! 01_numeric_inquiry.f90 - the numeric model: inquiry functions
!
! Run:  scripts/run.sh 25-numeric-ieee/01_numeric_inquiry.f90
! -----------------------------------------------------------------------------
!
! The standard describes numbers through a MODEL:
!   integers   i = s * sum(w_k * r**(k-1)),  k = 1..q    (r = radix)
!   reals      x = s * b**e * sum(f_k * b**(-k)), k = 1..p
!
! Inquiry functions report the model's parameters for the kind of their
! argument (the argument's VALUE is irrelevant):
!
!   radix(x)        base b (2 on all current hardware)
!   digits(x)       p: significand digits in base b (integers: q)
!   precision(x)    decimal digits of precision
!   range(x)        decimal exponent range
!   epsilon(x)      b**(1-p): the gap between 1 and the next number
!   huge(x)         largest finite model number
!   tiny(x)         smallest positive NORMAL number
!   maxexponent(x), minexponent(x)   model exponent range
!
! tiny() is not the smallest positive value: IEEE subnormals go further
! (see 03_ieee_classes_values.f90).

program numeric_inquiry
  use, intrinsic :: iso_fortran_env, only: real32, real64, real128, int8, int32, int64
  implicit none (type, external)

  real(real32) :: s
  real(real64) :: d
  real(real128) :: q
  ! es15.4e4: four exponent digits, needed for real128's 1e+4932.
  character(len=*), parameter :: fmt = '(i4, i6, i7, i5, i6, 3es15.4e4, 2i7)'

  print '(a)', 'kind radix digits prec range      epsilon           huge           tiny  minexp maxexp'
  print fmt, kind(s), radix(s), digits(s), precision(s), range(s), &
      epsilon(s), huge(s), tiny(s), minexponent(s), maxexponent(s)
  print fmt, kind(d), radix(d), digits(d), precision(d), range(d), &
      epsilon(d), huge(d), tiny(d), minexponent(d), maxexponent(d)
  print fmt, kind(q), radix(q), digits(q), precision(q), range(q), &
      epsilon(q), huge(q), tiny(q), minexponent(q), maxexponent(q)

  print '(a)', ''
  print '(a)', 'integer kinds: digits  range  huge'
  print '(i8, i14, i7, 2x, i0)', int8, digits(0_int8), range(0_int8), huge(0_int8)
  print '(i8, i14, i7, 2x, i0)', int32, digits(0_int32), range(0_int32), huge(0_int32)
  print '(i8, i14, i7, 2x, i0)', int64, digits(0_int64), range(0_int64), huge(0_int64)

end program numeric_inquiry

! Output:
! kind radix digits prec range      epsilon           huge           tiny  minexp maxexp
!    4     2     24    6    37   1.1921E-0007   3.4028E+0038   1.1755E-0038   -125    128
!    8     2     53   15   307   2.2204E-0016   1.7977E+0308   2.2251E-0308  -1021   1024
!   16     2    113   33  4931   1.9259E-0034   1.1897E+4932   3.3621E-4932 -16381  16384
!
! integer kinds: digits  range  huge
!        1             7      2  127
!        4            31      9  2147483647
!        8            63     18  9223372036854775807
