! -----------------------------------------------------------------------------
! 06_factory_and_strategy.f90 - common OOP patterns in Fortran
!
! Run:  scripts/run.sh 19-oop-advanced/06_factory_and_strategy.f90
! -----------------------------------------------------------------------------
!
! FACTORY: a function returning class(base), allocatable chooses the dynamic
! type at run time (from input, configuration...). Callers depend only on
! the abstract base.
!
! STRATEGY: an object holds a polymorphic component implementing an
! abstract interface; swapping the component changes behaviour without
! touching the holder.
!
! Both rely on polymorphic allocatable results and components with
! automatic memory management - no pointers needed.

module integrators
  implicit none (type, external)
  private
  public :: integrator, make_integrator, simulation

  type, abstract :: integrator
  contains
    procedure(step_iface), deferred :: step
    procedure(name_iface), deferred :: name
  end type integrator

  abstract interface
    ! advance y' = -y by dt
    real function step_iface(self, y, dt)
      import :: integrator
      class(integrator), intent(in) :: self
      real, intent(in) :: y, dt
    end function step_iface

    function name_iface(self) result(n)
      import :: integrator
      class(integrator), intent(in) :: self
      character(len=:), allocatable :: n
    end function name_iface
  end interface

  type, extends(integrator) :: euler
  contains
    procedure :: step => euler_step
    procedure :: name => euler_name
  end type euler

  type, extends(integrator) :: rk2
  contains
    procedure :: step => rk2_step
    procedure :: name => rk2_name
  end type rk2

  type :: simulation                       ! strategy holder
    class(integrator), allocatable :: method
    real :: y = 1
  contains
    procedure :: run
  end type simulation

contains

  function make_integrator(kind_name) result(m)   ! factory
    character(len=*), intent(in) :: kind_name
    class(integrator), allocatable :: m
    select case (kind_name)
    case ('euler')
      m = euler()
    case ('rk2')
      m = rk2()
    case default
      error stop 'unknown integrator: ' // kind_name
    end select
  end function make_integrator

  real function euler_step(self, y, dt)
    class(euler), intent(in) :: self
    real, intent(in) :: y, dt
    euler_step = y - dt * y
  end function euler_step

  function euler_name(self) result(n)
    class(euler), intent(in) :: self
    character(len=:), allocatable :: n
    n = 'euler'
  end function euler_name

  real function rk2_step(self, y, dt)
    class(rk2), intent(in) :: self
    real, intent(in) :: y, dt
    real :: mid
    mid = y - 0.5 * dt * y
    rk2_step = y - dt * mid
  end function rk2_step

  function rk2_name(self) result(n)
    class(rk2), intent(in) :: self
    character(len=:), allocatable :: n
    n = 'rk2'
  end function rk2_name

  subroutine run(self, steps, dt)
    class(simulation), intent(inout) :: self
    integer, intent(in) :: steps
    real, intent(in) :: dt
    integer :: i
    do i = 1, steps
      self%y = self%method%step(self%y, dt)
    end do
  end subroutine run

end module integrators

program factory_and_strategy
  use integrators, only: make_integrator, simulation
  implicit none (type, external)

  type(simulation) :: sim
  character(len=5) :: choices(2) = ['euler', 'rk2  ']
  integer :: i

  do i = 1, size(choices)
    sim = simulation(make_integrator(trim(choices(i))), 1.0)
    call sim%run(steps=10, dt=0.1)
    print '(a5, a, f0.6, a, f0.6)', sim%method%name(), ': y(1) = ', sim%y, &
        '   exact: ', exp(-1.0)
  end do

end program factory_and_strategy

! Output:
! euler: y(1) = .348678   exact: .367879
!   rk2: y(1) = .368541   exact: .367879
