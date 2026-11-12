! Exercise 01: combine compiler_version inquiry with numeric_storage_size.

program ex01_getting_started
  use, intrinsic :: iso_fortran_env, only: compiler_version, numeric_storage_size, output_unit
  implicit none (type, external)

  logical :: has_ver, bits_ok

  has_ver = len_trim(compiler_version()) > 0
  bits_ok = (numeric_storage_size == bit_size(0))

  write(output_unit, '(a,1x,l1)') 'nonempty compiler_version:', has_ver
  write(output_unit, '(a,1x,l1)') 'numeric_storage_size == bit_size:', bits_ok

end program ex01_getting_started

! Output:
! nonempty compiler_version: T
! numeric_storage_size == bit_size: T
