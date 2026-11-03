! -----------------------------------------------------------------------------
! 02_degree_trigonometry.f90 - F2023 degree-based trigonometry
!
! Run:  scripts/run.sh 26-intrinsic-catalog/02_degree_trigonometry.f90
! -----------------------------------------------------------------------------
!
!   sind cosd tand          argument in DEGREES
!   asind acosd atand       result in degrees
!   atan2d(y, x)            result in degrees
!
! F2023 also adds the "pi" family, where the argument or result is a
! multiple of pi (exact at multiples of 0.5):
!   sinpi cospi tanpi asinpi acospi atanpi atan2pi
! gfortran 15 provides the degree functions but not the pi family yet.
!
! Degree functions are exact at common angles: sind(30.0) is exactly 0.5,
! whereas sin(30 * pi / 180) is only close.

program degree_trigonometry
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  real(dp) :: angles(5) = [0.0_dp, 30.0_dp, 45.0_dp, 90.0_dp, 180.0_dp]
  real(dp), parameter :: pi = acos(-1.0_dp)

  print '(a, *(1x, f10.6))', 'sind  :', sind(angles)
  print '(a, *(1x, f10.6))', 'cosd  :', cosd(angles)
  print '(a, f10.6)',        'tand(45)     :', tand(45.0_dp)
  print '(a, f10.6)',        'asind(0.5)   :', asind(0.5_dp)
  print '(a, f10.6)',        'atan2d(1, -1):', atan2d(1.0_dp, -1.0_dp)
  print '(a, l1)', 'sind(30) == 0.5           : ', sind(30.0_dp) == 0.5_dp
  print '(a, l1)', 'sin(30*pi/180) == 0.5     : ', sin(30 * pi / 180) == 0.5_dp

end program degree_trigonometry

! Output:
! sind  :   0.000000   0.500000   0.707107   1.000000  -0.000000
! cosd  :   1.000000   0.866025   0.707107   0.000000  -1.000000
! tand(45)     :  1.000000
! asind(0.5)   : 30.000000
! atan2d(1, -1):135.000000
! sind(30) == 0.5           : T
! sin(30*pi/180) == 0.5     : F
