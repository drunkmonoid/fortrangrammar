! -----------------------------------------------------------------------------
! demo.f90 - dgesv, dgels, and dsyev, each checked against a known answer
!
! Build: scripts/run.sh 43-lapack/01_solve/
! -----------------------------------------------------------------------------
!
! info < 0 means argument -info is illegal. info > 0 means the
! factorisation or the eigen-reduction did not finish. info = 0 is the
! only result this file prints.

program lapack_demo
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)

  interface
    subroutine dgesv(n, nrhs, a, lda, ipiv, b, ldb, info)
      import :: real64
      integer, intent(in) :: n, nrhs, lda, ldb
      integer, intent(out) :: ipiv(*), info
      real(real64), intent(inout) :: a(lda, *), b(ldb, *)
    end subroutine dgesv

    subroutine dgels(trans, m, n, nrhs, a, lda, b, ldb, work, lwork, info)
      import :: real64
      character(len=1), intent(in) :: trans
      integer, intent(in) :: m, n, nrhs, lda, ldb, lwork
      integer, intent(out) :: info
      real(real64), intent(inout) :: a(lda, *), b(ldb, *)
      real(real64), intent(out) :: work(*)
    end subroutine dgels

    subroutine dsyev(jobz, uplo, n, a, lda, w, work, lwork, info)
      import :: real64
      character(len=1), intent(in) :: jobz, uplo
      integer, intent(in) :: n, lda, lwork
      integer, intent(out) :: info
      real(real64), intent(inout) :: a(lda, *)
      real(real64), intent(out) :: w(*), work(*)
    end subroutine dsyev
  end interface

  call show_solve()
  call show_least_squares()
  call show_eigenvalues()

contains

  subroutine check(what, info)
    character(len=*), intent(in) :: what
    integer, intent(in) :: info
    if (info < 0) then
      write (*, '(a, i0)') what // ': illegal argument ', -info
      error stop 1
    else if (info > 0) then
      write (*, '(a, i0)') what // ': failed, info = ', info
      error stop 1
    end if
  end subroutine check

  subroutine show_solve()
    ! 2x + y = 5, x + 3y = 5. The solution is [2, 1].
    real(real64) :: a(2, 2), b(2)
    integer :: ipiv(2), info
    a = reshape([2.0_real64, 1.0_real64, 1.0_real64, 3.0_real64], [2, 2])
    b = 5.0_real64
    call dgesv(2, 1, a, 2, ipiv, b, 2, info)
    call check('dgesv', info)
    print '(a, i0)', 'info = ', info
    print '(a, *(i0, 1x))', 'solve = ', nint(b)
  end subroutine show_solve

  subroutine show_least_squares()
    ! y = 1 + 2x at x = 0, 1, 2. Columns of A are [1, x].
    integer, parameter :: m = 3, n = 2
    real(real64) :: a(m, n), b(m), query(1)
    real(real64), allocatable :: workspace(:)
    integer :: info, lwork
    a = reshape([1.0_real64, 1.0_real64, 1.0_real64, &
                 0.0_real64, 1.0_real64, 2.0_real64], [m, n])
    b = [1.0_real64, 3.0_real64, 5.0_real64]
    call dgels('n', m, n, 1, a, m, b, m, query, -1, info)
    call check('dgels workspace', info)
    lwork = nint(query(1))
    allocate(workspace(lwork))
    a = reshape([1.0_real64, 1.0_real64, 1.0_real64, &
                 0.0_real64, 1.0_real64, 2.0_real64], [m, n])
    b = [1.0_real64, 3.0_real64, 5.0_real64]
    call dgels('n', m, n, 1, a, m, b, m, workspace, lwork, info)
    call check('dgels', info)
    print '(a, *(i0, 1x))', 'least squares = ', nint(b(1:n))
  end subroutine show_least_squares

  subroutine show_eigenvalues()
    ! [[2, 1], [1, 2]] has eigenvalues 1 and 3, returned in ascending order.
    real(real64) :: a(2, 2), w(2), query(1)
    real(real64), allocatable :: workspace(:)
    integer :: info, lwork
    a = reshape([2.0_real64, 1.0_real64, 1.0_real64, 2.0_real64], [2, 2])
    call dsyev('n', 'u', 2, a, 2, w, query, -1, info)
    call check('dsyev workspace', info)
    lwork = nint(query(1))
    allocate(workspace(lwork))
    a = reshape([2.0_real64, 1.0_real64, 1.0_real64, 2.0_real64], [2, 2])
    call dsyev('n', 'u', 2, a, 2, w, workspace, lwork, info)
    call check('dsyev', info)
    print '(a, *(i0, 1x))', 'eigenvalues = ', nint(w)
  end subroutine show_eigenvalues

end program lapack_demo
