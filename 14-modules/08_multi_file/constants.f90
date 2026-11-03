! constants.f90 - lowest layer: depends on nothing but intrinsic modules.
module constants
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)
  private
  public :: dp, pi, g

  real(dp), parameter :: pi = acos(-1.0_dp)
  real(dp), parameter :: g = 9.80665_dp
end module constants
