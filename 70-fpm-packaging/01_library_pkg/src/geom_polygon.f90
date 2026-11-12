module geom_polygon
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  private
  public :: geom_area_triangle, geom_version

  character(len=*), parameter :: geom_version = "1.2.0"

contains

  pure function geom_area_triangle(base, height) result(area)
    real(real64), intent(in) :: base, height
    real(real64) :: area
    area = 0.5_real64 * base * height
  end function geom_area_triangle

end module geom_polygon
