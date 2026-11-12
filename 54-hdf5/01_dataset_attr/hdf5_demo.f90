! Create an HDF5 file, write a 1-D double dataset and string attribute, and read them back.
program hdf5_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit, error_unit
  use hdf5
  implicit none (type, external)

  integer(HID_T) :: file_id, space_id, dset_id, attr_id, attr_type, attr_space
  integer :: error
  integer, parameter :: n = 5
  real(real64) :: w_data(n), r_data(n)
  integer(HSIZE_T) :: dims(1)
  character(len=10) :: w_units, r_units
  integer(SIZE_T) :: attr_len

  dims(1) = n
  w_data = [1.0_real64, 2.0_real64, 3.0_real64, 4.0_real64, 5.0_real64]
  w_units = "meters    "
  attr_len = 10_SIZE_T

  ! Initialise HDF5 Fortran interface
  call h5open_f(error)
  if (error /= 0) error stop "h5open_f failed"

  ! Create a new file
  call h5fcreate_f("test.h5", H5F_ACC_TRUNC_F, file_id, error)
  if (error /= 0) error stop "h5fcreate_f failed"

  ! Create simple dataspace for 1-D array
  call h5screate_simple_f(1, dims, space_id, error)
  if (error /= 0) error stop "h5screate_simple_f failed"

  ! Create dataset of double precision reals
  call h5dcreate_f(file_id, "data", H5T_NATIVE_DOUBLE, space_id, dset_id, error)
  if (error /= 0) error stop "h5dcreate_f failed"

  ! Write dataset
  call h5dwrite_f(dset_id, H5T_NATIVE_DOUBLE, w_data, dims, error)
  if (error /= 0) error stop "h5dwrite_f failed"

  ! Create scalar dataspace and string datatype for attribute
  call h5screate_f(H5S_SCALAR_F, attr_space, error)
  call h5tcopy_f(H5T_FORTRAN_S1, attr_type, error)
  call h5tset_size_f(attr_type, attr_len, error)

  ! Create and write attribute "units"
  call h5acreate_f(dset_id, "units", attr_type, attr_space, attr_id, error)
  call h5awrite_f(attr_id, attr_type, w_units, dims, error)

  ! Close attribute and dataspaces
  call h5aclose_f(attr_id, error)
  call h5tclose_f(attr_type, error)
  call h5sclose_f(attr_space, error)
  call h5dclose_f(dset_id, error)
  call h5sclose_f(space_id, error)
  call h5fclose_f(file_id, error)

  ! Reopen file read-only and read dataset and attribute back
  call h5fopen_f("test.h5", H5F_ACC_RDONLY_F, file_id, error)
  if (error /= 0) error stop "h5fopen_f failed"

  call h5dopen_f(file_id, "data", dset_id, error)
  call h5dread_f(dset_id, H5T_NATIVE_DOUBLE, r_data, dims, error)

  call h5aopen_f(dset_id, "units", attr_id, error)
  call h5tcopy_f(H5T_FORTRAN_S1, attr_type, error)
  call h5tset_size_f(attr_type, attr_len, error)
  call h5aread_f(attr_id, attr_type, r_units, dims, error)

  call h5aclose_f(attr_id, error)
  call h5tclose_f(attr_type, error)
  call h5dclose_f(dset_id, error)
  call h5fclose_f(file_id, error)

  ! Close HDF5 Fortran interface
  call h5close_f(error)

  if (all(r_data == w_data) .and. trim(r_units) == "meters") then
    write(output_unit, '(a)') "HDF5 read/write verified"
  else
    error stop "Data verification mismatch"
  end if
end program hdf5_demo
