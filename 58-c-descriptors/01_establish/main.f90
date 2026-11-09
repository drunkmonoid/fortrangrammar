! -----------------------------------------------------------------------------
! main.f90 - bounds and values of descriptors built in C
!
! Build: scripts/run.sh 58-c-descriptors/01_establish/
! -----------------------------------------------------------------------------

program c_descriptors
  use, intrinsic :: iso_c_binding, only: c_int
  implicit none (type, external)

  interface
    subroutine point_at(p) bind(c, name='point_at')
      import :: c_int
      integer(c_int), pointer, intent(out) :: p(:)
    end subroutine point_at

    subroutine alloc_from(a) bind(c, name='alloc_from')
      import :: c_int
      integer(c_int), allocatable, intent(out) :: a(:)
    end subroutine alloc_from

    subroutine free_it(a) bind(c, name='free_it')
      import :: c_int
      integer(c_int), allocatable, intent(inout) :: a(:)
    end subroutine free_it

    subroutine put_text(s) bind(c, name='put_text')
      character(len=:), allocatable, intent(out) :: s
    end subroutine put_text

    integer(c_int) function c_rank(a) bind(c, name='c_rank')
      import :: c_int
      integer(c_int), intent(in) :: a(..)
    end function c_rank
  end interface

  integer(c_int), pointer :: p(:)
  integer(c_int), allocatable :: a(:)
  character(len=:), allocatable :: text
  integer(c_int) :: scalar, matrix(2, 2)

  call point_at(p)
  print '(a, i0, 1x, i0)', 'pointer bounds = ', lbound(p, 1), ubound(p, 1)
  print '(a, *(i0, 1x))', 'pointer = ', p

  call alloc_from(a)
  print '(a, i0, 1x, i0)', 'alloc bounds = ', lbound(a, 1), ubound(a, 1)
  print '(a, *(i0, 1x))', 'alloc = ', a
  call free_it(a)
  print '(a, l1)', 'allocated after free: ', allocated(a)

  call put_text(text)
  print '(a)', 'text = ' // text
  print '(a, i0)', 'text length = ', len(text)

  scalar = 1
  matrix = 7
  print '(a, i0)', 'scalar rank = ', c_rank(scalar)
  print '(a, i0)', 'matrix rank = ', c_rank(matrix)

end program c_descriptors

! Output:
! pointer bounds = 0 2
! pointer = 1 2 3
! alloc bounds = 2 4
! alloc = 10 20 30
! allocated after free: F
! text = ada
! text length = 3
! scalar rank = 0
! matrix rank = 2
