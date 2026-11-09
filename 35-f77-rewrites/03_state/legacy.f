! 03_state/legacy.f - a counter in COMMON, fixed form
!
! Built by 03_state/build.sh. block data sets the counter to 0. Three
! calls of step leave it at 3.

      block data init_state
      implicit none (type, external)
      integer n
      common /state/ n
      data n /0/
      end block data init_state

      program state_legacy
      implicit none (type, external)
      integer n
      external step, fetch
      call step
      call step
      call step
      call fetch(n)
      print 100, n
  100 format ('count = ', i0)
      end program state_legacy

      subroutine step
      implicit none (type, external)
      integer n
      common /state/ n
      n = n + 1
      end subroutine step

      subroutine fetch(k)
      implicit none (type, external)
      integer k
      integer n
      common /state/ n
      k = n
      end subroutine fetch
