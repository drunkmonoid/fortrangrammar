! convert.f90 - depends on units.
module convert
  use units, only: km_per_mile
  implicit none (type, external)
contains
  elemental real function miles_to_km(m)
    real, intent(in) :: m
    miles_to_km = m * km_per_mile
  end function miles_to_km
end module convert
