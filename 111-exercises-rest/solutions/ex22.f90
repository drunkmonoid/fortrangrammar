! Exercise 22: an explicit format written to an internal file and read back.
program ex22
  implicit none (type, external)

  character(len=8) :: buf
  integer :: n

  write (buf, '(i4)') 42
  read (buf, '(i4)') n
  print '(a, i0)', 'n = ', n

end program ex22

! Output:
! n = 42
