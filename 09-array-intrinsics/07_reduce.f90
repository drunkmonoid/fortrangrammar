! -----------------------------------------------------------------------------
! 07_reduce.f90 - REDUCE with your own operation (F2018)
!
! Run:  scripts/run.sh 09-array-intrinsics/07_reduce.f90
! -----------------------------------------------------------------------------
!
!   reduce(array, operation [, mask] [, identity] [, ordered])
!   reduce(array, operation, dim [, mask] [, identity] [, ordered])
!
! * OPERATION is a PURE function of two scalar arguments of the array's
!   type, returning that type. It should be associative: the processor may
!   combine elements in any grouping, unless ordered=.true.
! * IDENTITY is returned for an empty (or fully masked) reduction; without
!   it, an empty reduction is an error.
! * Works on any type, including derived types - the general form of sum,
!   product, maxval...

module reduce_ops
  implicit none (type, external)
contains

  pure integer function gcd(a, b)
    integer, intent(in) :: a, b
    integer :: x, y, t
    x = abs(a); y = abs(b)
    do while (y /= 0)
      t = mod(x, y); x = y; y = t
    end do
    gcd = x
  end function gcd

  pure integer function add(a, b)
    integer, intent(in) :: a, b
    add = a + b
  end function add

  pure function longer(a, b) result(r)
    character(len=8), intent(in) :: a, b
    character(len=8) :: r
    r = merge(a, b, len_trim(a) >= len_trim(b))
  end function longer

end module reduce_ops

program reduce_demo
  use reduce_ops, only: gcd, add, longer
  implicit none (type, external)

  integer :: v(4) = [84, 126, 210, 42]
  integer :: m(2, 3) = reshape([1, 2, 3, 4, 5, 6], [2, 3])
  character(len=8) :: words(4) = [character(len=8) :: 'fig', 'banana', 'kiwi', 'apple']

  print '(a, i0)', 'gcd of all       = ', reduce(v, gcd)
  print '(a, *(1x, i0))', 'sum along dim=1  =', reduce(m, add, dim=1)
  print '(a, i0)', 'masked, empty    = ', reduce(v, add, mask=v > 1000, identity=0)
  print '(a, a)', 'longest word     = ', reduce(words, longer)

end program reduce_demo

! Output:
! gcd of all       = 42
! sum along dim=1  = 3 7 11
! masked, empty    = 0
! longest word     = banana
