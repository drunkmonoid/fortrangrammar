! -----------------------------------------------------------------------------
! 06_intrinsic_modules.f90 - the standard intrinsic modules
!
! Run:  scripts/run.sh 14-modules/06_intrinsic_modules.f90
! -----------------------------------------------------------------------------
!
!   use, intrinsic :: iso_fortran_env     kinds, units, iostat codes,
!                                         compiler_version, atomic/lock/event/
!                                         team types (chapters 03, 23, 28)
!   use, intrinsic :: iso_c_binding       C interoperability (chapter 27)
!   use, intrinsic :: ieee_arithmetic     IEEE classes, values, rounding (25)
!   use, intrinsic :: ieee_exceptions     IEEE flags and halting (25)
!   use, intrinsic :: ieee_features       request IEEE features (25)
!
! Common vendor/library "intrinsic" modules (not ISO): omp_lib (OpenMP),
! openacc, mpi / mpi_f08 (MPI - an ordinary non-intrinsic module).
!
! The `intrinsic` / `non_intrinsic` keyword selects between a standard
! module and a user module that happens to have the same name:
!   use, intrinsic :: iso_c_binding       the standard one, guaranteed
!   use, non_intrinsic :: utils           must be a user module
! Plain `use iso_c_binding` prefers a user module if one exists.

program intrinsic_modules
  use, intrinsic :: iso_fortran_env, only: int64, real64, output_unit, iostat_end, &
                                           compiler_version
  use, intrinsic :: iso_c_binding, only: c_double, c_int, c_null_char
  use, intrinsic :: ieee_arithmetic, only: ieee_value, ieee_quiet_nan, ieee_is_nan
  implicit none (type, external)

  real(real64) :: nan

  nan = ieee_value(nan, ieee_quiet_nan)

  write (output_unit, '(a, i0)') 'iso_fortran_env int64 kind  = ', int64
  write (output_unit, '(a, i0)') 'iso_fortran_env iostat_end  = ', iostat_end
  write (output_unit, '(a, l1)') 'c_double == real64          : ', c_double == real64
  write (output_unit, '(a, i0)') 'c_int kind                  = ', c_int
  write (output_unit, '(a, i0)') 'iachar(c_null_char)         = ', iachar(c_null_char)
  write (output_unit, '(a, l1)') 'ieee_is_nan(nan)            : ', ieee_is_nan(nan)
  write (output_unit, '(a, l1)') 'compiler_version non-empty  : ', len(compiler_version()) > 0

end program intrinsic_modules

! Output:
! iso_fortran_env int64 kind  = 8
! iso_fortran_env iostat_end  = -1
! c_double == real64          : T
! c_int kind                  = 4
! iachar(c_null_char)         = 0
! ieee_is_nan(nan)            : T
! compiler_version non-empty  : T
