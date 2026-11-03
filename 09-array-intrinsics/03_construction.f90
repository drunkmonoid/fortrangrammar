! -----------------------------------------------------------------------------
! 03_construction.f90 - reshape, spread, pack, unpack, merge
!
! Run:  scripts/run.sh 09-array-intrinsics/03_construction.f90
! -----------------------------------------------------------------------------
!
!   reshape(source, shape [, pad] [, order])
!       Fill a new shape from source in element order. PAD supplies extra
!       elements (repeated) if source is too short; ORDER permutes the
!       dimension fill order.
!   spread(source, dim, ncopies)
!       Add a dimension by replicating source NCOPIES times along DIM.
!   pack(array, mask [, vector])
!       Rank-1 array of the elements where mask is true. With VECTOR the
!       result has size(vector), the tail taken from vector.
!   unpack(vector, mask, field)
!       Inverse of pack: scatter vector into the true positions of mask;
!       FIELD (scalar or array) fills the false positions.
!   merge(tsource, fsource, mask)
!       Elemental choice: tsource where mask, fsource elsewhere.

program construction
  implicit none (type, external)

  integer :: v(6) = [1, 2, 3, 4, 5, 6]
  integer :: m(2, 3), big(3, 3), s(3, 2)
  logical :: mask(6)
  integer :: i

  m = reshape(v, [2, 3])
  print '(a)', 'reshape(v, [2,3]):'
  do i = 1, 2
    print '(3i4)', m(i, :)
  end do

  big = reshape([1, 2], [3, 3], pad=[0])
  print '(a, *(1x, i0))', 'reshape with pad  :', big

  s = spread([10, 20, 30], dim=2, ncopies=2)
  print '(a)', 'spread([10,20,30], dim=2, ncopies=2):'
  do i = 1, 3
    print '(2i4)', s(i, :)
  end do
  print '(a, *(1x, i0))', 'spread along dim=1 shape:', shape(spread([10, 20, 30], 1, 4))

  mask = mod(v, 2) == 0
  print '(a, *(1x, i0))', 'pack(v, even)     :', pack(v, mask)
  print '(a, *(1x, i0))', 'pack with vector  :', pack(v, mask, vector=[-1, -1, -1, -1, -1])
  print '(a, *(1x, i0))', 'pack(m, m > 2)    :', pack(m, m > 2)

  print '(a, *(1x, i0))', 'unpack([7,8,9])   :', unpack([7, 8, 9], mask, field=0)
  print '(a, *(1x, i0))', 'merge(v, -v, mask):', merge(v, -v, mask)

  ! Outer product with spread: a(i) * b(j)
  print '(a, *(1x, i0))', 'outer product     :', &
      spread([1, 2, 3], 2, 2) * spread([10, 100], 1, 3)

end program construction

! Output:
! reshape(v, [2,3]):
!    1   3   5
!    2   4   6
! reshape with pad  : 1 2 0 0 0 0 0 0 0
! spread([10,20,30], dim=2, ncopies=2):
!   10  10
!   20  20
!   30  30
! spread along dim=1 shape: 4 3
! pack(v, even)     : 2 4 6
! pack with vector  : 2 4 6 -1 -1
! pack(m, m > 2)    : 3 4 5 6
! unpack([7,8,9])   : 0 7 0 8 0 9
! merge(v, -v, mask): -1 2 -3 4 -5 6
! outer product     : 10 20 30 100 200 300
