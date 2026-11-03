! -----------------------------------------------------------------------------
! 10_data_statement.f90 - the DATA statement
!
! Run:  scripts/run.sh 04-declarations/10_data_statement.f90
! -----------------------------------------------------------------------------
!
!   data object-list / value-list / [, object-list / value-list /]...
!
! DATA gives initial values to variables, like an initialiser in the
! declaration, and also implies SAVE. Its strengths:
!   * repeat counts:      data a / 5*0.0 /
!   * implied-do lists:   data (b(i), i = 1, 3) / 1, 2, 3 /
!   * individual elements and implied-do subsets of arrays
!   * a whole array is filled in array element order (column-major)
!   * BOZ constants are allowed as values
!
! DATA is still standard, but placing it among executable statements is
! obsolescent. Modern code uses declaration initialisers with array
! constructors instead; DATA is shown so you can read existing code.

program data_statement
  implicit none (type, external)

  integer :: i
  real :: zeros(5)
  integer :: squares(4)
  integer :: mask
  character(len=6) :: word
  integer :: matrix(2, 3)

  data zeros / 5 * 0.0 /
  data (squares(i), i = 1, 4) / 1, 4, 9, 16 /
  data mask / z'ff' /
  data word / 'abcdef' /
  ! Column-major: matrix(1,1), matrix(2,1), matrix(1,2), matrix(2,2), ...
  data matrix / 11, 21, 12, 22, 13, 23 /

  ! The modern equivalents:
  !   real    :: zeros(5)    = 0.0
  !   integer :: squares(4)  = [(i * i, i = 1, 4)]
  !   integer :: mask        = int(z'ff')

  print '(a, *(1x, f0.1))', 'zeros:', zeros
  print '(a, *(1x, i0))', 'squares:', squares
  print '(a, i0)', 'mask: ', mask
  print '(2a)', 'word: ', word
  print '(a, 3(1x, i0))', 'matrix row 1:', matrix(1, :)
  print '(a, 3(1x, i0))', 'matrix row 2:', matrix(2, :)

end program data_statement

! Output:
! zeros: .0 .0 .0 .0 .0
! squares: 1 4 9 16
! mask: 255
! word: abcdef
! matrix row 1: 11 12 13
! matrix row 2: 21 22 23
