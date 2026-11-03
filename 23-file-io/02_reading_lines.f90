! -----------------------------------------------------------------------------
! 02_reading_lines.f90 - reading a text file line by line, any line length
!
! Run:  scripts/run.sh 23-file-io/02_reading_lines.f90
! -----------------------------------------------------------------------------
!
! Reading with '(a)' into a fixed-length variable truncates long lines.
! The robust pattern reads a line in chunks with NON-ADVANCING input:
!
!   read (u, '(a)', advance='no', size=n, iostat=ios) chunk
!
!   * size=n  receives how many characters were actually read;
!   * ios == iostat_eor  -> end of the line reached (the chunk is partial);
!   * ios == iostat_end  -> end of the file;
!   * ios == 0           -> the chunk was full, the line continues.
!
! iostat_end and iostat_eor come from iso_fortran_env; is_iostat_end(ios)
! and is_iostat_eor(ios) are equivalent intrinsic tests.

module text_io
  use, intrinsic :: iso_fortran_env, only: iostat_eor
  implicit none (type, external)
  private
  public :: read_line

contains

  ! Read one whole line into a deferred-length string.
  subroutine read_line(unit, line, iostat)
    integer, intent(in) :: unit
    character(len=:), allocatable, intent(out) :: line
    integer, intent(out) :: iostat
    character(len=16) :: chunk                 ! tiny on purpose
    integer :: n

    line = ''
    do
      read (unit, '(a)', advance='no', size=n, iostat=iostat) chunk
      line = line // chunk(:n)
      if (iostat == iostat_eor) then
        iostat = 0                             ! a complete line
        return
      end if
      if (iostat /= 0) return                  ! end of file or error
    end do
  end subroutine read_line

end module text_io

program reading_lines
  use, intrinsic :: iso_fortran_env, only: iostat_end
  use text_io, only: read_line
  implicit none (type, external)

  integer :: u, ios, count
  character(len=:), allocatable :: line

  open (newunit=u, status='scratch')
  write (u, '(a)') 'short'
  write (u, '(a)') 'a considerably longer line that exceeds the sixteen-character chunk'
  write (u, '(a)') ''
  write (u, '(a)') 'last'
  rewind (u)

  count = 0
  do
    call read_line(u, line, ios)
    if (ios == iostat_end) exit
    if (ios /= 0) error stop 'read error'
    count = count + 1
    print '(i0, a, i0, 3a)', count, ' (len ', len(line), '): [', line, ']'
  end do
  close (u)

end program reading_lines

! Output:
! 1 (len 5): [short]
! 2 (len 67): [a considerably longer line that exceeds the sixteen-character chunk]
! 3 (len 0): []
! 4 (len 4): [last]
