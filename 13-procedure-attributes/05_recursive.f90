! -----------------------------------------------------------------------------
! 05_recursive.f90 - RECURSIVE and NON_RECURSIVE
!
! Run:  scripts/run.sh 13-procedure-attributes/05_recursive.f90
! -----------------------------------------------------------------------------
!
! Since Fortran 2018 procedures are recursive BY DEFAULT; the keyword
! RECURSIVE is still allowed and documents intent. NON_RECURSIVE (F2018)
! states the opposite, letting the compiler use static storage for locals.
! (gfortran 15 does not accept the NON_RECURSIVE keyword yet; the example
! at the end of the module is therefore commented out.)
!
! Compiler note: gfortran historically placed large local arrays in static
! memory unless a procedure was marked recursive (or -frecursive /
! -fopenmp was used). Writing RECURSIVE explicitly keeps recursive code
! correct on every compiler and flag set.
!
! A recursive function returning its own name needs a RESULT clause, so that
! the name refers to the function and not to the result variable.
! SAVEd locals are shared by all active instances.

module recursion
  implicit none (type, external)

  type :: node
    integer :: value
    type(node), allocatable :: left, right   ! recursive allocatable components
  end type node

contains

  recursive integer function factorial(n) result(f)
    integer, intent(in) :: n
    if (n <= 1) then
      f = 1
    else
      f = n * factorial(n - 1)
    end if
  end function factorial

  recursive integer function ackermann(m, n) result(a)
    integer, intent(in) :: m, n
    if (m == 0) then
      a = n + 1
    else if (n == 0) then
      a = ackermann(m - 1, 1)
    else
      a = ackermann(m - 1, ackermann(m, n - 1))
    end if
  end function ackermann

  recursive subroutine insert(tree, value)
    type(node), allocatable, intent(inout) :: tree
    integer, intent(in) :: value
    if (.not. allocated(tree)) then
      tree = node(value)
    else if (value < tree%value) then
      call insert(tree%left, value)
    else
      call insert(tree%right, value)
    end if
  end subroutine insert

  recursive subroutine in_order(tree)
    type(node), intent(in) :: tree
    if (allocated(tree%left)) call in_order(tree%left)
    write (*, '(1x, i0)', advance='no') tree%value
    if (allocated(tree%right)) call in_order(tree%right)
  end subroutine in_order

  ! non_recursive integer function triangle(n)   ! F2018, not in gfortran 15
  integer function triangle(n)
    integer, intent(in) :: n
    triangle = n * (n + 1) / 2
  end function triangle

end module recursion

program recursive_demo
  use recursion, only: node, factorial, ackermann, insert, in_order, triangle
  implicit none (type, external)

  type(node), allocatable :: tree
  integer :: values(7) = [50, 30, 70, 20, 40, 60, 80]
  integer :: i

  print '(a, i0)', 'factorial(10)  = ', factorial(10)
  print '(a, i0)', 'ackermann(2,3) = ', ackermann(2, 3)
  print '(a, i0)', 'triangle(100)  = ', triangle(100)

  do i = 1, size(values)
    call insert(tree, values(i))
  end do
  write (*, '(a)', advance='no') 'binary tree in order:'
  call in_order(tree)
  print '(a)', ''

end program recursive_demo

! Output:
! factorial(10)  = 3628800
! ackermann(2,3) = 9
! triangle(100)  = 5050
! binary tree in order: 20 30 40 50 60 70 80
