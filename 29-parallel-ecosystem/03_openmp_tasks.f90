! @flags -fopenmp
! -----------------------------------------------------------------------------
! 03_openmp_tasks.f90 - tasks and sections
!
! Run:  scripts/run.sh 29-parallel-ecosystem/03_openmp_tasks.f90
! -----------------------------------------------------------------------------
!
!   !$omp task [shared(...)] [firstprivate(...)] [if(cond)] [depend(...)]
!   !$omp taskwait                    wait for child tasks
!   !$omp taskloop                    a loop split into tasks
!   !$omp sections / !$omp section    fixed set of independent blocks
!
! Tasks express irregular parallelism (recursion, linked structures). They
! are usually created inside `parallel` + `single`, so one thread spawns and
! the whole team executes. Recursive procedures must be RECURSIVE (and
! compiling with -fopenmp also implies -frecursive in gfortran).

module tasks_mod
  implicit none (type, external)
contains

  recursive integer function fib(n) result(f)
    integer, intent(in) :: n
    integer :: a, b
    if (n < 20) then                    ! small problems: plain recursion
      f = serial_fib(n)
      return
    end if
    !$omp task shared(a)
      a = fib(n - 1)
    !$omp end task
    !$omp task shared(b)
      b = fib(n - 2)
    !$omp end task
    !$omp taskwait
    f = a + b
  end function fib

  recursive integer function serial_fib(n) result(f)
    integer, intent(in) :: n
    if (n < 2) then
      f = n
    else
      f = serial_fib(n - 1) + serial_fib(n - 2)
    end if
  end function serial_fib

end module tasks_mod

program openmp_tasks
  use tasks_mod, only: fib
  implicit none (type, external)

  integer :: result, a, b, k

  !$omp parallel num_threads(4)
  !$omp single
    result = fib(30)
  !$omp end single
  !$omp end parallel
  print '(a, i0)', 'fib(30) with tasks = ', result

  !$omp parallel sections num_threads(2)
  !$omp section
    a = sum([(i_sq(k), k = 1, 100)])
  !$omp section
    b = product([1, 2, 3, 4, 5])
  !$omp end parallel sections
  print '(a, i0, a, i0)', 'sections: sum of squares = ', a, ', 5! = ', b

contains

  pure integer function i_sq(k)
    integer, intent(in) :: k
    i_sq = k * k
  end function i_sq

end program openmp_tasks

! Output:
! fib(30) with tasks = 832040
! sections: sum of squares = 338350, 5! = 120
