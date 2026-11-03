! -----------------------------------------------------------------------------
! 02_len_parameters.f90 - LEN type parameters
!
! Run:  scripts/run.sh 17-parameterized-types/02_len_parameters.f90
! -----------------------------------------------------------------------------
!
!   type :: matrix(rows, cols)
!     integer, len :: rows, cols          ! LEN parameters: run-time values
!     real :: a(rows, cols)               ! component sizes depend on them
!   end type matrix
!
!   type(matrix(2, 3)) :: m               ! constant or ...
!   type(matrix(n, n)) :: w               ! ... any specification expression
!
! * Len parameters size array components and character lengths. Unlike
!   allocatable components, the storage is part of the object and the sizes
!   are fixed for its lifetime.
! * Values may be run-time expressions (e.g. dummy arguments), giving
!   automatic objects whose layout is known on entry.
! * Inquiry: m%rows, m%cols.

module pdt_len
  implicit none (type, external)

  type :: matrix(rows, cols)
    integer, len :: rows, cols
    real :: a(rows, cols) = 0
  end type matrix

  type :: labelled(n)
    integer, len :: n = 8
    character(len=n) :: text = ''
  end type labelled

end module pdt_len

program len_parameters
  use pdt_len, only: matrix, labelled
  implicit none (type, external)

  type(matrix(2, 3)) :: m
  type(labelled) :: short
  type(labelled(20)) :: long
  integer :: i

  print '(a, i0, a, i0)', 'm is ', m%rows, ' x ', m%cols
  m%a = reshape([(real(i), i = 1, 6)], [2, 3])
  print '(a, *(1x, f0.0))', 'm%a(2, :) =', m%a(2, :)

  short%text = 'truncated text'
  long%text = 'fits comfortably'
  print '(a, i0, 3a)', 'short%n = ', short%n, ' -> "', short%text, '"'
  print '(a, i0, 3a)', 'long%n  = ', long%n, ' -> "', long%text, '"'

  call workspace(4)

contains

  subroutine workspace(n)
    integer, intent(in) :: n
    type(matrix(n, n)) :: w               ! automatic PDT object
    w%a = 1
    print '(a, i0, a, f0.0)', 'workspace ', w%rows, ': trace = ', sum([(w%a(i, i), i = 1, n)])
  end subroutine workspace

end program len_parameters

! Output:
! m is 2 x 3
! m%a(2, :) = 2. 4. 6.
! short%n = 8 -> "truncate"
! long%n  = 20 -> "fits comfortably    "
! workspace 4: trace = 4.
