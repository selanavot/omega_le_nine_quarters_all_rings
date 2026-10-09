# Independent mathematical audit: integral finite separation

Reviewed by the spectrum worker on 2026-10-09. This is a source-level mathematical
review; successful compilation and final kernel/Comparator verification are
separate obligations recorded in the verification logs.

Sources reviewed: `Integral/{Cyclotomic,UnnormalizedFourier,SeparationWeights,
SeparationPolynomial,SeparationDescent,FiniteSeparation,RestrictionDescent,
CharacterTransport}.lean`.

The coefficient target is correct. Unnormalized Fourier summation produces
exactly `L * separationTarget B`; no inverse of L occurs. The polynomial degree
shifts add M² to each of the second and third local maps. The first surviving
coefficient therefore occurs at 2M² and equals the stated scalar target.
Off-phase branches vanish by the root-of-unity sum in the cyclotomic domain.
The phase range is strictly smaller than L when L≥5M, so divisibility by L
selects exactly phase zero.

Powering this degeneration multiplies its leading degree by n and its scalar
by L^n. Coefficient extraction uses `(Lx*n+1)*(Ly*n+1)` copies; Lx and Ly are
chosen before n. The third map reads the complementary coefficient, so no
interpolation points, division, or third degree factor are needed.

Finite-free descent uses the fixed cyclotomic ring Z[ζ_L], with its monic
power basis and the constant-coefficient projection that sends 1 to 1.
Expanding the first two local-map coefficients uses D² copies, where D=φ(L).
It does not take a new extension or tensor its coefficient algebra for each
power. Thus D² is independent of n, as required.

The two periods are L=5M and L+1. After descent, their sources can have different
coordinate sets and degree bounds. `restriction_patch_binary` uses their direct
sum and Bézout coefficients for the coprime integer powers L^n and (L+1)^n.
The exact integer target is recovered before a character is evaluated. This is
necessary: integral characters need not be faithful on arbitrary scalar
multiples, and scalar division would be invalid here.

Character values of the sources are D² times a quadratic polynomial in n times
L^n (respectively (L+1)^n) times the nth power of the shared tensor value.
The common estimate uses `(Ax+Bx, Ay+By, cA+cB)` and `(L+1)^n`; all multiplicative
character factors are nonnegative. Taking the exponential rate removes only
fixed and polynomial factors, giving `(L+1)*χ(sharedFirstTensor B)`.
For M>0, L+1=5M+1≤6M, yielding exactly the downstream finite-separation bound.
The n=0 identities are valid (all scalar powers equal 1), and M=0 is excluded
explicitly. Zero tensors are harmless because only nonnegativity, never
nonzero-implies-positive, is used here.

No gap was found in target normalization, scalar cancellation, extension-degree
accounting, or asymptotic overhead. This audit does not itself establish the
final matrix-multiplication exponent theorem.
