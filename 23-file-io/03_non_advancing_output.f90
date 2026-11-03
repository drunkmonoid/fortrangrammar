! -----------------------------------------------------------------------------
! 03_non_advancing_output.f90 - writing part of a record at a time
!
! Run:  scripts/run.sh 23-file-io/03_non_advancing_output.f90
! -----------------------------------------------------------------------------
!
!   write (u, '(a)', advance='no') 'partial '
!
! Non-advancing output leaves the record open, so the next WRITE continues
! on the same line. Uses: prompts, progress indicators, building a line in
! a loop. Requires an explicit format (not *), and is not allowed for
! internal files.
!
! A record that is still open is completed by the next advancing WRITE, by
! CLOSE, or at program end.

program non_advancing_output
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  integer :: i

  write (output_unit, '(a)', advance='no') 'progress:'
  do i = 1, 5
    write (output_unit, '(1x, i0, "%")', advance='no') i * 20
  end do
  write (output_unit, '(a)') ' done'

  ! Building a row of a table in a loop.
  do i = 1, 3
    block
      integer :: j
      do j = 1, 4
        write (output_unit, '(i4)', advance='no') i * j
      end do
      write (output_unit, '(a)') ''              ! end the record
    end block
  end do

end program non_advancing_output

! Output:
! progress: 20% 40% 60% 80% 100% done
!    1   2   3   4
!    2   4   6   8
!    3   6   9  12
