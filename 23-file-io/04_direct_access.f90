! -----------------------------------------------------------------------------
! 04_direct_access.f90 - fixed-length records read in any order
!
! Run:  scripts/run.sh 23-file-io/04_direct_access.f90
! -----------------------------------------------------------------------------
!
!   open (newunit=u, access='direct', recl=n, form='unformatted', ...)
!   write (u, rec=k) items          read (u, rec=k) items
!
! * Every record has the same length RECL. For unformatted files RECL is in
!   processor-dependent "file storage units" - never guess it: ask with
!   inquire(iolength=n) items.
! * Records can be written and read in any order (like an array on disk).
! * Reading a record that was never written is an error.
! * Formatted direct access also exists (recl in characters).

program direct_access
  implicit none (type, external)

  type :: entry
    integer :: id
    real :: score
  end type entry

  type(entry) :: e
  integer :: u, reclen, k, ios

  inquire (iolength=reclen) e%id, e%score
  print '(a, i0)', 'record length from inquire(iolength=): ', reclen

  open (newunit=u, status='scratch', access='direct', form='unformatted', recl=reclen)

  do k = 5, 1, -1                        ! write in reverse order
    write (u, rec=k) k * 100, k * 1.5
  end do

  do k = 1, 5, 2                         ! read only odd records
    read (u, rec=k) e%id, e%score
    print '(a, i0, a, i0, a, f0.1)', 'rec ', k, ': id=', e%id, ' score=', e%score
  end do

  read (u, rec=99, iostat=ios) e%id, e%score
  print '(a, i0)', 'reading a nonexistent record: iostat = ', ios
  close (u)

end program direct_access

! Output:
! record length from inquire(iolength=): 8
! rec 1: id=100 score=1.5
! rec 3: id=300 score=4.5
! rec 5: id=500 score=7.5
! reading a nonexistent record: iostat = 5002
