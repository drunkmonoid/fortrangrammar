! -----------------------------------------------------------------------------
! 05_control_descriptors.f90 - positioning: X, T, TL, TR, /, :
!
! Run:  scripts/run.sh 22-formatted-io/05_control_descriptors.f90
! -----------------------------------------------------------------------------
!
!   nX      move n positions right (output: blanks)
!   Tn      tab to absolute column n of the record
!   TLn     move n positions left           TRn   n positions right (= nX)
!   /       end the current record, start a new one
!   :       stop formatting here if no data items remain
!   'text'  output literal text
!
! T and TL can move BACKWARDS and overwrite what was already placed, so a
! record can be assembled out of order - handy for fixed-column layouts.

program control_descriptors
  implicit none (type, external)

  print '(a, 5x, a)', 'left', 'right'
  print '(t10, a, t1, a)', 'col 10', 'col 1'           ! out of order
  print '(a, tl3, a)', 'abcdef', 'XY'                   ! overwrite 'de'
  print '(a, tr4, a)', 'gap', 'after'
  print '(a, /, a, //, a)', 'line 1', 'line 2', 'after a blank line'
  print '(3(i0, :, ", "))', 1, 2, 3                     ! no trailing comma
  print '(3(i0, ", "))', 1, 2, 3                        ! trailing ", "

  ! A fixed-column table.
  print '(a, t12, a, t22, a)', 'name', 'qty', 'price'
  print '(a, t12, i3, t22, f6.2)', 'apples', 12, 0.5
  print '(a, t12, i3, t22, f6.2)', 'pears', 7, 0.75

end program control_descriptors

! Output:
! left     right
! col 1    col 10
! abcXYf
! gap    after
! line 1
! line 2
!
! after a blank line
! 1, 2, 3
! 1, 2, 3,
! name       qty       price
! apples      12         0.50
! pears        7         0.75
