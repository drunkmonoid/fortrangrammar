! -----------------------------------------------------------------------------
! 08_g0_idioms.f90 - practical formatting recipes
!
! Run:  scripts/run.sh 22-formatted-io/08_g0_idioms.f90
! -----------------------------------------------------------------------------
!
! G0 (F2008) prints any intrinsic type with a minimal, complete
! representation: integers like I0, reals with full precision, logicals
! as T/F, characters as A. It makes many formats one-size-fits-all:
!
!   '(*(g0))'              everything concatenated
!   '(*(g0, :, ", "))'     comma-separated values
!   '(*(g0, :, 1x))'       space-separated
!   '(*(g0.3, :, 1x))'     reals with 3 significant digits (g0.d)
!
! For tables prefer explicit widths (I8, F10.3, ES12.4) so columns align.

program g0_idioms
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  real(dp) :: data(4) = [1.0_dp, 0.1_dp, 2.0_dp / 3, 1.0e10_dp]
  integer :: i

  print '(*(g0))', 'n=', 3, ' x=', 2.5_dp, ' ok=', .true.
  print '(*(g0, :, ", "))', data
  print '(*(g0.3, :, 1x))', data
  print '(a)', 'csv:'
  print '(a)', 'index,value,square'
  do i = 1, 3
    print '(*(g0, :, ","))', i, data(i), data(i)**2
  end do
  ! The last row does not fit F14.4: the field is filled with asterisks.
  print '(a)', 'aligned table:'
  do i = 1, size(data)
    print '(i3, 2x, es12.4, 2x, f14.4)', i, data(i), data(i)
  end do

end program g0_idioms

! Output:
! n=3 x=2.5000000000000000 ok=T
! 1.0000000000000000, 0.10000000000000001, 0.66666666666666663, 10000000000.000000
! 1.00 0.100 0.667 0.100E+011
! csv:
! index,value,square
! 1,1.0000000000000000,1.0000000000000000
! 2,0.10000000000000001,0.10000000000000002E-001
! 3,0.66666666666666663,0.44444444444444442
! aligned table:
!   1    1.0000E+00          1.0000
!   2    1.0000E-01          0.1000
!   3    6.6667E-01          0.6667
!   4    1.0000E+10  **************
