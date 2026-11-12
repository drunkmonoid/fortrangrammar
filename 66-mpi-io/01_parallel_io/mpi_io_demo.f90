! Distributed 1-D array write and read using MPI-IO collective operations.
program mpi_io_demo
  use, intrinsic :: iso_fortran_env, only: real64, output_unit, error_unit
  use mpi_f08
  implicit none (type, external)

  integer, parameter :: n = 4
  real(real64) :: local_data(n)
  real(real64), allocatable :: full_data(:), expected(:)
  type(MPI_File) :: fh
  type(MPI_Status) :: status
  integer(MPI_OFFSET_KIND) :: offset, zero_offset
  integer :: rank, size, i, total_n
  logical :: verified

  call MPI_Init()
  call MPI_Comm_rank(MPI_COMM_WORLD, rank)
  call MPI_Comm_size(MPI_COMM_WORLD, size)

  total_n = n * size
  allocate(full_data(total_n))
  allocate(expected(total_n))

  ! Each rank initialises its slice with distinct linear values
  do i = 1, n
    local_data(i) = real(rank * 100 + i, kind=real64)
  end do

  ! Expected full dataset
  do i = 1, total_n
    expected(i) = real(((i - 1) / n) * 100 + mod(i - 1, n) + 1, kind=real64)
  end do

  ! Offset in bytes: 8 bytes per double precision real
  offset = int(rank * n * 8, kind=MPI_OFFSET_KIND)

  ! 1. Open file collectively and write slice with MPI_File_write_at_all
  call MPI_File_open(MPI_COMM_WORLD, "data.bin", &
                     MPI_MODE_CREATE + MPI_MODE_WRONLY, &
                     MPI_INFO_NULL, fh)

  call MPI_File_write_at_all(fh, offset, local_data, n, MPI_DOUBLE_PRECISION, status)
  call MPI_File_close(fh)

  ! Ensure write visibility across all ranks
  call MPI_Barrier(MPI_COMM_WORLD)

  ! 2. Reopen file and read back entire array collectively
  call MPI_File_open(MPI_COMM_WORLD, "data.bin", &
                     MPI_MODE_RDONLY, &
                     MPI_INFO_NULL, fh)

  zero_offset = 0_MPI_OFFSET_KIND
  call MPI_File_read_at_all(fh, zero_offset, full_data, total_n, MPI_DOUBLE_PRECISION, status)
  call MPI_File_close(fh)

  ! Verify results
  verified = all(full_data == expected)

  if (rank == 0) then
    write(output_unit, '(a,1x,l1)') 'MPI-IO verified:', verified
    write(output_unit, '(a,1x,i0)') 'Total elements:', total_n
    write(output_unit, '(a,1x,f10.1)') 'Checksum:', sum(full_data)
  end if

  deallocate(full_data, expected)
  call MPI_Finalize()
end program mpi_io_demo
