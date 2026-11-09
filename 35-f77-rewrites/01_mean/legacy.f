! 01_mean/legacy.f - mean of a table, fixed form
!
! Built by 01_mean/build.sh. Sum 2, 4, 6, 8 with a labelled do.

      program mean_legacy
      implicit none (type, external)
      integer a(4), i, n, s
      data a /2, 4, 6, 8/
      n = 4
      s = 0
      do 10 i = 1, n
        s = s + a(i)
   10 continue
      print 100, s
      print 110, s / n
  100 format ('sum = ', i0)
  110 format ('mean = ', i0)
      end program mean_legacy
