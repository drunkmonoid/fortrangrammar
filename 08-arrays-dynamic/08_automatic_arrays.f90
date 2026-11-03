! -----------------------------------------------------------------------------
! 08_automatic_arrays.f90 - automatic arrays and objects
!
! Run:  scripts/run.sh 08-arrays-dynamic/08_automatic_arrays.f90
! -----------------------------------------------------------------------------
!
! An AUTOMATIC array is a local, non-allocatable array whose bounds depend on
! dummy arguments or other run-time values:
!
!   subroutine s(x)
!     real, intent(in) :: x(:)
!     real :: work(size(x))           ! sized on entry, freed on return
!     character(len=len(name)) :: buf ! automatic character length
!
! * Created on every entry, destroyed on return; it cannot be SAVEd or
!   initialised in its declaration.
! * Compilers usually put them on the STACK: very fast, but a large one can
!   overflow the stack (segfault). gfortran: -fstack-arrays puts more on
!   the stack, -fmax-stack-var-size controls the threshold; `ulimit -s`
!   raises the limit.
! * For big or long-lived work arrays, prefer a local ALLOCATABLE, which
!   lives on the heap and is also freed automatically.

module automatic
  implicit none (type, external)
contains

  subroutine smooth(x)
    real, intent(inout) :: x(:)
    real :: work(size(x))                 ! automatic array
    integer :: i, n

    n = size(x)
    work = x
    do i = 2, n - 1
      x(i) = (work(i - 1) + work(i) + work(i + 1)) / 3
    end do
  end subroutine smooth

  function banner(text) result(line)
    character(len=*), intent(in) :: text
    character(len=len(text) + 4) :: line  ! automatic-length result
    character(len=len(text)) :: upper     ! automatic-length local
    integer :: i, code

    do i = 1, len(text)
      code = iachar(text(i:i))
      if (code >= iachar('a') .and. code <= iachar('z')) code = code - 32
      upper(i:i) = achar(code)
    end do
    line = '* ' // upper // ' *'
  end function banner

end module automatic

program automatic_arrays
  use automatic, only: smooth, banner
  implicit none (type, external)

  real :: signal(7) = [0.0, 0.0, 9.0, 0.0, 0.0, 3.0, 0.0]

  call smooth(signal)
  print '(a, *(1x, f0.1))', 'smoothed:', signal
  print '(a)', banner('automatic objects')

end program automatic_arrays

! Output:
! smoothed: .0 3.0 3.0 3.0 1.0 1.0 .0
! * AUTOMATIC OBJECTS *
