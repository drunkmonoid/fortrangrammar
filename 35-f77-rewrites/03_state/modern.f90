! 03_state/modern.f90 - the same counter, as a module variable
!
! Built by 03_state/build.sh.

module counter
  implicit none (type, external)
  private
  public :: step, fetch
  integer, save :: n = 0
contains
  subroutine step()
    n = n + 1
  end subroutine step

  subroutine fetch(k)
    integer, intent(out) :: k
    k = n
  end subroutine fetch
end module counter

program state_modern
  use counter, only: step, fetch
  implicit none (type, external)

  integer :: n

  call step
  call step
  call step
  call fetch(n)
  print '(a, i0)', 'count = ', n

end program state_modern
