! -----------------------------------------------------------------------------
! 07_random_numbers.f90 - random_number, random_seed, random_init
!
! Run:  scripts/run.sh 24-errors-environment/07_random_numbers.f90
! -----------------------------------------------------------------------------
!
!   call random_number(harvest)        uniform in [0, 1); scalar or array,
!                                      any real kind
!   call random_seed(size=n)           size of the seed array
!   call random_seed(put=seed)         set the state     (get=seed reads it)
!   call random_seed()                 processor-dependent reinitialisation
!   call random_init(repeatable, image_distinct)        (F2018)
!       repeatable=.true.  same sequence on every run
!       repeatable=.false. different sequence each run
!       image_distinct     different streams per coarray image
!
! The generator and the seed format are processor-dependent: equal seeds
! give equal sequences only with the same compiler. Integers in [lo, hi]:
!   lo + floor((hi - lo + 1) * u)

program random_numbers
  implicit none (type, external)

  real :: u, v(5)
  integer :: n, dice(10)
  integer, allocatable :: seed(:)
  real :: first(3), again(3)

  call random_init(repeatable=.false., image_distinct=.true.)
  call random_number(u)
  print '(a, f0.6)', 'a random number: ', u
  call random_number(v)
  print '(a, *(1x, f0.4))', 'an array       :', v

  ! Dice rolls 1..6.
  block
    real :: r(10)
    call random_number(r)
    dice = 1 + floor(6 * r)
  end block
  print '(a, *(1x, i0))', 'dice           :', dice

  ! Reproducible sequence by putting an explicit seed.
  call random_seed(size=n)
  allocate (seed(n))
  seed = 12345
  call random_seed(put=seed)
  call random_number(first)
  call random_seed(put=seed)
  call random_number(again)
  print '(a, i0, a, l1)', 'seed size ', n, ', same seed -> same numbers: ', all(first == again)

end program random_numbers
