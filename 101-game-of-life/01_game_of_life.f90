! One generation of Conway's Game of Life on a 5x5 grid with dead edges.
! Initial state: vertical blinker at (2,3), (3,3), (4,3).
! Centre cell (3,3) has 2 live neighbours ((2,3) and (4,3)) and survives;
! (3,2) and (3,4) each have 3 live neighbours and become alive, rotating the blinker.

module life_m
  implicit none (type, external)
  private
  public :: step_life

contains

  subroutine step_life(cur, nxt)
    integer, intent(in) :: cur(:, :)
    integer, intent(out) :: nxt(size(cur, 1), size(cur, 2))
    integer :: n_rows, n_cols, r, c, nbrs

    n_rows = size(cur, 1)
    n_cols = size(cur, 2)
    nxt = 0

    do c = 2, n_cols - 1
      do r = 2, n_rows - 1
        nbrs = sum(cur(r - 1:r + 1, c - 1:c + 1)) - cur(r, c)
        if (cur(r, c) == 1) then
          if (nbrs == 2 .or. nbrs == 3) nxt(r, c) = 1
        else
          if (nbrs == 3) nxt(r, c) = 1
        end if
      end do
    end do
  end subroutine step_life

end module life_m

program game_of_life_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  use life_m, only: step_life
  implicit none (type, external)

  integer, parameter :: n = 5
  integer :: grid(n, n), next_grid(n, n)
  integer :: r

  grid = 0
  grid(2:4, 3) = 1

  call step_life(grid, next_grid)

  do r = 1, n
    write(output_unit, '(5(i0))') next_grid(r, :)
  end do
  write(output_unit, '(a,1x,i0)') 'live cells:', sum(next_grid)

end program game_of_life_demo

! Output:
! 00000
! 00000
! 01110
! 00000
! 00000
! live cells: 3
