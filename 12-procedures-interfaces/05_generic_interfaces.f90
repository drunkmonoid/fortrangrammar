! -----------------------------------------------------------------------------
! 05_generic_interfaces.f90 - one name, many specific procedures
!
! Run:  scripts/run.sh 12-procedures-interfaces/05_generic_interfaces.f90
! -----------------------------------------------------------------------------
!
!   interface swap                    ! the GENERIC name
!     module procedure swap_int, swap_real, swap_string
!   end interface swap
!
! A call to the generic name is resolved AT COMPILE TIME to the one
! specific procedure whose dummy arguments match the actual arguments by
! type, kind and rank (TKR). Intrinsics like abs and sqrt work this way.
!
! Rules for the set of specifics:
!   * any two must be DISTINGUISHABLE: some argument differs in type, kind
!     or rank in a way that cannot be confused, considering keywords and
!     optional arguments (see 08_ambiguous_generic.f90);
!   * a generic may mix functions XOR subroutines, not both;
!   * a generic name may be the same as a specific name;
!   * generics can be extended across modules: another module may add
!     `interface swap; module procedure swap_complex; end interface`.
!
! F2018 also allows `generic :: name => spec1, spec2` outside types.

module generic_swap
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)
  private
  public :: swap, describe

  interface swap
    module procedure swap_int, swap_real, swap_string
  end interface swap

  interface describe
    module procedure describe_scalar, describe_vector, describe_matrix
  end interface describe

contains

  subroutine swap_int(a, b)
    integer, intent(inout) :: a, b
    integer :: t
    t = a; a = b; b = t
  end subroutine swap_int

  subroutine swap_real(a, b)
    real(dp), intent(inout) :: a, b
    real(dp) :: t
    t = a; a = b; b = t
  end subroutine swap_real

  subroutine swap_string(a, b)
    character(len=*), intent(inout) :: a, b
    character(len=max(len(a), len(b))) :: t
    t = a; a = b; b = t
  end subroutine swap_string

  ! Overloading on RANK.
  subroutine describe_scalar(x)
    real(dp), intent(in) :: x
    print '(a, f0.2)', 'scalar ', x
  end subroutine describe_scalar

  subroutine describe_vector(x)
    real(dp), intent(in) :: x(:)
    print '(a, i0)', 'vector of size ', size(x)
  end subroutine describe_vector

  subroutine describe_matrix(x)
    real(dp), intent(in) :: x(:, :)
    print '(a, i0, a, i0)', 'matrix ', size(x, 1), ' x ', size(x, 2)
  end subroutine describe_matrix

end module generic_swap

program generic_interfaces
  use, intrinsic :: iso_fortran_env, only: dp => real64
  use generic_swap, only: swap, describe
  implicit none (type, external)

  integer :: i, j
  real(dp) :: x, y, v(3), m(2, 2)
  character(len=5) :: s, t

  i = 1; j = 2
  x = 1.5_dp; y = 2.5_dp
  s = 'left'; t = 'right'
  v = 0; m = 0

  call swap(i, j)
  call swap(x, y)
  call swap(s, t)
  print '(a, i0, 1x, i0)', 'integers: ', i, j
  print '(a, f0.1, 1x, f0.1)', 'reals   : ', x, y
  print '(4a)', 'strings : ', s, ' ', t

  call describe(x)
  call describe(v)
  call describe(m)

end program generic_interfaces

! Output:
! integers: 2 1
! reals   : 2.5 1.5
! strings : right left
! scalar 2.50
! vector of size 3
! matrix 2 x 2
