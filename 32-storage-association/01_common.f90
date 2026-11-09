! -----------------------------------------------------------------------------
! 01_common.f90 - named COMMON, the same layout in every unit
!
! Run:  scripts/run.sh 32-storage-association/01_common.f90
! -----------------------------------------------------------------------------
!
!   common /buf/ n, m
!
! Every program unit that names /buf/ receives the same storage, in the
! order written. Blank common (common // n, m, or common n, m) is the same
! idea with a block that has no name. The names in each unit are local:
! only the position matters.
!
! There is no USE. A module variable (chapter 14) is the replacement, and
! the compiler then checks the type.

program common_blocks
  implicit none (type, external)

  interface
    subroutine store(a, b)
      integer, intent(in) :: a, b
    end subroutine store
    subroutine fetch(a, b)
      integer, intent(out) :: a, b
    end subroutine fetch
  end interface

  integer :: n, m

  call store(2, 5)
  call fetch(n, m)
  print '(a, i0, a, i0)', 'n = ', n, ', m = ', m

end program common_blocks

subroutine store(a, b)
  implicit none (type, external)
  integer, intent(in) :: a, b
  integer :: n, m
  common /buf/ n, m

  n = a
  m = b
end subroutine store

subroutine fetch(a, b)
  implicit none (type, external)
  integer, intent(out) :: a, b
  integer :: n, m
  common /buf/ n, m

  a = n
  b = m
end subroutine fetch

! Output:
! n = 2, m = 5
