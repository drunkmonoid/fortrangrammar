! -----------------------------------------------------------------------------
! 03_sequence_association.f90 - an array element passed to an assumed-size dummy
!
! Run:  scripts/run.sh 36-conformance/03_sequence_association.f90
! -----------------------------------------------------------------------------
!
!   call show(a(1), 4)
!
! An assumed-size dummy b(*) has no shape of its own. Passing the first
! element of a contiguous array associates b with the sequence a(1),
! a(2), ... That is standard, and it is why old libraries take a first
! element plus a length. The caller is responsible for the length.
!
!   call show(a(1:4:2), 2)
!
! A strided section is not a contiguous sequence. Passing it to b(*) is
! not conforming. gfortran 15 copies the section into a temporary, prints
! a runtime warning on stderr ("An array temporary was created"), and the
! values happen to be right. Do not rely on the copy. Pass an
! assumed-shape dummy (chapter 08) if the argument may be a section.

program sequence_association
  implicit none (type, external)

  interface
    subroutine show(b, n)
      integer, intent(in) :: n
      integer, intent(in) :: b(*)
    end subroutine show
  end interface

  integer :: a(4) = [1, 2, 3, 4]

  call show(a(1), 4)
  call show(a(1:4:2), 2)

end program sequence_association

subroutine show(b, n)
  implicit none (type, external)
  integer, intent(in) :: n
  integer, intent(in) :: b(*)
  integer :: i

  print '(*(1x, i0))', (b(i), i = 1, n)
end subroutine show

! Output:
!  1 2 3 4
!  1 3
