! One assignment and mean-update step of 1-D k-means clustering in pure integers.
! Observations: 0, 10; initial centres: 1, 9.

module kmeans_m
  implicit none (type, external)
  private
  public :: assign_clusters, update_centres

contains

  subroutine assign_clusters(pts, centres, labels)
    integer, intent(in) :: pts(:), centres(:)
    integer, intent(out) :: labels(size(pts))
    integer :: i, k, best_k, best_d, d

    do i = 1, size(pts)
      best_k = 1
      best_d = abs(pts(i) - centres(1))
      do k = 2, size(centres)
        d = abs(pts(i) - centres(k))
        if (d < best_d) then
          best_d = d
          best_k = k
        end if
      end do
      labels(i) = best_k
    end do
  end subroutine assign_clusters

  subroutine update_centres(pts, labels, centres)
    integer, intent(in) :: pts(:), labels(:)
    integer, intent(inout) :: centres(:)
    integer :: k, i, total, cnt

    do k = 1, size(centres)
      total = 0
      cnt = 0
      do i = 1, size(pts)
        if (labels(i) == k) then
          total = total + pts(i)
          cnt = cnt + 1
        end if
      end do
      if (cnt > 0) centres(k) = total / cnt
    end do
  end subroutine update_centres

end module kmeans_m

program k_means_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  use kmeans_m, only: assign_clusters, update_centres
  implicit none (type, external)

  integer, parameter :: pts(2) = [0, 10]
  integer :: centres(2), labels(2)

  centres = [1, 9]
  call assign_clusters(pts, centres, labels)
  call update_centres(pts, labels, centres)

  write(output_unit, '(a,1x,i0,1x,i0)') 'clusters:', labels(1), labels(2)
  write(output_unit, '(a,1x,i0,1x,i0)') 'centres:', centres(1), centres(2)

end program k_means_demo

! Output:
! clusters: 1 2
! centres: 0 10
