! Create a NetCDF file, write a 1-D variable and attribute, and read them back.
program netcdf_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit, error_unit
  use netcdf
  implicit none (type, external)

  integer :: ncid, dimid, varid, stat
  integer, parameter :: n = 5
  real(real64) :: w_vals(n), r_vals(n)
  character(len=20) :: r_units

  w_vals = [10.0_real64, 20.0_real64, 30.0_real64, 40.0_real64, 50.0_real64]

  ! Create dataset in NetCDF classic / standard mode
  stat = nf90_create("test.nc", NF90_CLOBBER, ncid)
  if (stat /= NF90_NOERR) error stop nf90_strerror(stat)

  ! Define dimension
  stat = nf90_def_dim(ncid, "time", n, dimid)
  if (stat /= NF90_NOERR) error stop nf90_strerror(stat)

  ! Define variable
  stat = nf90_def_var(ncid, "temperature", NF90_DOUBLE, [dimid], varid)
  if (stat /= NF90_NOERR) error stop nf90_strerror(stat)

  ! Attach attribute
  stat = nf90_put_att(ncid, varid, "units", "kelvin")
  if (stat /= NF90_NOERR) error stop nf90_strerror(stat)

  ! End define mode
  stat = nf90_enddef(ncid)
  if (stat /= NF90_NOERR) error stop nf90_strerror(stat)

  ! Write variable data
  stat = nf90_put_var(ncid, varid, w_vals)
  if (stat /= NF90_NOERR) error stop nf90_strerror(stat)

  ! Close file
  stat = nf90_close(ncid)
  if (stat /= NF90_NOERR) error stop nf90_strerror(stat)

  ! Reopen read-only
  stat = nf90_open("test.nc", NF90_NOWRITE, ncid)
  if (stat /= NF90_NOERR) error stop nf90_strerror(stat)

  stat = nf90_inq_varid(ncid, "temperature", varid)
  if (stat /= NF90_NOERR) error stop nf90_strerror(stat)

  stat = nf90_get_var(ncid, varid, r_vals)
  if (stat /= NF90_NOERR) error stop nf90_strerror(stat)

  stat = nf90_get_att(ncid, varid, "units", r_units)
  if (stat /= NF90_NOERR) error stop nf90_strerror(stat)

  stat = nf90_close(ncid)
  if (stat /= NF90_NOERR) error stop nf90_strerror(stat)

  if (all(r_vals == w_vals) .and. trim(r_units) == "kelvin") then
    write(output_unit, '(a)') "NetCDF read/write verified"
  else
    error stop "Data verification mismatch"
  end if
end program netcdf_demo
