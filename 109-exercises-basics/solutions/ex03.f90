! Exercise 03: int64 arithmetic paired with complex(real64) conjugate norm check.

program ex03_intrinsic_types
  use, intrinsic :: iso_fortran_env, only: int64, real64, output_unit
  implicit none (type, external)

  complex(real64) :: z, prod
  integer(int64) :: expected_norm2
  logical :: ok

  z = (3.0_real64, 4.0_real64)
  prod = z * conjg(z)
  expected_norm2 = 3_int64**2 + 4_int64**2

  ok = (abs(aimag(prod)) < 1.0e-12_real64) .and. (nint(real(prod, real64), int64) == expected_norm2)
  write(output_unit, '(a,1x,l1,1x,i0)') 'conjugate norm ok:', ok, nint(real(prod, real64), int64)

end program ex03_intrinsic_types

! Output:
! conjugate norm ok: T 25
