! -----------------------------------------------------------------------------
! 05_block.f90 - the BLOCK construct (F2008)
!
! Run:  scripts/run.sh 06-control-flow/05_block.f90
! -----------------------------------------------------------------------------
!
!   [name:] block
!     [use / import / declarations]
!     executable statements
!   end block [name]
!
! A BLOCK opens a new scope in the middle of executable code:
!   * declare variables right where they are needed;
!   * a local name HIDES a host entity with the same name inside the block;
!   * local allocatables are deallocated automatically at END BLOCK;
!   * local variables without SAVE are undefined on each entry;
!   * a USE statement inside a block limits the module's names to the block;
!   * IMPLICIT statements are not allowed inside (the host rule applies);
!   * an initialiser in a declaration still implies SAVE, exactly as in a
!     procedure.

program block_construct
  implicit none (type, external)

  integer :: i
  real :: x

  i = 10
  x = 1.5

  print '(a, i0)', 'before block: i = ', i

  block
    integer :: i                       ! hides the outer i
    real, allocatable :: tmp(:)

    i = 99
    allocate (tmp(5))
    tmp = x                            ! the outer x is visible
    print '(a, i0, a, f0.1)', 'inside block: i = ', i, ', sum(tmp) = ', sum(tmp)
  end block                            ! tmp is deallocated here

  print '(a, i0)', 'after block:  i = ', i

  ! A typical use: a temporary needed only for one step.
  do i = 1, 3
    block
      use, intrinsic :: iso_fortran_env, only: real64
      real(real64) :: squared
      squared = real(i, real64)**2
      print '(a, i0, a, f0.1)', 'i = ', i, ', i**2 = ', squared
    end block
  end do

end program block_construct

! Output:
! before block: i = 10
! inside block: i = 99, sum(tmp) = 7.5
! after block:  i = 10
! i = 1, i**2 = 1.0
! i = 2, i**2 = 4.0
! i = 3, i**2 = 9.0
