C     Exercise 31: a C comment, and a continuation in column 6.
      program ex31
      implicit none (type, external)

      integer n

      n = 6 +
     &    4
      print '(a, i0)', 'n = ', n

      end program ex31

! Output:
! n = 10
