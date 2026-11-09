! -----------------------------------------------------------------------------
! 05_forall.f90 - FORALL, and the same assignments as DO CONCURRENT
!
! Run:  scripts/run.sh 33-obsolescent-forms/05_forall.f90
! -----------------------------------------------------------------------------
!
!   forall (i = 1:n) a(i) = i * i
!
! forall is obsolescent since Fortran 2018. The index range and the
! optional mask are evaluated first, then the assignments happen for
! every selected index. That defined order is not "these iterations are
! independent", so a compiler must not treat forall as a parallel loop.
! do concurrent (chapter 28) is the statement that makes that promise.

program forall_demo
  implicit none (type, external)

  integer :: a(4), b(4), i

  forall (i = 1:4) a(i) = i * i

  do concurrent (i = 1:4)
    b(i) = i * i
  end do

  print '(a, 4(1x, i0))', 'forall =', a
  print '(a, 4(1x, i0))', 'concurrent =', b

end program forall_demo

! Output:
! forall = 1 4 9 16
! concurrent = 1 4 9 16
