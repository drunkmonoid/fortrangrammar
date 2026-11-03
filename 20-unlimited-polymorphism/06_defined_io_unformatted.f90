! -----------------------------------------------------------------------------
! 06_defined_io_unformatted.f90 - defined UNFORMATTED (binary) I/O
!
! Run:  scripts/run.sh 20-unlimited-polymorphism/06_defined_io_unformatted.f90
! -----------------------------------------------------------------------------
!
!   generic :: write(unformatted) => save
!   generic :: read(unformatted)  => load
!
!   subroutine save(dtv, unit, iostat, iomsg)          ! no iotype / v_list
!
! Intrinsic unformatted I/O of a derived type is not allowed when the type
! has allocatable or pointer components - it would only write descriptors.
! Defined unformatted I/O fixes that: write the length, then the data, and
! read them back in the same order.

module series_mod
  implicit none (type, external)
  private
  public :: series

  type :: series
    character(len=:), allocatable :: name
    real, allocatable :: values(:)
  contains
    procedure, private :: save, load
    generic :: write(unformatted) => save
    generic :: read(unformatted) => load
  end type series

contains

  subroutine save(dtv, unit, iostat, iomsg)
    class(series), intent(in) :: dtv
    integer, intent(in) :: unit
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
    write (unit, iostat=iostat, iomsg=iomsg) len(dtv%name), size(dtv%values), &
        dtv%name, dtv%values
  end subroutine save

  subroutine load(dtv, unit, iostat, iomsg)
    class(series), intent(inout) :: dtv
    integer, intent(in) :: unit
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
    integer :: name_len, n

    read (unit, iostat=iostat, iomsg=iomsg) name_len, n
    if (iostat /= 0) return
    if (allocated(dtv%name)) deallocate (dtv%name)
    allocate (character(len=name_len) :: dtv%name)
    if (allocated(dtv%values)) deallocate (dtv%values)
    allocate (dtv%values(n))
    read (unit, iostat=iostat, iomsg=iomsg) dtv%name, dtv%values
  end subroutine load

end module series_mod

program defined_io_unformatted
  use series_mod, only: series
  implicit none (type, external)

  type(series) :: original, restored
  integer :: unit

  original = series('temperatures', [12.5, 14.0, 9.75])

  open (newunit=unit, status='scratch', form='unformatted', access='stream')
  write (unit) original
  rewind (unit)
  read (unit) restored
  close (unit)

  print '(3a, *(1x, f0.2))', 'restored "', restored%name, '":', restored%values

end program defined_io_unformatted

! Output:
! restored "temperatures": 12.50 14.00 9.75
