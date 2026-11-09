! 02_stencil/legacy.f - 3-point stencil, fixed form
!
! Built by 02_stencil/build.sh. b(i) = a(i-1) + a(i) + a(i+1) for the
! interior of [1, 2, 3, 4, 5].

      program stencil_legacy
      implicit none (type, external)
      integer a(5), b(3), i
      data a /1, 2, 3, 4, 5/
      do 10 i = 2, 4
        b(i - 1) = a(i - 1) + a(i) + a(i + 1)
   10 continue
      print 100, b
  100 format ('stencil =', 3(1x, i0))
      end program stencil_legacy
