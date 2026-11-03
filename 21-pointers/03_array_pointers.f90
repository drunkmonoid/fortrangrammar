! -----------------------------------------------------------------------------
! 03_array_pointers.f90 - array pointers, bounds and rank remapping
!
! Run:  scripts/run.sh 21-pointers/03_array_pointers.f90
! -----------------------------------------------------------------------------
!
!   real, pointer :: p(:)           deferred-shape array pointer
!
!   p => a                          whole array (bounds of a kept)
!   p => a(2:8:2)                   any section, even strided (lower bound 1)
!   p(0:) => a                      LOWER BOUND specification (F2003)
!   m(1:3, 1:4) => v                RANK REMAPPING (F2008): view a rank-1
!                                   array as rank 2; v must be simply
!                                   contiguous (or rank 1)
!   row => m(2, :)                  pointer to a row (strided in memory)
!
! Array pointers carry a descriptor (address, bounds, strides), so they can
! describe non-contiguous views without copying. That flexibility is also
! why the compiler must assume a pointer may alias other data.

program array_pointers
  implicit none (type, external)

  integer, target :: a(10), v(12)
  integer, pointer :: p(:) => null(), m(:, :) => null(), row(:) => null()
  integer :: i

  a = [(i, i = 1, 10)]
  v = [(i, i = 1, 12)]

  p => a(2:8:2)
  print '(a, *(1x, i0))', 'p => a(2:8:2)      :', p
  print '(a, i0, 1x, i0)', 'bounds of p        : ', lbound(p), ubound(p)
  p = 0                                   ! writes into a
  print '(a, *(1x, i0))', 'a after p = 0      :', a

  p(0:) => a
  print '(a, i0, 1x, i0)', 'p(0:) => a bounds  : ', lbound(p), ubound(p)
  print '(a, i0)', 'p(0) is a(1)       : ', p(0)

  m(1:3, 1:4) => v                        ! rank remapping
  print '(a, *(1x, i0))', 'shape of remapped m:', shape(m)
  print '(a, *(1x, i0))', 'm(2, :)            :', m(2, :)

  row => m(2, :)
  row = -row                              ! modifies v through two aliases
  print '(a, *(1x, i0))', 'v after row = -row :', v

end program array_pointers

! Output:
! p => a(2:8:2)      : 2 4 6 8
! bounds of p        : 1 4
! a after p = 0      : 1 0 3 0 5 0 7 0 9 10
! p(0:) => a bounds  : 0 9
! p(0) is a(1)       : 1
! shape of remapped m: 3 4
! m(2, :)            : 2 5 8 11
! v after row = -row : 1 -2 3 4 -5 6 7 -8 9 10 -11 12
