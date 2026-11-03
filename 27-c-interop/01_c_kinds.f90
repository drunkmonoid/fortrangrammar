! -----------------------------------------------------------------------------
! 01_c_kinds.f90 - iso_c_binding: interoperable kinds and constants
!
! Run:  scripts/run.sh 27-c-interop/01_c_kinds.f90
! -----------------------------------------------------------------------------
!
! iso_c_binding names the Fortran kind that matches each C type. Use these
! kinds for every argument and component shared with C:
!
!   Fortran                       C
!   integer(c_int)                int
!   integer(c_short / c_long / c_long_long)   short / long / long long
!   integer(c_size_t)             size_t
!   integer(c_intptr_t)           intptr_t
!   integer(c_int8_t ... c_int64_t)           int8_t ... int64_t
!   integer(c_signed_char)        signed char
!   real(c_float / c_double / c_long_double)  float / double / long double
!   complex(c_float_complex ...)  float _Complex ...
!   logical(c_bool)               _Bool
!   character(kind=c_char)        char
!   type(c_ptr), type(c_funptr)   void *, function pointer
!
! A negative kind value means "no such C type on this platform".
! Character constants: c_null_char, c_new_line, c_carriage_return, c_horizontal_tab, ...

program c_kinds
  use, intrinsic :: iso_c_binding
  implicit none (type, external)

  print '(a, i0)', 'c_int         = ', c_int
  print '(a, i0)', 'c_long        = ', c_long
  print '(a, i0)', 'c_long_long   = ', c_long_long
  print '(a, i0)', 'c_size_t      = ', c_size_t
  print '(a, i0)', 'c_int8_t      = ', c_int8_t
  print '(a, i0)', 'c_float       = ', c_float
  print '(a, i0)', 'c_double      = ', c_double
  print '(a, i0)', 'c_long_double = ', c_long_double
  print '(a, i0)', 'c_bool        = ', c_bool
  print '(a, i0)', 'c_char        = ', c_char
  print '(a, i0)', 'iachar(c_null_char) = ', iachar(c_null_char)
  print '(a, i0)', 'iachar(c_new_line)  = ', iachar(c_new_line)

end program c_kinds

! Output:
! c_int         = 4
! c_long        = 8
! c_long_long   = 8
! c_size_t      = 8
! c_int8_t      = 1
! c_float       = 4
! c_double      = 8
! c_long_double = 10
! c_bool        = 1
! c_char        = 1
! iachar(c_null_char) = 0
! iachar(c_new_line)  = 10
