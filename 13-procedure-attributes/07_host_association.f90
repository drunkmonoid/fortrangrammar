! -----------------------------------------------------------------------------
! 07_host_association.f90 - scoping units and name visibility
!
! Run:  scripts/run.sh 13-procedure-attributes/07_host_association.f90
! -----------------------------------------------------------------------------
!
! A SCOPING UNIT is a program unit, subprogram, derived-type definition,
! interface body or BLOCK construct. Names become visible in a scope by:
!
!   * declaration in that scope             (local)
!   * USE association                       (from a module)
!   * HOST association                      (from the enclosing scope:
!                                            internal/module procedures,
!                                            BLOCK, derived types)
!   * argument association                  (dummy <-> actual)
!
! Rules:
!   * A local declaration HIDES a host name of the same name, for the whole
!     scope - even before the declaration, it never refers to the host.
!   * Implicitly typing a name inside an internal procedure that exists in
!     the host makes it the HOST's variable - one more reason for
!     implicit none.
!   * Interface bodies do NOT get host association by default; use IMPORT
!     (08_import.f90).

module counters
  implicit none (type, external)
  integer :: module_count = 0           ! visible to every module procedure
contains

  subroutine tick()
    module_count = module_count + 1     ! host association with the module
  end subroutine tick

end module counters

program host_association
  use counters, only: tick, module_count
  implicit none (type, external)

  integer :: x, y

  x = 1
  y = 2
  call tick(); call tick()
  print '(a, i0)', 'module_count = ', module_count

  call outer_sees_host()
  call local_hides_host()
  print '(a, i0, a, i0)', 'after calls: x = ', x, ', y = ', y

  block
    integer :: x                        ! block-local x hides program's x
    x = 100
    print '(a, i0, a, i0)', 'in block: x = ', x, ', y (host) = ', y
  end block

contains

  subroutine outer_sees_host()
    x = x + 10                          ! modifies the program's x
  end subroutine outer_sees_host

  subroutine local_hides_host()
    integer :: y                        ! local y, the program's y is hidden
    y = -1
    print '(a, i0)', 'local y = ', y
  end subroutine local_hides_host

end program host_association

! Output:
! module_count = 2
! local y = -1
! after calls: x = 11, y = 2
! in block: x = 100, y (host) = 2
