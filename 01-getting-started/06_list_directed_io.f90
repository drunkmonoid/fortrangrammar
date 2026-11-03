! -----------------------------------------------------------------------------
! 06_list_directed_io.f90 - first steps with PRINT, WRITE and READ
!
! Run:  scripts/run.sh 01-getting-started/06_list_directed_io.f90
!       echo 7 | scripts/run.sh 01-getting-started/06_list_directed_io.f90
! -----------------------------------------------------------------------------
!
! The two output statements:
!
!   print fmt, items              always the default output unit
!   write (unit, fmt) items       any unit, plus optional specifiers
!
! `fmt` is either `*` (list-directed: compiler picks the layout) or a format
! string such as '(a, i0)'. Formats get a whole chapter (22); this file uses
! only a few descriptors:
!
!   a     character, as wide as the value
!   i0    integer, minimal width
!   f0.2  real, minimal width, 2 decimals
!   g0    any intrinsic type, minimal width
!
! iso_fortran_env names the preconnected units instead of the traditional
! magic numbers 5 (input) and 6 (output).

program list_directed_io
  use, intrinsic :: iso_fortran_env, only: input_unit, output_unit, &
                                           error_unit, iostat_end
  implicit none (type, external)

  integer :: a, b, ios
  real :: x
  character(len=:), allocatable :: text
  character(len=200) :: msg

  ! --- Output -------------------------------------------------------------
  print *, 'PRINT * writes to standard output'
  write (*, *) 'WRITE (*, *) does the same'
  write (output_unit, *) 'and so does WRITE (output_unit, *)'
  write (error_unit, *) 'error_unit is standard error'

  ! List-directed output of mixed items: spacing is compiler-dependent.
  print *, 'mixed items:', 42, 3.5, .true.

  ! An explicit format gives exact control.
  print '(a, i0, a, f0.2)', 'formatted: a=', 42, ' x=', 3.5

  ! --- Input from a string (an "internal file") ----------------------------
  ! List-directed input splits on blanks, commas or slashes and converts
  ! each field to the type of the receiving variable.
  text = '10, 20  2.5'
  read (text, *) a, b, x
  print '(a, 3(1x, g0))', 'parsed from string:', a, b, x

  ! --- Input from standard input ------------------------------------------
  ! IOSTAT= turns I/O errors into a status code instead of a crash:
  !   0          success
  !   iostat_end end of file (e.g. empty pipe or /dev/null)
  !   other > 0  an error; IOMSG= receives a readable explanation
  write (output_unit, '(a)', advance='no') 'enter an integer: '
  read (input_unit, *, iostat=ios, iomsg=msg) a

  if (ios == iostat_end) then
    print '(/, a)', '(no input: end of file)'
  else if (ios /= 0) then
    print '(/, a)', 'read failed: ' // trim(msg)
  else
    print '(a, i0)', 'you typed ', a
  end if

end program list_directed_io
