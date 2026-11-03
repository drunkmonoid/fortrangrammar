! -----------------------------------------------------------------------------
! 01_pointer_basics.f90 - POINTER, TARGET, =>, associated, null
!
! Run:  scripts/run.sh 21-pointers/01_pointer_basics.f90
! -----------------------------------------------------------------------------
!
! A Fortran pointer is an ALIAS with a type, kind and rank - not an address.
!
!   real, target :: x              only TARGETs (or other pointers) can be
!   real, pointer :: p => null()   pointed to; initialise pointers to null
!
!   p => x                         POINTER ASSIGNMENT: p becomes an alias of x
!   p = 3.0                        ordinary assignment: stores INTO x
!   associated(p)                  is p associated with anything?
!   associated(p, x)               is p associated with x specifically?
!   nullify(p)  /  p => null()     disassociate
!
! Pointer association status is one of: associated, disassociated or
! UNDEFINED. A pointer declared without => null() starts undefined, and
! even associated() cannot be called on it safely. Always initialise.
!
! Pointers to pointers do not exist; `q => p` makes q point at p's target.

program pointer_basics
  implicit none (type, external)

  real, target :: x = 1.0, y = 2.0
  real, pointer :: p => null(), q => null()

  print '(a, l1)', 'associated(p) initially : ', associated(p)

  p => x
  print '(a, l1)', 'after p => x            : ', associated(p)
  print '(a, l1, 1x, l1)', 'associated(p, x), (p, y): ', associated(p, x), associated(p, y)

  p = 10.0                                ! writes through to x
  print '(a, f0.1)', 'x after p = 10          : ', x

  q => p                                  ! q now also points at x
  q = q + 1
  print '(a, f0.1)', 'x after q = q + 1       : ', x

  p => y                                  ! re-point p; q still aims at x
  print '(a, f0.1, 1x, f0.1)', 'p, q                    : ', p, q

  nullify (p)
  q => null()
  print '(a, l1, 1x, l1)', 'after nullify / null()  : ', associated(p), associated(q)

end program pointer_basics

! Output:
! associated(p) initially : F
! after p => x            : T
! associated(p, x), (p, y): T F
! x after p = 10          : 10.0
! x after q = q + 1       : 11.0
! p, q                    : 2.0 11.0
! after nullify / null()  : F F
