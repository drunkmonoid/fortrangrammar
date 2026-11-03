! -----------------------------------------------------------------------------
! 04_procedure_pointers.f90 - procedure pointers (F2003)
!
! Run:  scripts/run.sh 12-procedures-interfaces/04_procedure_pointers.f90
! -----------------------------------------------------------------------------
!
!   procedure(iface), pointer :: p => null()
!   p => some_procedure            ! associate
!   y = p(x)                       ! call through the pointer
!   associated(p [, target])       ! test
!   nullify(p) / p => null()       ! disassociate
!
! * The interface (iface) makes calls through p fully type-checked.
! * Procedure pointers can be variables, derived-type COMPONENTS, dummy
!   arguments and function results.
! * A procedure pointer component is NOT a type-bound procedure: it is
!   per-object data that can be changed at run time (strategy pattern).
!   It passes the object as its first argument unless declared NOPASS.

module operations
  implicit none (type, external)

  abstract interface
    integer function binary_op(a, b)
      integer, intent(in) :: a, b
    end function binary_op
  end interface

  type :: calculator
    character(len=8) :: name = ''
    procedure(binary_op), pointer, nopass :: op => null()
  end type calculator

contains

  integer function add(a, b)
    integer, intent(in) :: a, b
    add = a + b
  end function add

  integer function mul(a, b)
    integer, intent(in) :: a, b
    mul = a * b
  end function mul

  integer function power(a, b)
    integer, intent(in) :: a, b
    power = a**b
  end function power

  function choose(symbol) result(p)
    character, intent(in) :: symbol
    procedure(binary_op), pointer :: p
    select case (symbol)
    case ('+'); p => add
    case ('*'); p => mul
    case ('^'); p => power
    case default; p => null()
    end select
  end function choose

end module operations

program procedure_pointers
  use operations, only: binary_op, calculator, add, mul, choose
  implicit none (type, external)

  procedure(binary_op), pointer :: f => null()
  type(calculator) :: calcs(2)
  character :: symbols(4) = ['+', '*', '^', '?']
  integer :: i

  print '(a, l1)', 'associated before: ', associated(f)
  f => add
  print '(a, i0)', 'f => add : f(3, 4) = ', f(3, 4)
  f => mul
  print '(a, i0)', 'f => mul : f(3, 4) = ', f(3, 4)
  print '(a, l1)', 'associated(f, mul): ', associated(f, mul)

  do i = 1, size(symbols)
    f => choose(symbols(i))
    if (associated(f)) then
      print '(3a, i0)', '2 ', symbols(i), ' 5 = ', f(2, 5)
    else
      print '(3a)', 'no operation for "', symbols(i), '"'
    end if
  end do

  ! Pointer components: each object carries its own strategy.
  calcs(1) = calculator('adder', add)
  calcs(2) = calculator('times', mul)
  do i = 1, size(calcs)
    print '(2a, i0)', calcs(i)%name, ': op(6, 7) = ', calcs(i)%op(6, 7)
  end do

end program procedure_pointers

! Output:
! associated before: F
! f => add : f(3, 4) = 7
! f => mul : f(3, 4) = 12
! associated(f, mul): T
! 2 + 5 = 7
! 2 * 5 = 10
! 2 ^ 5 = 32
! no operation for "?"
! adder   : op(6, 7) = 13
! times   : op(6, 7) = 42
