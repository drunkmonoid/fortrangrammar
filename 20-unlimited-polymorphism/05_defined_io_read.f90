! -----------------------------------------------------------------------------
! 05_defined_io_read.f90 - user-defined derived-type input
!
! Run:  scripts/run.sh 20-unlimited-polymorphism/05_defined_io_read.f90
! -----------------------------------------------------------------------------
!
!   generic :: read(formatted) => read_date
!
!   subroutine read_date(dtv, unit, iotype, v_list, iostat, iomsg)
!     class(date), intent(inout) :: dtv       ! inout for read
!     ...same other arguments as write(formatted)
!
! The child READ continues from the current position of the parent
! statement's record. Report malformed input through iostat/iomsg: the
! parent statement then fails with that status, exactly like a built-in
! conversion error.

module dates
  implicit none (type, external)
  private
  public :: date

  type :: date
    integer :: year = 0, month = 0, day = 0
  contains
    procedure, private :: read_date, write_date
    generic :: read(formatted) => read_date
    generic :: write(formatted) => write_date
  end type date

contains

  subroutine read_date(dtv, unit, iotype, v_list, iostat, iomsg)
    class(date), intent(inout) :: dtv
    integer, intent(in) :: unit
    character(len=*), intent(in) :: iotype
    integer, intent(in) :: v_list(:)
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
    character(len=1) :: dash1, dash2

    ! Expect YYYY-MM-DD
    read (unit, '(i4, a1, i2, a1, i2)', iostat=iostat, iomsg=iomsg) &
        dtv%year, dash1, dtv%month, dash2, dtv%day
    if (iostat /= 0) return
    if (dash1 /= '-' .or. dash2 /= '-' .or. dtv%month < 1 .or. dtv%month > 12) then
      iostat = 1
      iomsg = 'expected a date YYYY-MM-DD'
    end if
  end subroutine read_date

  subroutine write_date(dtv, unit, iotype, v_list, iostat, iomsg)
    class(date), intent(in) :: dtv
    integer, intent(in) :: unit
    character(len=*), intent(in) :: iotype
    integer, intent(in) :: v_list(:)
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
    write (unit, '(i4.4, "-", i2.2, "-", i2.2)', iostat=iostat, iomsg=iomsg) &
        dtv%year, dtv%month, dtv%day
  end subroutine write_date

end module dates

program defined_io_read
  use dates, only: date
  implicit none (type, external)

  type(date) :: d
  character(len=10) :: inputs(3) = ['2026-11-03', '1969-07-20', '2023/13/01']
  character(len=200) :: msg
  integer :: i, ios

  do i = 1, size(inputs)
    read (inputs(i), '(dt)', iostat=ios, iomsg=msg) d
    if (ios == 0) then
      print '(a, a, a, dt)', 'parsed "', inputs(i), '" -> ', d
    else
      print '(5a)', 'failed "', inputs(i), '": ', trim(msg)
    end if
  end do

end program defined_io_read

! Output:
! parsed "2026-11-03" -> 2026-11-03
! parsed "1969-07-20" -> 1969-07-20
! failed "2023/13/01": expected a date YYYY-MM-DD
