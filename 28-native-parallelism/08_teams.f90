! @flags -fcoarray=single
! @run no
! -----------------------------------------------------------------------------
! 08_teams.f90 - TEAMS (F2018)
!
! Build: scripts/check_all.sh compiles it; run it with OpenCoarrays:
!        caf 08_teams.f90 && cafrun -n 4 ./a.out
! (Under gfortran -fcoarray=single, FORM TEAM currently ends the program
!  silently with status 0, so check_all.sh only compiles this file.)
! -----------------------------------------------------------------------------
!
!   type(team_type) :: t                     from iso_fortran_env
!   form team (team_number, t [, new_index=k] [, stat=])
!   change team (t)                          images now work inside t:
!     this_image(), num_images(), sync all,  all relative to the team;
!     collectives                            coarrays: x[k] means team image k
!   end team
!   sync team (t)
!   team_number([team])                      which team am I in?
!   get_team([level])                        initial_team, parent_team,
!                                            current_team
!
! Teams split the images into groups that run independent sub-computations
! (e.g. ocean and atmosphere components of a climate model).

program teams
  use, intrinsic :: iso_fortran_env, only: team_type
  implicit none (type, external)

  type(team_type) :: half
  integer :: me, colour, team_sum

  me = this_image()
  colour = merge(1, 2, mod(me, 2) == 1)       ! odd images -> team 1

  form team (colour, half)
  change team (half)
    team_sum = this_image()
    call co_sum(team_sum)                     ! sums within the team only
    print '(a, i0, a, i0, a, i0, a, i0, a, i0)', 'global image ', me, ' is image ', &
        this_image(), ' of ', num_images(), ' in team ', team_number(), &
        '; team sum ', team_sum
  end team
  sync all
  if (me == 1) print '(a, i0)', 'back in the initial team of ', num_images()

end program teams
