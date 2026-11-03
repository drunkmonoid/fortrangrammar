! -----------------------------------------------------------------------------
! 06_include_line.f90 - the INCLUDE line
!
! Run:  scripts/run.sh 02-lexical-elements/06_include_line.f90
! -----------------------------------------------------------------------------
!
!   include 'file-name'
!
! INCLUDE is not a statement: it is a line that the compiler replaces with
! the contents of the named file before parsing. Rules:
!
!   * It must be alone on its line (a trailing comment is allowed).
!   * It cannot be labelled or continued.
!   * The included text must consist of complete statements.
!   * How the file name is searched is processor-dependent; gfortran looks
!     in the directory of the including file, then in -I directories.
!
! Modern code shares declarations through MODULES instead: a module is
! compiled once, is type-checked and controls visibility. INCLUDE is still
! seen in code that shares constants with C headers or old libraries
! (e.g. 'mpif.h').

program include_line
  implicit none (type, external)

  include '06_include_constants.inc'

  print '(a, f0.5)', 'g = ', gravity
  print '(a, es12.5)', 'c = ', speed_of_light

end program include_line

! Output:
! g = 9.80665
! c =  2.99792E+08
