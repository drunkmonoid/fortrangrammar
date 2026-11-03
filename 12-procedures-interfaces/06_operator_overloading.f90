! -----------------------------------------------------------------------------
! 06_operator_overloading.f90 - interface operator(...)
!
! Run:  scripts/run.sh 12-procedures-interfaces/06_operator_overloading.f90
! -----------------------------------------------------------------------------
!
!   interface operator(+)            ! extend an intrinsic operator
!     module procedure add_money
!   end interface
!   interface operator(.pct.)        ! define a new operator
!     module procedure percent
!   end interface
!
! * Specifics are FUNCTIONS with one (unary) or two (binary) arguments,
!   all intent(in).
! * Extending an intrinsic operator: only for argument types where it is
!   not already defined (you cannot redefine integer + integer).
!   The operator keeps its usual precedence.
! * == and .eq. are the same operator: defining one defines both.
! * New operators .name. have fixed precedence: unary highest, binary
!   lowest of all.
! * Operators are generic: several specifics per operator, resolved by TKR.
!   Mixed types (money * integer and integer * money) need one specific
!   each.

module money_mod
  implicit none (type, external)
  private
  public :: money, operator(+), operator(*), operator(==), operator(<), operator(.pct.), show

  type :: money
    integer :: cents = 0
  end type money

  interface operator(+)
    module procedure add_money
  end interface

  interface operator(*)
    module procedure times_int, int_times
  end interface

  interface operator(==)
    module procedure equal_money
  end interface

  interface operator(<)
    module procedure less_money
  end interface

  interface operator(.pct.)
    module procedure percent
  end interface

contains

  elemental type(money) function add_money(a, b)
    type(money), intent(in) :: a, b
    add_money%cents = a%cents + b%cents
  end function add_money

  elemental type(money) function times_int(a, n)
    type(money), intent(in) :: a
    integer, intent(in) :: n
    times_int%cents = a%cents * n
  end function times_int

  elemental type(money) function int_times(n, a)
    integer, intent(in) :: n
    type(money), intent(in) :: a
    int_times%cents = a%cents * n
  end function int_times

  elemental logical function equal_money(a, b)
    type(money), intent(in) :: a, b
    equal_money = a%cents == b%cents
  end function equal_money

  elemental logical function less_money(a, b)
    type(money), intent(in) :: a, b
    less_money = a%cents < b%cents
  end function less_money

  elemental type(money) function percent(p, a)
    integer, intent(in) :: p
    type(money), intent(in) :: a
    percent%cents = nint(a%cents * p / 100.0)
  end function percent

  function show(m) result(s)
    type(money), intent(in) :: m
    character(len=:), allocatable :: s
    character(len=32) :: buffer
    write (buffer, '(i0, ".", i2.2)') m%cents / 100, mod(m%cents, 100)
    s = '$' // trim(buffer)
  end function show

end module money_mod

program operator_overloading
  use money_mod, only: money, operator(+), operator(*), operator(==), operator(<), operator(.pct.), show
  implicit none (type, external)

  type(money) :: price, tax, total
  type(money) :: basket(3)

  price = money(1999)
  tax = 8 .pct. price
  total = price + tax
  print '(a)', 'price ' // show(price) // ' + tax ' // show(tax) // ' = ' // show(total)
  print '(a)', '3 * price = ' // show(3 * price) // ', price * 3 = ' // show(price * 3)
  print '(a, l1)', 'price == money(1999): ', price == money(1999)
  print '(a, l1)', 'price .eq. tax      : ', price .eq. tax      ! same operator as ==
  print '(a, l1)', 'tax < price         : ', tax < price

  ! Elemental specifics work on arrays.
  basket = [money(100), money(250), money(5)]
  basket = basket + money(1)
  print '(a, *(1x, i0))', 'basket cents:', basket%cents

end program operator_overloading

! Output:
! price $19.99 + tax $1.60 = $21.59
! 3 * price = $59.97, price * 3 = $59.97
! price == money(1999): T
! price .eq. tax      : F
! tax < price         : T
! basket cents: 101 251 6
