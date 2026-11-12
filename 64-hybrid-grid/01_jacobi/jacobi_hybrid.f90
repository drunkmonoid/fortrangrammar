! Hybrid 2-D Jacobi relaxation: MPI domain decomposition across rows,
! OpenMP parallel loops across columns, validated against a serial run.
program jacobi_hybrid
  use, intrinsic :: iso_fortran_env, only: real64, output_unit, error_unit
  use mpi_f08
  implicit none (type, external)

  integer, parameter :: nx = 8, ny = 8, n_steps = 4
  integer :: rank, size, local_nx, top, bottom, i, j, step
  integer :: provided
  real(real64) :: u(0:nx+1, 0:ny+1), unew(0:nx+1, 0:ny+1)
  real(real64) :: local_u(0:nx+1, 0:ny+1), local_unew(0:nx+1, 0:ny+1)
  real(real64) :: local_sum, total_sum, serial_sum
  type(MPI_Request) :: reqs(4)
  type(MPI_Status) :: statuses(4)

  call MPI_Init_thread(MPI_THREAD_FUNNELED, provided)
  call MPI_Comm_rank(MPI_COMM_WORLD, rank)
  call MPI_Comm_size(MPI_COMM_WORLD, size)

  ! Divide rows evenly among ranks
  local_nx = nx / size
  top = merge(MPI_PROC_NULL%MPI_VAL, rank - 1, rank == 0)
  bottom = merge(MPI_PROC_NULL%MPI_VAL, rank + 1, rank == size - 1)

  ! Initialise local domain
  local_u = 0.0_real64
  local_unew = 0.0_real64
  do j = 1, ny
    do i = 1, local_nx
      local_u(i, j) = real((rank * local_nx + i) * 10 + j, kind=real64)
    end do
  end do

  ! Time-stepping with MPI halo exchange + OpenMP worksharing
  do step = 1, n_steps
    ! 1. Post non-blocking halo exchanges for row boundaries
    call MPI_Irecv(local_u(0, 1), ny, MPI_DOUBLE_PRECISION, top, 200, MPI_COMM_WORLD, reqs(1))
    call MPI_Irecv(local_u(local_nx+1, 1), ny, MPI_DOUBLE_PRECISION, bottom, 201, MPI_COMM_WORLD, reqs(2))
    call MPI_Isend(local_u(local_nx, 1), ny, MPI_DOUBLE_PRECISION, bottom, 200, MPI_COMM_WORLD, reqs(3))
    call MPI_Isend(local_u(1, 1), ny, MPI_DOUBLE_PRECISION, top, 201, MPI_COMM_WORLD, reqs(4))

    call MPI_Waitall(4, reqs, statuses)

    ! 2. Compute 5-point stencil with OpenMP multi-threading
    !$omp parallel do collapse(2) default(none) shared(local_u, local_unew, local_nx) private(i, j)
    do j = 1, ny
      do i = 1, local_nx
        local_unew(i, j) = 0.25_real64 * (local_u(i-1, j) + local_u(i+1, j) + &
                                          local_u(i, j-1) + local_u(i, j+1))
      end do
    end do
    !$omp end parallel do

    local_u(1:local_nx, 1:ny) = local_unew(1:local_nx, 1:ny)
  end do

  ! Reduce total checksum across all ranks
  local_sum = sum(local_u(1:local_nx, 1:ny))
  call MPI_Reduce(local_sum, total_sum, 1, MPI_DOUBLE_PRECISION, MPI_SUM, 0, MPI_COMM_WORLD)

  ! Rank 0 runs exact serial reference to verify
  if (rank == 0) then
    u = 0.0_real64
    unew = 0.0_real64
    do j = 1, ny
      do i = 1, nx
        u(i, j) = real(i * 10 + j, kind=real64)
      end do
    end do

    do step = 1, n_steps
      do j = 1, ny
        do i = 1, nx
          unew(i, j) = 0.25_real64 * (u(i-1, j) + u(i+1, j) + u(i, j-1) + u(i, j+1))
        end do
      end do
      u(1:nx, 1:ny) = unew(1:nx, 1:ny)
    end do

    serial_sum = sum(u(1:nx, 1:ny))

    write(output_unit, '(a,l1)') 'Hybrid Jacobi matches serial reference: ', &
      (abs(total_sum - serial_sum) < 1.0e-10_real64)
    write(output_unit, '(a,f12.4)') 'Checksum: ', total_sum
  end if

  call MPI_Finalize()
end program jacobi_hybrid
