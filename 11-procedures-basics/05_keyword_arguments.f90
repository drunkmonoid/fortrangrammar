! -----------------------------------------------------------------------------
! 05_keyword_arguments.f90 - passing arguments by name
!
! Run:  scripts/run.sh 11-procedures-basics/05_keyword_arguments.f90
! -----------------------------------------------------------------------------
!
!   call plot(x, y, colour='red', width=2)
!
! * The keyword is the DUMMY argument's name.
! * Positional arguments first, then keyword arguments in any order. After
!   the first keyword argument, all following ones must be keywords.
! * Needs an explicit interface (the names come from it). This also means
!   the dummy names are part of a procedure's public API: renaming a dummy
!   breaks callers that use keywords.
! * Intrinsics accept keywords too: sum(a, dim=1), index(s, '/', back=.true.)

module keyword_demo
  implicit none (type, external)
contains

  subroutine make_box(width, height, depth, label)
    real, intent(in) :: width, height
    real, intent(in), optional :: depth
    character(len=*), intent(in), optional :: label
    real :: d

    d = 1.0
    if (present(depth)) d = depth
    if (present(label)) then
      print '(a, a, a, f0.1)', 'box "', label, '" volume ', width * height * d
    else
      print '(a, f0.1)', 'unlabelled box volume ', width * height * d
    end if
  end subroutine make_box

end module keyword_demo

program keyword_arguments
  use keyword_demo, only: make_box
  implicit none (type, external)

  call make_box(2.0, 3.0)
  call make_box(2.0, 3.0, 4.0)
  call make_box(2.0, 3.0, label='flat')            ! skips depth
  call make_box(height=3.0, width=2.0, depth=0.5)  ! any order
  call make_box(1.0, label='cube', height=1.0, depth=1.0)
  ! call make_box(width=1.0, 2.0)  <- error: positional after keyword

  print '(a, *(1x, i0))', 'intrinsic with keywords:', &
      sum(reshape([1, 2, 3, 4], [2, 2]), dim=2)

end program keyword_arguments

! Output:
! unlabelled box volume 6.0
! unlabelled box volume 24.0
! box "flat" volume 6.0
! unlabelled box volume 3.0
! box "cube" volume 1.0
! intrinsic with keywords: 4 6
