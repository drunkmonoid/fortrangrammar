module interp1d_m
  use, intrinsic :: iso_fortran_env, only: real64
  use, intrinsic :: iso_c_binding, only: c_int, c_double
  implicit none (type, external)
  private
  public :: interp1d_t, c_interp1d_linear

  type :: interp1d_t
    private
    real(real64), allocatable :: x(:)
    real(real64), allocatable :: y(:)
  contains
    procedure :: init => interp1d_init
    procedure :: eval => interp1d_eval
    procedure :: destroy => interp1d_destroy
  end type interp1d_t

  interface
    module subroutine interp1d_init(self, x, y, stat)
      class(interp1d_t), intent(inout) :: self
      real(real64), intent(in) :: x(:), y(:)
      integer, intent(out) :: stat
    end subroutine interp1d_init

    module function interp1d_eval(self, xq, stat) result(yq)
      class(interp1d_t), intent(in) :: self
      real(real64), intent(in) :: xq
      integer, intent(out) :: stat
      real(real64) :: yq
    end function interp1d_eval

    module subroutine interp1d_destroy(self)
      class(interp1d_t), intent(inout) :: self
    end subroutine interp1d_destroy
  end interface

contains

  ! bind(c) surface for C and Python callers
  subroutine c_interp1d_linear(n, x, y, nq, xq, yq, stat) bind(c, name="interp1d_linear")
    integer(c_int), value, intent(in) :: n, nq
    real(c_double), intent(in) :: x(n), y(n), xq(nq)
    real(c_double), intent(out) :: yq(nq)
    integer(c_int), intent(out) :: stat

    type(interp1d_t) :: interp
    integer :: f_stat, i

    call interp%init(x, y, f_stat)
    stat = int(f_stat, kind=c_int)
    if (stat /= 0) return

    do i = 1, nq
      yq(i) = interp%eval(xq(i), f_stat)
      if (f_stat /= 0) then
        stat = int(f_stat, kind=c_int)
        call interp%destroy()
        return
      end if
    end do

    call interp%destroy()
  end subroutine c_interp1d_linear

end module interp1d_m
