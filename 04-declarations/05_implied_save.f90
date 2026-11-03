! -----------------------------------------------------------------------------
! 05_implied_save.f90 - initialisation implies SAVE (the #1 surprise)
!
! Run:  scripts/run.sh 04-declarations/05_implied_save.f90
! -----------------------------------------------------------------------------
!
! In a procedure, a local variable WITH an initialiser in its declaration:
!
!     integer :: calls = 0
!
! is initialised ONCE, at program start, and implicitly has the SAVE
! attribute: it keeps its value between calls. It is not reset on each call.
! (People coming from C expect `int calls = 0;` behaviour; Fortran's
! equivalent of that is a separate assignment statement.)
!
! Other SAVE facts:
!   * Variables in modules and in the main program are saved anyway (F2008).
!   * An explicit `save` with no list saves every local variable.
!   * Saved locals make a procedure non-thread-safe and not pure.
!   * `allocatable, save` arrays stay allocated between calls.

program implied_save
  implicit none (type, external)

  integer :: i

  do i = 1, 3
    call surprising()
  end do
  do i = 1, 3
    call intended()
  end do
  do i = 1, 3
    call explicit_counter()
  end do

contains

  subroutine surprising()
    integer :: calls = 0        ! initialised once; implicitly SAVE
    calls = calls + 1
    print '(a, i0)', 'surprising: calls = ', calls
  end subroutine surprising

  subroutine intended()
    integer :: calls            ! no initialiser: fresh every call
    calls = 0                   ! executable assignment runs every call
    calls = calls + 1
    print '(a, i0)', 'intended:   calls = ', calls
  end subroutine intended

  subroutine explicit_counter()
    integer, save :: calls = 0  ! same as `surprising`, but says so
    real, allocatable, save :: cache(:)
    calls = calls + 1
    if (.not. allocated(cache)) then
      allocate (cache(100))
      print '(a)', 'explicit:   allocating cache (first call only)'
    end if
    print '(a, i0)', 'explicit:   calls = ', calls
  end subroutine explicit_counter

end program implied_save

! Output:
! surprising: calls = 1
! surprising: calls = 2
! surprising: calls = 3
! intended:   calls = 1
! intended:   calls = 1
! intended:   calls = 1
! explicit:   allocating cache (first call only)
! explicit:   calls = 1
! explicit:   calls = 2
! explicit:   calls = 3
