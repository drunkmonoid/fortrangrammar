! geometry_impl.F90 - the implementation. build.sh compiles it twice with
! two different algorithms (selected by -DMANHATTAN) to show that the
! parent's geometry.mod does not change.
submodule (geometry) geometry_impl
  implicit none (type, external)
contains
  module procedure distance
#ifdef MANHATTAN
    distance = abs(x2 - x1) + abs(y2 - y1)
#else
    distance = hypot(x2 - x1, y2 - y1)
#endif
  end procedure distance
end submodule geometry_impl
