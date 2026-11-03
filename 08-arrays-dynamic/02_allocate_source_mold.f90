! -----------------------------------------------------------------------------
! 02_allocate_source_mold.f90 - ALLOCATE with SOURCE= and MOLD=
!
! Run:  scripts/run.sh 08-arrays-dynamic/02_allocate_source_mold.f90
! -----------------------------------------------------------------------------
!
!   allocate (b, source=a)       b gets the shape, bounds AND values of a
!   allocate (b, mold=a)         b gets the shape and bounds, values undefined
!   allocate (b(10), source=0)   explicit shape + scalar source: fill value
!
! * With SOURCE/MOLD, the allocate-object may omit its shape: it is taken
!   from the source (F2008).
! * SOURCE and MOLD also carry the DYNAMIC TYPE for polymorphic objects
!   (chapter 18/20) - that is where they matter most.
! * Several objects may be allocated from one source:
!     allocate (x, y, source=a)

program allocate_source_mold
  implicit none (type, external)

  integer :: a(0:3)
  integer, allocatable :: copy(:), shaped(:), filled(:), x(:), y(:)
  integer :: i

  a = [(10 * i, i = 0, 3)]

  allocate (copy, source=a)
  print '(a, *(1x, i0))', 'source= copy  :', copy
  print '(a, i0, 1x, i0)', 'copy bounds   : ', lbound(copy), ubound(copy)

  allocate (shaped, mold=a)
  shaped = -1                        ! values were undefined until now
  print '(a, i0, 1x, i0)', 'mold= bounds  : ', lbound(shaped), ubound(shaped)

  allocate (filled(5), source=42)
  print '(a, *(1x, i0))', 'scalar source :', filled

  allocate (x, y, source=a(1:2))
  print '(a, *(1x, i0))', 'x and y       :', x, y

end program allocate_source_mold

! Output:
! source= copy  : 0 10 20 30
! copy bounds   : 0 3
! mold= bounds  : 0 3
! scalar source : 42 42 42 42 42
! x and y       : 10 20 10 20
