program test_geom
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use geom_polygon, only: geom_area_triangle, geom_version
  implicit none (type, external)

  real(real64) :: a

  a = geom_area_triangle(4.0_real64, 3.0_real64)
  if (abs(a - 6.0_real64) > 1.0e-12_real64) then
    error stop "Triangle area calculation failed"
  end if

  write(output_unit, '(a,a)') 'geom library version: ', geom_version
  write(output_unit, '(a)') 'test_geom passed'
end program test_geom
