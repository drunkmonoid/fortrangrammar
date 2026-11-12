submodule (interp1d_m) interp1d_impl_s
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
contains

  module subroutine interp1d_init(self, x, y, stat)
    class(interp1d_t), intent(inout) :: self
    real(real64), intent(in) :: x(:), y(:)
    integer, intent(out) :: stat
    integer :: n, i

    n = size(x)
    if (n < 2 .or. size(y) /= n) then
      stat = -1
      return
    end if

    ! Verify strict monotonicity
    do i = 1, n - 1
      if (x(i+1) <= x(i)) then
        stat = -2
        return
      end if
    end do

    allocate(self%x(n), self%y(n))
    self%x = x
    self%y = y
    stat = 0
  end subroutine interp1d_init

  module function interp1d_eval(self, xq, stat) result(yq)
    class(interp1d_t), intent(in) :: self
    real(real64), intent(in) :: xq
    integer, intent(out) :: stat
    real(real64) :: yq
    integer :: low, high, mid, n
    real(real64) :: t

    if (.not. allocated(self%x)) then
      stat = -3
      yq = 0.0_real64
      return
    end if

    n = size(self%x)
    ! Bounds check
    if (xq < self%x(1) .or. xq > self%x(n)) then
      stat = -4
      yq = 0.0_real64
      return
    end if

    ! Binary search for bracket
    low = 1
    high = n
    do while (high - low > 1)
      mid = (low + high) / 2
      if (self%x(mid) <= xq) then
        low = mid
      else
        high = mid
      end if
    end do

    t = (xq - self%x(low)) / (self%x(high) - self%x(low))
    yq = self%y(low) + t * (self%y(high) - self%y(low))
    stat = 0
  end function interp1d_eval

  module subroutine interp1d_destroy(self)
    class(interp1d_t), intent(inout) :: self
    if (allocated(self%x)) deallocate(self%x)
    if (allocated(self%y)) deallocate(self%y)
  end subroutine interp1d_destroy

end submodule interp1d_impl_s
