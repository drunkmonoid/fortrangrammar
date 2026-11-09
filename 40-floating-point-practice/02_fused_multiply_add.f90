! -----------------------------------------------------------------------------
! 02_fused_multiply_add.f90 - ieee_fma rounds the product and the add once
!
! Run:  scripts/run.sh 40-floating-point-practice/02_fused_multiply_add.f90
! -----------------------------------------------------------------------------
!
! ieee_fma(a, b, c) computes a*b + c with a single rounding. The source
! expression a*b + c rounds the product, then rounds the sum. When a*b
! is exactly representable, as 2*3 is, both answers are the same.
!
! They differ when a*b needs extra bits. -ffast-math may rewrite the
! source expression into a fused operation, which is why a checksum from
! an optimised build need not match a checksum from -O0.

program fused_multiply_add
  use, intrinsic :: iso_fortran_env, only: dp => real64
  use, intrinsic :: ieee_arithmetic, only: ieee_fma
  implicit none (type, external)

  print '(a, l1)', 'fma(2, 3, 4) == 10: ', ieee_fma(2.0_dp, 3.0_dp, 4.0_dp) == 10.0_dp
  print '(a, l1)', 'source 2*3+4 == 10: ', (2.0_dp * 3.0_dp + 4.0_dp) == 10.0_dp

end program fused_multiply_add

! Output:
! fma(2, 3, 4) == 10: T
! source 2*3+4 == 10: T
