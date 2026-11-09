! 02_stencil/modern.f90 - the same stencil, free form
!
! Built by 02_stencil/build.sh.

program stencil_modern
  implicit none (type, external)

  integer, parameter :: a(*) = [1, 2, 3, 4, 5]
  integer :: b(3), i

  do i = 2, 4
    b(i - 1) = a(i - 1) + a(i) + a(i + 1)
  end do
  print '(a, 3(1x, i0))', 'stencil =', b

end program stencil_modern
