! -----------------------------------------------------------------------------
! 01_stat_errmsg.f90 - STAT= / ERRMSG= and IOSTAT= / IOMSG=
!
! Run:  scripts/run.sh 24-errors-environment/01_stat_errmsg.f90
! -----------------------------------------------------------------------------
!
! Fortran has no exceptions. Statements that can fail at run time take an
! optional status argument; WITHOUT it, a failure terminates the program.
!
!   allocate, deallocate          stat=, errmsg=
!   move_alloc (F2018)            stat=, errmsg=
!   open, close, read, write,
!   inquire, rewind, wait, ...    iostat=, iomsg=
!   execute_command_line          exitstat=, cmdstat=, cmdmsg=
!   get_command[_argument],
!   get_environment_variable      status=
!   sync, lock, event, form team  stat=, errmsg=   (coarrays, chapter 28)
!
! Convention: 0 means success; positive means an error; negative values
! are used for end-of-file / end-of-record conditions (iostat_end,
! iostat_eor). The message variable is only defined when an error occurs,
! so initialise or check the status first.

program stat_errmsg
  use, intrinsic :: iso_fortran_env, only: iostat_end, int64
  implicit none (type, external)

  real, allocatable :: a(:)
  integer :: stat, u, n
  character(len=256) :: msg

  ! An impossible allocation (~4.6e18 bytes) - reported, not fatal.
  ! (Merely LARGE requests may "succeed" on systems that overcommit memory
  ! and fail later when the pages are touched.)
  ! The array must be USED on success: otherwise an optimiser (-O2) may
  ! delete the unused allocation, and then it can never fail.
  allocate (a(huge(1_int64) / 8), stat=stat, errmsg=msg)
  if (stat /= 0) then
    print '(a, i0, 2a)', 'allocate failed: stat=', stat, ', ', trim(msg)
  else
    a(size(a)) = 1.0
    print '(a, f0.1)', 'allocation succeeded?! last element = ', a(size(a))
    deallocate (a)
  end if

  ! A read past the end of a file.
  open (newunit=u, status='scratch')
  write (u, '(i0)') 1
  rewind (u)
  read (u, *) n
  read (u, *, iostat=stat, iomsg=msg) n
  if (stat == iostat_end) print '(2a)', 'second read: end of file - ', trim(msg)
  close (u)

  ! A conversion error.
  block
    character(len=8) :: text
    text = 'x17'
    read (text, *, iostat=stat, iomsg=msg) n
    print '(a, i0, 2a)', 'bad integer: iostat=', stat, ', ', trim(msg)
  end block

end program stat_errmsg

! Output:
! allocate failed: stat=5020, Insufficient virtual memory
! second read: end of file - End of file
! bad integer: iostat=5010, Bad integer for item 1 in list input
