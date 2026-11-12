! -----------------------------------------------------------------------------
! 01_bfs.f90 - Adjacency list graph and breadth-first search distances
!
! Run:  scripts/run.sh 80-graphs/01_bfs.f90
! -----------------------------------------------------------------------------
!
! Demonstrates graph representation using an edge-pool adjacency list
! (arena pattern from chapter 76) and breadth-first search (BFS):
!   - Traverses level-by-level using an integer queue
!   - Computes shortest-path unweighted distances from a source vertex
!   - Identifies unreachable components with distance -1

module graph_m
  implicit none (type, external)
  private
  public :: graph_t

  type :: edge_node_t
    integer :: to = 0
    integer :: next = 0
  end type edge_node_t

  type :: graph_t
    private
    integer, allocatable :: head(:)
    type(edge_node_t), allocatable :: edge_pool(:)
    integer :: n_edges = 0
    integer :: n_vertices = 0
  contains
    procedure :: init
    procedure :: add_edge
    procedure :: add_undirected_edge
    procedure :: bfs_distances
  end type graph_t

contains

  subroutine init(self, n_vertices, max_edges)
    class(graph_t), intent(inout) :: self
    integer, intent(in) :: n_vertices, max_edges

    self%n_vertices = n_vertices
    self%n_edges = 0
    allocate(self%head(n_vertices))
    allocate(self%edge_pool(max_edges))
    self%head = 0
  end subroutine init

  subroutine add_edge(self, u, v)
    class(graph_t), intent(inout) :: self
    integer, intent(in) :: u, v

    self%n_edges = self%n_edges + 1
    self%edge_pool(self%n_edges)%to = v
    self%edge_pool(self%n_edges)%next = self%head(u)
    self%head(u) = self%n_edges
  end subroutine add_edge

  subroutine add_undirected_edge(self, u, v)
    class(graph_t), intent(inout) :: self
    integer, intent(in) :: u, v

    call self%add_edge(u, v)
    call self%add_edge(v, u)
  end subroutine add_undirected_edge

  subroutine bfs_distances(self, source, dist)
    class(graph_t), intent(in) :: self
    integer, intent(in) :: source
    integer, intent(out) :: dist(self%n_vertices)
    integer, allocatable :: queue(:)
    integer :: q_head, q_tail, u, v, e

    allocate(queue(self%n_vertices))
    dist = -1
    q_head = 1
    q_tail = 1

    dist(source) = 0
    queue(q_tail) = source
    q_tail = q_tail + 1

    do while (q_head < q_tail)
      u = queue(q_head)
      q_head = q_head + 1

      e = self%head(u)
      do while (e /= 0)
        v = self%edge_pool(e)%to
        if (dist(v) == -1) then
          dist(v) = dist(u) + 1
          queue(q_tail) = v
          q_tail = q_tail + 1
        end if
        e = self%edge_pool(e)%next
      end do
    end do
  end subroutine bfs_distances

end module graph_m

program graph_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  use graph_m, only: graph_t
  implicit none (type, external)

  type(graph_t) :: g
  integer :: dist(5)

  ! Fixed graph with 5 vertices:
  ! Edges: (1, 2), (1, 3), (2, 4). Vertex 5 is disconnected.
  call g%init(n_vertices=5, max_edges=20)
  call g%add_undirected_edge(1, 2)
  call g%add_undirected_edge(1, 3)
  call g%add_undirected_edge(2, 4)

  call g%bfs_distances(source=1, dist=dist)

  write(output_unit, '(a,*(1x,i0))') 'BFS distances from vertex 1:', dist

end program graph_demo

! Output:
! BFS distances from vertex 1: 0 1 1 2 -1
