program test
        use, intrinsic :: iso_fortran_env, only: stdout => output_unit
        use mpi
        implicit none(type, external)
        integer :: ierr, rank, nprocs
        integer :: default_int, type_size

        call MPI_Init(ierr)
        call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
        call MPI_Comm_size(MPI_COMM_WORLD, nprocs, ierr)

        if(rank .eq. 0) then
                write(stdout, '("Default integer size: ",I0," B")') storage_size(default_int)/8
                call mpi_type_size(MPI_INTEGER, type_size, ierr)
                write(stdout, '("MPI_INTEGER size:     ",I0," B")') type_size
        endif

        write(stdout, '("Howdy from rank ", I0, " of ", I0)') rank, nprocs

        call mpi_finalize(ierr)

end program test
