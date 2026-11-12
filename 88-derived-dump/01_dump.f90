! -----------------------------------------------------------------------------
! 01_dump.f90 - Format a nested derived type into a `name = value` text buffer
!
! Run:  scripts/run.sh 88-derived-dump/01_dump.f90
! -----------------------------------------------------------------------------
!
! Fortran has no built-in runtime reflection over derived-type components.
! Writing a dedicated `dump` subroutine (or defined derived-type I/O,
! chapter 20) emits structured `name = value` lines into an internal
! character buffer.
!
! Following phase 40's floating-point rule, only exact binary dyadic reals
! such as 0.5 or 1.0 are formatted directly with `f0.1`; non-dyadic values
! would otherwise report only a logical flag (`real component defined`).

module dump_m
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  private
  public :: meta_t, item_t, dump_item

  type :: meta_t
    integer :: tag = 0
    integer :: version = 1
  end type meta_t

  type :: item_t
    integer :: id = 0
    real(real64) :: weight = 0.0_real64
    type(meta_t) :: meta
  end type item_t

contains

  pure function is_exact_dyadic(x) result(ok)
    real(real64), intent(in) :: x
    logical :: ok
    ok = (x == 0.5_real64 .or. x == 1.0_real64 .or. x == 0.0_real64)
  end function is_exact_dyadic

  subroutine dump_item(item, buf)
    type(item_t), intent(in) :: item
    character(len=:), allocatable, intent(out) :: buf
    character(len=64) :: line1, line2, line3, line4
    character(len=1) :: nl

    nl = new_line('a')

    write(line1, '(a,i0)') 'id = ', item%id
    if (is_exact_dyadic(item%weight)) then
      write(line2, '(a,f0.1)') 'weight = ', item%weight
    else
      write(line2, '(a,l1)') 'real component defined = ', .true.
    end if
    write(line3, '(a,i0)') 'meta.tag = ', item%meta%tag
    write(line4, '(a,i0)') 'meta.version = ', item%meta%version

    buf = trim(line1) // nl // trim(line2) // nl // trim(line3) // nl // trim(line4)
  end subroutine dump_item

end module dump_m

program dump_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use dump_m, only: meta_t, item_t, dump_item
  implicit none (type, external)

  type(item_t) :: item
  character(len=:), allocatable :: buffer

  item = item_t(id=42, weight=1.0_real64, meta=meta_t(tag=7, version=3))
  call dump_item(item, buffer)
  write(output_unit, '(a)') buffer

end program dump_demo

! Output:
! id = 42
! weight = 1.0
! meta.tag = 7
! meta.version = 3
