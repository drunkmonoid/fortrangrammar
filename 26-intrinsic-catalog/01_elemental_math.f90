! -----------------------------------------------------------------------------
! 01_elemental_math.f90 - mathematical elemental functions
!
! Run:  scripts/run.sh 26-intrinsic-catalog/01_elemental_math.f90
! -----------------------------------------------------------------------------
!
! All are ELEMENTAL and GENERIC: they accept any real kind (most also
! complex) and return the same kind. Arrays work element by element.
!
!   sqrt exp log log10                      powers and logarithms
!   sin cos tan asin acos atan atan2(y, x)  trigonometry (radians)
!   sinh cosh tanh asinh acosh atanh        hyperbolic (complex too, F2008)
!   hypot(x, y)                             sqrt(x**2 + y**2) without overflow
!   erf erfc erfc_scaled                    error functions
!   gamma log_gamma                         Gamma function and ln|Gamma|
!   bessel_j0 j1 jn(n, x) y0 y1 yn(n, x)    Bessel functions
!   bessel_jn(n1, n2, x)                    TRANSFORMATIONAL: orders n1..n2
!   abs dim(x, y) sign(a, b) max min mod modulo dprod
!
! Domain errors (sqrt(-1.0), log(0.0)) are not detected by the language:
! the result is processor-dependent (usually NaN or -Inf, with an IEEE
! flag raised). Use complex arguments where needed.

program elemental_math
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  real(dp), parameter :: pi = acos(-1.0_dp)
  real(dp) :: x(4) = [0.1_dp, 0.5_dp, 1.0_dp, 2.0_dp]

  print '(a, *(1x, f9.5))', 'sqrt      :', sqrt(x)
  print '(a, *(1x, f9.5))', 'exp       :', exp(x)
  print '(a, *(1x, f9.5))', 'log       :', log(x)
  print '(a, *(1x, f9.5))', 'log10     :', log10(x)
  print '(a, *(1x, f9.5))', 'sin       :', sin(x)
  print '(a, *(1x, f9.5))', 'atan      :', atan(x)
  print '(a, f9.5)',        'atan2(1,-1):', atan2(1.0_dp, -1.0_dp)
  print '(a, *(1x, f9.5))', 'asinh     :', asinh(x)
  print '(a, *(1x, f9.5))', 'erf       :', erf(x)
  print '(a, *(1x, f9.5))', 'gamma     :', gamma(x)
  print '(a, *(1x, f9.5))', 'log_gamma :', log_gamma(x)
  print '(a, *(1x, f9.5))', 'bessel_j0 :', bessel_j0(x)
  print '(a, *(1x, f9.5))', 'j_0..2(1) :', bessel_jn(0, 2, 1.0_dp)
  print '(a, es12.4e3)',    'hypot(3e200, 4e200) = ', hypot(3.0e200_dp, 4.0e200_dp)
  print '(a, f9.5)',        'gamma(5) = 4! :', gamma(5.0_dp)
  print '(a, f9.5)',        'sqrt(pi)      :', gamma(0.5_dp)

  ! sign, dim, dprod
  print '(a, f0.1, 1x, f0.1)', 'sign(3, -1), sign(-3, 2) = ', sign(3.0, -1.0), sign(-3.0, 2.0)
  print '(a, f0.1, 1x, f0.1)', 'dim(5, 3), dim(3, 5)     = ', dim(5.0, 3.0), dim(3.0, 5.0)
  print '(a, es23.16)', 'dprod(0.1, 0.1) (double result) = ', dprod(0.1, 0.1)

  ! Complex arguments.
  print '(a, 2(1x, f0.5))', 'sqrt((-4,0)) =', sqrt((-4.0_dp, 0.0_dp))
  print '(a, 2(1x, f0.5))', 'log((-1,0))  =', log((-1.0_dp, 0.0_dp))

end program elemental_math

! Output:
! sqrt      :   0.31623   0.70711   1.00000   1.41421
! exp       :   1.10517   1.64872   2.71828   7.38906
! log       :  -2.30259  -0.69315   0.00000   0.69315
! log10     :  -1.00000  -0.30103   0.00000   0.30103
! sin       :   0.09983   0.47943   0.84147   0.90930
! atan      :   0.09967   0.46365   0.78540   1.10715
! atan2(1,-1):  2.35619
! asinh     :   0.09983   0.48121   0.88137   1.44364
! erf       :   0.11246   0.52050   0.84270   0.99532
! gamma     :   9.51351   1.77245   1.00000   1.00000
! log_gamma :   2.25271   0.57236   0.00000   0.00000
! bessel_j0 :   0.99750   0.93847   0.76520   0.22389
! j_0..2(1) :   0.76520   0.44005   0.11490
! hypot(3e200, 4e200) =  5.0000E+200
! gamma(5) = 4! : 24.00000
! sqrt(pi)      :  1.77245
! sign(3, -1), sign(-3, 2) = -3.0 3.0
! dim(5, 3), dim(3, 5)     = 2.0 .0
! dprod(0.1, 0.1) (double result) =  1.0000000298023226E-02
! sqrt((-4,0)) = .00000 2.00000
! log((-1,0))  = .00000 3.14159
