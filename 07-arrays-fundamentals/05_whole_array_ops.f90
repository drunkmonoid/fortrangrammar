! -----------------------------------------------------------------------------
! 05_whole_array_ops.f90 - operations on whole arrays
!
! Run:  scripts/run.sh 07-arrays-fundamentals/05_whole_array_ops.f90
! -----------------------------------------------------------------------------
!
! Every intrinsic operator works ELEMENT BY ELEMENT on arrays:
!   * array op array  - the operands must CONFORM (same shape; bounds may
!     differ - elements are matched by position, not by index value);
!   * array op scalar - the scalar is broadcast to every element;
!   * relational operators give LOGICAL arrays;
!   * elemental intrinsics (sqrt, abs, sin, max, mod, ...) apply per element.
!
! a * b is element-wise. Matrix product is matmul(a, b) (chapter 09).
!
! Mismatched shapes are an error. With -fcheck=all gfortran checks them at
! run time; without it the result is undefined.

program whole_array_ops
  implicit none (type, external)

  real :: a(4), b(4), c(4)
  real :: m(2, 2)
  logical :: mask(4)
  integer :: low(0:3), high(10:13)

  a = [1.0, 2.0, 3.0, 4.0]
  b = [10.0, 20.0, 30.0, 40.0]

  c = a + b
  print '(a, *(1x, f0.1))', 'a + b      :', c
  c = a * b
  print '(a, *(1x, f0.1))', 'a * b      :', c
  c = 2 * a + 1
  print '(a, *(1x, f0.1))', '2*a + 1    :', c
  c = sqrt(a)
  print '(a, *(1x, f0.3))', 'sqrt(a)    :', c
  c = max(a, 2.5)
  print '(a, *(1x, f0.1))', 'max(a, 2.5):', c

  mask = a > 2.0
  print '(a, *(1x, l1))', 'a > 2      :', mask

  ! Conformance is about shape, not bounds.
  low = [1, 2, 3, 4]
  high = [10, 20, 30, 40]
  print '(a, *(1x, i0))', 'low + high :', low + high

  ! Rank-2: still element-wise.
  m = reshape([1.0, 2.0, 3.0, 4.0], [2, 2])
  print '(a, *(1x, f0.1))', 'm * m (elementwise):', m * m
  print '(a, *(1x, f0.1))', 'matmul(m, m)       :', matmul(m, m)

  ! Elemental intrinsics with mixed scalar/array arguments.
  print '(a, *(1x, i0))', 'mod([7,8,9], 4)    :', mod([7, 8, 9], 4)

end program whole_array_ops

! Output:
! a + b      : 11.0 22.0 33.0 44.0
! a * b      : 10.0 40.0 90.0 160.0
! 2*a + 1    : 3.0 5.0 7.0 9.0
! sqrt(a)    : 1.000 1.414 1.732 2.000
! max(a, 2.5): 2.5 2.5 3.0 4.0
! a > 2      : F F T T
! low + high : 11 22 33 44
! m * m (elementwise): 1.0 4.0 9.0 16.0
! matmul(m, m)       : 7.0 10.0 15.0 22.0
! mod([7,8,9], 4)    : 3 0 1
