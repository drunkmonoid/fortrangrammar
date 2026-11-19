! Exercise 34: the deleted forms are assign, assigned go to, arithmetic if,
! pause, a real do variable, and a do loop shared by two nests.
! This file uses an integer do and select case. Those still compile.
program ex34
  implicit none (type, external)

  integer :: i, total, tag, picked

  total = 0
  do i = 1, 4
    total = total + i
  end do

  tag = 2
  select case (tag)
  case (1)
    picked = 10
  case (2)
    picked = 20
  case default
    picked = 0
  end select
  print '(a, i0, 1x, i0)', 'replacements = ', total, picked

end program ex34

! Output:
! replacements = 10 20
