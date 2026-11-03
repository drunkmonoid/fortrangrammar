! -----------------------------------------------------------------------------
! 09_preprocessor.F90 - the C-style preprocessor (not part of the standard)
!
! Run:  scripts/run.sh 02-lexical-elements/09_preprocessor.F90
!       FFLAGS="-std=f2023 -DUSE_DOUBLE" scripts/run.sh 02-lexical-elements/09_preprocessor.F90
! -----------------------------------------------------------------------------
!
! The ISO standard has no preprocessor (an optional "CoCo" part was
! withdrawn). In practice every compiler runs a C-like preprocessor on files
! with an UPPERCASE extension (.F90) or when given -cpp / -fpp.
!
! Lines starting with # are directives; they must start in column 1 for
! portability. Use the preprocessor sparingly: for platform switches and
! build configuration, not for things kind parameters or modules can do.
!
! Predefined macros differ per compiler, e.g.
!   __GFORTRAN__        gfortran
!   __INTEL_COMPILER    Intel ifort / __INTEL_LLVM_COMPILER for ifx
!   __flang__           LLVM Flang
!   __FILE__, __LINE__  current file and line (most compilers)
!   _OPENMP             set when compiling with OpenMP

!
! Trap: cpp sees `1.0_REAL_KIND` as ONE token (a "pp-number") and does not
! expand the macro inside it. Copy the macro into a Fortran named constant
! once, and use that everywhere instead.

#define GREETING 'hello from a macro'

#ifdef USE_DOUBLE
#  define REAL_KIND 8
#else
#  define REAL_KIND 4
#endif

program preprocessor
  implicit none (type, external)

  integer, parameter :: wp = REAL_KIND
  real(kind=wp) :: x

  x = 1.0_wp / 3.0_wp
  print '(a)', GREETING
  print '(a, i0, a, g0)', 'real kind ', kind(x), ': x = ', x

#ifdef __GFORTRAN__
  print '(a)', 'compiled by gfortran'
#endif

  print '(a, i0)', 'this line is number ', __LINE__

end program preprocessor
