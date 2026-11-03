! -----------------------------------------------------------------------------
! 02_array_constructors.f90 - building rank-1 arrays inline
!
! Run:  scripts/run.sh 07-arrays-fundamentals/02_array_constructors.f90
! -----------------------------------------------------------------------------
!
!   [ v1, v2, ... ]               modern brackets (F2003)
!   (/ v1, v2, ... /)             older delimiters, same meaning
!   [ type-spec :: values ]       explicit type; converts each value
!   [ (expr, i = a, b [, s]) ]    implied-DO
!   [ integer :: ]                empty (zero-sized) array of a given type
!
! * A constructor always produces a RANK-1 array; use reshape() for more.
! * Items may be scalars or arrays; arrays are flattened in element order.
! * Without a type-spec, every item must have the same type and kind - and
!   for characters the same LENGTH. With a type-spec, items are converted.
! * The implied-DO variable is local to the constructor.

program array_constructors
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  integer :: i, j
  integer, allocatable :: v(:)
  real(dp), allocatable :: x(:)
  character(len=:), allocatable :: words(:)
  integer :: m(2, 3)

  v = [1, 2, 3]
  print '(a, *(1x, i0))', '[1, 2, 3]          :', v

  v = (/ 4, 5, 6 /)
  print '(a, *(1x, i0))', '(/ 4, 5, 6 /)      :', v

  v = [v, 7, v]                       ! arrays are flattened
  print '(a, *(1x, i0))', '[v, 7, v]          :', v

  v = [(i**2, i = 1, 5)]
  print '(a, *(1x, i0))', 'squares            :', v

  v = [(i, i = 10, 1, -3)]
  print '(a, *(1x, i0))', 'countdown          :', v

  v = [((10 * i + j, j = 1, 2), i = 1, 3)]      ! nested implied-DO
  print '(a, *(1x, i0))', 'nested implied-do  :', v

  x = [real(dp) :: 1, 2.5, 3]          ! type-spec converts integers
  print '(a, *(1x, f0.1))', '[real(dp) :: ...]  :', x

  ! Character items of different lengths need a type-spec with a length.
  words = [character(len=6) :: 'a', 'abc', 'abcdef']
  ! The `:` stops the format as soon as the items run out; without it the
  ! literal "[" of the next repetition would still be printed (chapter 22).
  print '(a, *(:, 1x, "[", a, "]"))', 'padded words       :', words

  v = [integer ::]                     ! empty
  print '(a, i0)', 'size of [integer ::] : ', size(v)

  ! Higher rank: build rank-1, then reshape (column-major fill).
  m = reshape([1, 2, 3, 4, 5, 6], [2, 3])
  print '(a, 3(1x, i0))', 'm row 1:', m(1, :)
  print '(a, 3(1x, i0))', 'm row 2:', m(2, :)

end program array_constructors

! Output:
! [1, 2, 3]          : 1 2 3
! (/ 4, 5, 6 /)      : 4 5 6
! [v, 7, v]          : 4 5 6 7 4 5 6
! squares            : 1 4 9 16 25
! countdown          : 10 7 4 1
! nested implied-do  : 11 12 21 22 31 32
! [real(dp) :: ...]  : 1.0 2.5 3.0
! padded words       : [a     ] [abc   ] [abcdef]
! size of [integer ::] : 0
! m row 1: 1 3 5
! m row 2: 2 4 6
