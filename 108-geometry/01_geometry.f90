! Circle-segment intersection for unit circle x^2 + y^2 = 1 at the origin.
! All segment endpoints are dyadic (exact integers/powers of two), making the
! quadratic discriminant exact in IEEE binary64 arithmetic.

module geometry_m
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  private
  public :: segment_hits_unit_circle

contains

  pure logical function segment_hits_unit_circle(p0, p1) result(hits)
    real(real64), intent(in) :: p0(2), p1(2)
    real(real64) :: d(2), a, b, c, disc, sqrt_disc, t1, t2

    d = p1 - p0
    a = dot_product(d, d)
    if (a == 0.0_real64) then
      hits = .false.
      return
    end if

    b = 2.0_real64 * dot_product(p0, d)
    c = dot_product(p0, p0) - 1.0_real64
    disc = b * b - 4.0_real64 * a * c

    ! Treat non-positive discriminant as a miss.
    if (disc <= 0.0_real64) then
      hits = .false.
      return
    end if

    sqrt_disc = sqrt(disc)
    t1 = (-b - sqrt_disc) / (2.0_real64 * a)
    t2 = (-b + sqrt_disc) / (2.0_real64 * a)

    hits = (t1 >= 0.0_real64 .and. t1 <= 1.0_real64) .or. &
           (t2 >= 0.0_real64 .and. t2 <= 1.0_real64)
  end function segment_hits_unit_circle

end module geometry_m

program geometry_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit
  use geometry_m, only: segment_hits_unit_circle
  implicit none (type, external)

  logical :: seg1_hit, seg2_hit

  seg1_hit = segment_hits_unit_circle([0.0_real64, 0.0_real64], [2.0_real64, 0.0_real64])
  seg2_hit = segment_hits_unit_circle([2.0_real64, 2.0_real64], [3.0_real64, 2.0_real64])

  write(output_unit, '(a)') trim(merge('hit ', 'miss', seg1_hit))
  write(output_unit, '(a)') trim(merge('hit ', 'miss', seg2_hit))

end program geometry_demo

! Output:
! hit
! miss
