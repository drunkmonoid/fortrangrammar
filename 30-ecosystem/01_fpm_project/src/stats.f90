! src/stats.f90 - the library part of the package.
module stats
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)
  private
  public :: dp, mean, variance

contains

  pure real(dp) function mean(x)
    real(dp), intent(in) :: x(:)
    mean = sum(x) / max(size(x), 1)
  end function mean

  pure real(dp) function variance(x)
    real(dp), intent(in) :: x(:)
    variance = sum((x - mean(x))**2) / max(size(x) - 1, 1)
  end function variance

end module stats
