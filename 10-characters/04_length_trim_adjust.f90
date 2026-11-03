! -----------------------------------------------------------------------------
! 04_length_trim_adjust.f90 - len, len_trim, trim, adjustl, adjustr, repeat
!
! Run:  scripts/run.sh 10-characters/04_length_trim_adjust.f90
! -----------------------------------------------------------------------------
!
!   len(s)          length including trailing blanks (a deferred-length
!                   string must be allocated first)
!   len_trim(s)     length without trailing blanks
!   trim(s)         s without trailing blanks (shorter result)
!   adjustl(s)      move leading blanks to the end  (same length)
!   adjustr(s)      move trailing blanks to the front (same length)
!   repeat(s, n)    n copies of s concatenated
!
! trim(adjustl(s)) removes blanks on both sides - the usual "strip".

program length_trim_adjust
  implicit none (type, external)

  character(len=12) :: s

  s = '   centre'
  print '(3a)', 's               = [', s, ']'
  print '(a, i0, 1x, i0)', 'len, len_trim   = ', len(s), len_trim(s)
  print '(3a)', 'trim(s)         = [', trim(s), ']'
  print '(3a)', 'adjustl(s)      = [', adjustl(s), ']'
  print '(3a)', 'adjustr(s)      = [', adjustr(s), ']'
  print '(3a)', 'trim(adjustl(s))= [', trim(adjustl(s)), ']'
  print '(3a)', "repeat('-=', 5) = [", repeat('-=', 5), ']'

  ! Right-aligning numbers in a fixed-width column.
  print '(3a)', '[', adjustr('42      '), ']'

end program length_trim_adjust

! Output:
! s               = [   centre   ]
! len, len_trim   = 12 9
! trim(s)         = [   centre]
! adjustl(s)      = [centre      ]
! adjustr(s)      = [      centre]
! trim(adjustl(s))= [centre]
! repeat('-=', 5) = [-=-=-=-=-=]
! [      42]
