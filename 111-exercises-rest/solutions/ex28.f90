! @flags -fcoarray=single
! Exercise 28: one image. The coarray is the local variable.
program ex28
  implicit none (type, external)

  integer :: value[*]

  value = this_image() * 3
  print '(a, i0, 1x, i0, 1x, i0)', 'image = ', this_image(), num_images(), value

end program ex28

! Output:
! image = 1 1 3
