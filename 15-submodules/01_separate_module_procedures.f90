! -----------------------------------------------------------------------------
! 01_separate_module_procedures.f90 - interface in the module, body elsewhere
!
! Run:  scripts/run.sh 15-submodules/01_separate_module_procedures.f90
! -----------------------------------------------------------------------------
!
! A module may declare a procedure's INTERFACE with the MODULE prefix and
! leave its implementation to a SUBMODULE (F2008):
!
!   module shapes                         submodule (shapes) shapes_impl
!     interface                           contains
!       module function area(r)             module procedure area   ! form 1
!         real, intent(in) :: r                area = ...
!         real :: area                      end procedure area
!       end function area
!     end interface                         module function perimeter(r) ! form 2
!   end module shapes                         real, intent(in) :: r      ! repeats
!                                             real :: perimeter          ! the
!                                             ...                       ! interface
!                                           end function perimeter
!
! Form 1, `module procedure name`, takes the interface from the module and
! cannot drift from it. Form 2 repeats the full header, which the compiler
! checks against the interface - more typing, but readable on its own.
!
! Users of the module only see the interface; the submodule is private.
! In one file the module must come before its submodules.

module shapes
  implicit none (type, external)
  private
  public :: area, perimeter

  interface
    module pure real function area(r)
      real, intent(in) :: r
    end function area

    module pure real function perimeter(r)
      real, intent(in) :: r
    end function perimeter
  end interface

end module shapes

submodule (shapes) shapes_impl
  implicit none (type, external)
  real, parameter :: pi = acos(-1.0)     ! private to the submodule
contains

  module procedure area                  ! form 1: no header repeated
    area = pi * r**2
  end procedure area

  module pure real function perimeter(r) ! form 2: header repeated, checked
    real, intent(in) :: r
    perimeter = 2 * pi * r
  end function perimeter

end submodule shapes_impl

program separate_module_procedures
  use shapes, only: area, perimeter
  implicit none (type, external)

  print '(a, f0.4)', 'area(3)      = ', area(3.0)
  print '(a, f0.4)', 'perimeter(3) = ', perimeter(3.0)

end program separate_module_procedures

! Output:
! area(3)      = 28.2743
! perimeter(3) = 18.8496
