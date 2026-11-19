! @build fail
! @flags -std=f95
! -----------------------------------------------------------------------------
! 02_allocatable_component.f90 - an allocatable component is Fortran 2003
!
! Run:  scripts/run.sh 115-fortran-90-95/02_allocatable_component.f90
! -----------------------------------------------------------------------------
!
! -std=f95 rejects the component. A local allocatable array, as in
! 01_features.f90, is allowed.

program allocatable_component
  implicit none

  type :: box
    integer, allocatable :: item(:)
  end type box

  type(box) :: storage

  allocate (storage%item(1))
  storage%item(1) = 1
  print '(i0)', storage%item(1)

end program allocatable_component
