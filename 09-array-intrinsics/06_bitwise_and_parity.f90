! -----------------------------------------------------------------------------
! 06_bitwise_and_parity.f90 - iall, iany, iparity, parity (F2008)
!
! Run:  scripts/run.sh 09-array-intrinsics/06_bitwise_and_parity.f90
! -----------------------------------------------------------------------------
!
!   iall(array [, dim] [, mask])      bitwise AND of all elements
!   iany(array [, dim] [, mask])      bitwise OR
!   iparity(array [, dim] [, mask])   bitwise XOR
!   parity(mask [, dim])              .true. if an ODD number of elements
!                                     are true (logical XOR reduction)
!
! Empty reductions: iall -> all bits set (-1 = not(0)), iany/iparity -> 0,
! parity -> .false.

program bitwise_and_parity
  implicit none (type, external)

  integer :: flags(3) = [int(b'1100'), int(b'1010'), int(b'1001')]

  print '(a, b4.4)', 'iall    = ', iall(flags)
  print '(a, b4.4)', 'iany    = ', iany(flags)
  print '(a, b4.4)', 'iparity = ', iparity(flags)
  print '(a, l1)', 'parity([T, T, F]) = ', parity([.true., .true., .false.])
  print '(a, l1)', 'parity([T, F, F]) = ', parity([.true., .false., .false.])

end program bitwise_and_parity

! Output:
! iall    = 1000
! iany    = 1111
! iparity = 1111
! parity([T, T, F]) = F
! parity([T, F, F]) = T
