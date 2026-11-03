! -----------------------------------------------------------------------------
! 08_compiler_inquiry.f90 - asking the compiler about itself
!
! Run:  scripts/run.sh 01-getting-started/08_compiler_inquiry.f90
! -----------------------------------------------------------------------------
!
! iso_fortran_env provides two inquiry functions (F2008) that return the
! compiler identification and the options used to compile the current file.
! Both can be used in constant expressions, so the strings below are baked
! into the executable at compile time. Useful in log headers of scientific
! runs so results can be reproduced.
!
! The module also describes the storage model; a few of those constants are
! printed here and the rest are covered in chapter 03.

program compiler_inquiry
  use, intrinsic :: iso_fortran_env, only: compiler_version, compiler_options, &
                                           numeric_storage_size, &
                                           character_storage_size, &
                                           file_storage_size
  implicit none (type, external)

  character(len=*), parameter :: version = compiler_version()
  character(len=*), parameter :: options = compiler_options()

  print '(a)', 'compiler: ' // version
  print '(a)', 'options : ' // options
  print '(a, i0)', 'bits per numeric storage unit  : ', numeric_storage_size
  print '(a, i0)', 'bits per character storage unit: ', character_storage_size
  print '(a, i0)', 'bits per file storage unit     : ', file_storage_size

end program compiler_inquiry
