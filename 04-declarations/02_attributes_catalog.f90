! -----------------------------------------------------------------------------
! 02_attributes_catalog.f90 - every attribute, each with a one-line example
!
! Run:  scripts/run.sh 04-declarations/02_attributes_catalog.f90
! -----------------------------------------------------------------------------
!
! Attribute          Meaning                                       Chapter
! -----------------  --------------------------------------------  -------
! parameter          named constant                                 04
! dimension(...)     array (prefer `name(...)` on the entity)       07
! allocatable        storage allocated at run time                  08
! pointer            may point to a target                          21
! target             may be pointed to                              21
! contiguous         array pointer/assumed shape is contiguous      08
! intent(in|out|inout)  dummy argument direction                    11
! optional           dummy argument may be absent                   11
! value              dummy argument passed by value                 11
! save               keeps value between procedure calls            04
! volatile           may change outside the program's control       04
! asynchronous       subject to asynchronous I/O or communication   23
! public / private   module accessibility                           14
! protected          read-only outside its module                   14
! external           names an external procedure                    12
! intrinsic          names an intrinsic procedure                   12
! bind(c)            C interoperability                             27
! codimension[...]   coarray                                        28
!
! Contradictory combinations are errors, e.g. allocatable + pointer,
! parameter + anything except dimension/accessibility, intent + save.

module attribute_demo
  use, intrinsic :: iso_c_binding, only: c_int
  implicit none (type, external)
  private                                   ! default accessibility
  public :: demo, shared_counter, c_visible

  integer, protected :: shared_counter = 0  ! public but read-only to users
  integer(c_int), bind(c, name='c_visible') :: c_visible = 7

contains

  subroutine demo(a, b, scale, flag)
    integer, intent(in) :: a                ! read only
    integer, intent(inout) :: b             ! read and write
    real, intent(in), optional :: scale     ! may be omitted
    logical, value :: flag                  ! a private copy
    integer, save :: calls = 0              ! persists between calls
    real, allocatable :: work(:)
    real, target :: grid(3) = 1.0           ! init implies save as well
    real, pointer, contiguous :: view(:)
    integer, volatile :: hw_register
    real, asynchronous :: buffer(4)

    calls = calls + 1
    shared_counter = shared_counter + 1
    allocate (work(a))
    work = 2.0
    if (present(scale)) work = work * scale
    view => grid(1:2)
    hw_register = 0
    buffer = 0
    flag = .not. flag                       ! changes the local copy only
    b = b + int(sum(work)) + int(sum(view)) + hw_register + int(sum(buffer))
    print '(a, i0, a, i0, a, l1)', 'call ', calls, ': b = ', b, ', local flag = ', flag
  end subroutine demo

end module attribute_demo

program attributes_catalog
  use attribute_demo, only: demo, shared_counter, c_visible
  implicit none (type, external)

  integer :: total
  logical :: flag

  total = 0
  flag = .true.
  call demo(3, total, flag=flag)
  call demo(2, total, 10.0, flag)
  print '(a, l1)', 'caller flag unchanged: ', flag
  print '(a, i0)', 'shared_counter (protected) = ', shared_counter
  print '(a, i0)', 'c_visible (bind(c)) = ', c_visible
  ! shared_counter = 0   <- would not compile: it is protected

end program attributes_catalog

! Output:
! call 1: b = 8, local flag = F
! call 2: b = 50, local flag = F
! caller flag unchanged: T
! shared_counter (protected) = 2
! c_visible (bind(c)) = 7
