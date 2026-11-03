! src/shapes.f90 - library source.
module shapes
  implicit none (type, external)
  private
  public :: circle_area

contains

  pure real function circle_area(r)
    real, intent(in) :: r
    circle_area = acos(-1.0) * r**2
  end function circle_area

end module shapes
