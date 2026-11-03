! -----------------------------------------------------------------------------
! 04_defined_io_write.f90 - user-defined derived-type output (F2003)
!
! Run:  scripts/run.sh 20-unlimited-polymorphism/04_defined_io_write.f90
! -----------------------------------------------------------------------------
!
!   type :: point
!   contains
!     procedure, private :: write_point
!     generic :: write(formatted) => write_point
!   end type
!
! Once bound, the procedure is called automatically whenever the type
! appears in a formatted WRITE/PRINT:
!   * list-directed (print *, p)       iotype = 'LISTDIRECTED'
!   * namelist                          iotype = 'NAMELIST'
!   * with the DT edit descriptor       iotype = 'DT' // the text after DT,
!       '(dt"compact")'                 e.g. 'DTcompact'
!       '(dt(8,3))'                     v_list = [8, 3]
!
! The procedure's interface is fixed by the standard:
!   subroutine write_point(dtv, unit, iotype, v_list, iostat, iomsg)
!     class(point), intent(in) :: dtv
!     integer, intent(in) :: unit
!     character(*), intent(in) :: iotype
!     integer, intent(in) :: v_list(:)
!     integer, intent(out) :: iostat
!     character(*), intent(inout) :: iomsg
! Inside, write to `unit` with ordinary (child) WRITE statements; they
! continue the parent statement's record - no new lines unless you write
! '/'. Set iostat (0 on success).
! Also available: read(formatted), write(unformatted), read(unformatted),
! and the same via `interface write(formatted)` outside the type.

module points
  implicit none (type, external)
  private
  public :: point

  type :: point
    real :: x = 0, y = 0
  contains
    procedure, private :: write_point
    generic :: write(formatted) => write_point
  end type point

contains

  subroutine write_point(dtv, unit, iotype, v_list, iostat, iomsg)
    class(point), intent(in) :: dtv
    integer, intent(in) :: unit
    character(len=*), intent(in) :: iotype
    integer, intent(in) :: v_list(:)
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
    character(len=32) :: fmt

    if (iotype == 'DTcompact') then
      write (unit, '(g0, ",", g0)', iostat=iostat, iomsg=iomsg) dtv%x, dtv%y
    else if (size(v_list) == 2) then
      write (fmt, '("(""("", f", i0, ".", i0, ", "", "", f", i0, ".", i0, ", "")"")")') &
          v_list(1), v_list(2), v_list(1), v_list(2)
      write (unit, fmt, iostat=iostat, iomsg=iomsg) dtv%x, dtv%y
    else
      write (unit, '("(", f0.2, ", ", f0.2, ")")', iostat=iostat, iomsg=iomsg) dtv%x, dtv%y
    end if
  end subroutine write_point

end module points

program defined_io_write
  use points, only: point
  implicit none (type, external)

  type(point) :: p, path(3)

  p = point(1.5, -2.25)
  path = [point(0, 0), point(1, 1), point(2, 4)]

  print *, 'list-directed: ', p
  print '(a, dt)', 'dt           : ', p
  print '(a, dt"compact")', 'dt"compact"  : ', p
  print '(a, dt(8,3))', 'dt(8,3)      : ', p
  print '(a, *(dt, :, " -> "))', 'array        : ', path

end program defined_io_write

! Output:
!  list-directed:  (1.50, -2.25)
! dt           : (1.50, -2.25)
! dt"compact"  : 1.50000000,-2.25000000
! dt(8,3)      : (   1.500,   -2.250)
! array        : (.00, .00) -> (1.00, 1.00) -> (2.00, 4.00)
