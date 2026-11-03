! -----------------------------------------------------------------------------
! 05_search.f90 - index, scan, verify
!
! Run:  scripts/run.sh 10-characters/05_search.f90
! -----------------------------------------------------------------------------
!
!   index(string, substring [, back])    position of SUBSTRING (0 if absent)
!   scan(string, set [, back])           position of the first character that
!                                        IS in set
!   verify(string, set [, back])         position of the first character that
!                                        is NOT in set (0 if all are)
!
! back=.true. searches from the right. All return 0 for "not found", and
! all are elemental (string arrays give integer arrays).

program search
  implicit none (type, external)

  character(len=*), parameter :: path = '/home/user/data/run_042.csv'
  character(len=*), parameter :: digits = '0123456789'
  character(len=:), allocatable :: number
  integer :: slash, dot, first_digit, after_digits

  print '(a, i0)', "index(path, 'data')         = ", index(path, 'data')
  print '(a, i0)', "index(path, '/', back=T)    = ", index(path, '/', back=.true.)
  print '(a, i0)', "index(path, 'missing')      = ", index(path, 'missing')
  print '(a, i0)', "scan(path, '._')            = ", scan(path, '._')
  print '(a, i0)', "scan(path, digits)          = ", scan(path, digits)
  print '(a, i0)', "verify('   x', ' ')         = ", verify('   x', ' ')
  print '(a, i0)', "verify('12345', digits)     = ", verify('12345', digits)

  ! Split a path into directory, base name and extension.
  slash = index(path, '/', back=.true.)
  dot = index(path, '.', back=.true.)
  print '(2a)', 'directory : ', path(:slash - 1)
  print '(2a)', 'base name : ', path(slash + 1:dot - 1)
  print '(2a)', 'extension : ', path(dot + 1:)

  ! Extract the run number.
  first_digit = scan(path, digits)
  after_digits = verify(path(first_digit:), digits) + first_digit - 1
  number = path(first_digit:after_digits - 1)
  print '(2a)', 'run number: ', number

  ! Is a string a valid unsigned integer?
  print '(a, l1)', "'0042' is all digits : ", verify('0042', digits) == 0
  print '(a, l1)', "'4x2'  is all digits : ", verify('4x2', digits) == 0

end program search

! Output:
! index(path, 'data')         = 12
! index(path, '/', back=T)    = 16
! index(path, 'missing')      = 0
! scan(path, '._')            = 20
! scan(path, digits)          = 21
! verify('   x', ' ')         = 4
! verify('12345', digits)     = 0
! directory : /home/user/data
! base name : run_042
! extension : csv
! run number: 042
! '0042' is all digits : T
! '4x2'  is all digits : F
