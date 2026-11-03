! -----------------------------------------------------------------------------
! 04_allocatable_components.f90 - allocatable components and deep copies
!
! Run:  scripts/run.sh 16-derived-types/04_allocatable_components.f90
! -----------------------------------------------------------------------------
!
! Allocatable components (F2003) make derived types own dynamic data with no
! manual memory management:
!
!   * intrinsic assignment a = b performs a DEEP COPY: each allocatable
!     component of a is (re)allocated and receives a copy of b's data;
!   * when an object goes out of scope or is deallocated, its allocatable
!     components are deallocated too, recursively;
!   * intent(out) dummies have their allocatable components deallocated on
!     entry;
!   * a type may contain an allocatable component OF ITS OWN TYPE (F2008),
!     giving recursive data structures without pointers.
!
! Contrast: POINTER components are copied SHALLOWLY (both objects point at
! the same target) and are never freed automatically (chapter 21).

module polynomials
  implicit none (type, external)

  type :: polynomial
    real, allocatable :: coeffs(:)          ! c(1) + c(2) x + c(3) x^2 ...
  end type polynomial

  type :: list_node                         ! recursive allocatable component
    integer :: value
    type(list_node), allocatable :: next
  end type list_node

contains

  elemental real function evaluate(p, x)
    type(polynomial), intent(in) :: p
    real, intent(in) :: x
    integer :: i
    evaluate = 0
    do i = size(p%coeffs), 1, -1            ! Horner's scheme
      evaluate = evaluate * x + p%coeffs(i)
    end do
  end function evaluate

  recursive subroutine print_list(node)
    type(list_node), intent(in) :: node
    write (*, '(1x, i0)', advance='no') node%value
    if (allocated(node%next)) call print_list(node%next)
  end subroutine print_list

end module polynomials

program allocatable_components
  use polynomials, only: polynomial, list_node, evaluate, print_list
  implicit none (type, external)

  type(polynomial) :: p, q
  type(list_node) :: head

  p = polynomial([1.0, 0.0, 2.0])           ! 1 + 2x^2
  q = p                                     ! deep copy
  q%coeffs(1) = 100.0                       ! does NOT affect p
  print '(a, *(1x, f0.1))', 'p%coeffs:', p%coeffs
  print '(a, *(1x, f0.1))', 'q%coeffs:', q%coeffs
  print '(a, *(1x, f0.1))', 'p(0:3)  :', evaluate(p, [0.0, 1.0, 2.0, 3.0])

  q%coeffs = [q%coeffs, 5.0]                ! the component reallocates
  print '(a, i0)', 'degree of q after append: ', size(q%coeffs) - 1

  ! A three-element singly linked list built from allocatable components.
  head = list_node(1, list_node(2, list_node(3, null())))
  write (*, '(a)', advance='no') 'list:'
  call print_list(head)
  print '(a)', ''
  ! No cleanup code: everything is deallocated automatically.

end program allocatable_components

! Output:
! p%coeffs: 1.0 .0 2.0
! q%coeffs: 100.0 .0 2.0
! p(0:3)  : 1.0 3.0 9.0 19.0
! degree of q after append: 3
! list: 1 2 3
