# Integral transport status

Owner: omega_constructions / transport. 2026-10-09.

Current source drafts (NOT yet compiler verified):
- Integral/Restriction: concatenate local maps on a finite direct sum; weighted version.
- Integral/FiniteFreeDescent: fixed finite basis and a supplied unit-splitting
  linear functional; exact rank and all-power descent with one D² overhead.
- Integral/CoefficientExtraction: direct polynomial coefficient expansion;
  `(a+1)(b+1)` source copies, no interpolation or division. The third coefficient
  has an explicit zero guard when the requested index would be negative.
- Integral/CoprimePatch: concatenate actual rank decompositions/restrictions
  with Bezout coefficients, including powers of two coprime scalars.

Build requests use scripts/lean-queue.py; only the coordinator runs the worker.
The first request was submitted before the dependency-cache repair notice and
has not yet supplied compiler evidence. Further requests await cache readiness.

Next: restriction-level finite-free descent; adjugate Vandermonde interpolation
and multiplication-matrix norm clearing. The latter uses no localization:
`adj(V)*V = det(V)*I` gives a scheme for Delta times convolution; applying the
adjugate multiplication-by-Delta matrix to the coordinate vector of 1 produces
w with Delta*w = det(mulDelta)*1. Distinctness modulo p then proves the integer
norm is nonzero modulo p. Finite-field lifts and cyclotomic rings remain to be
integrated after these generic transport lemmas compile.

Additional uncompiled source drafts:
- restriction-level finite-free descent, retaining D² copies of the source;
- Vandermonde determinant scheme and normCofactor clearing via two adjugates;
- MonicQuotient: finite basis and constant-remainder projection splitting 1;
- existing PolynomialApproximation and PolynomialRestrictionDegeneration
  structures generalized to CommRing (field-only recovery remains scoped);
- same-structure polynomial degeneration power and exact extraction methods.

Toolchain migration is now being handled by the coordinator at the user's
request; the first queue request was interrupted during the old dependency
repair. No module in this status file has compiler evidence yet.

Verified compiler progress (rc4): the two original polynomial modules compile
after the CommRing generalization. Integral/Restriction also compiles, including
weighted direct sums and tensor-power local maps. FiniteFreeDescent's rank
lemmas passed elaboration; the restriction-level summation hit the default
heartbeat limit and is being rechecked with explicit binder types/local limit.

New source draft: FiniteFieldLift constructs a monic integral lift of a finite-
field power basis and the prime-avoiding clearing scheme. ConvolutionRank then
uses an ideal-span argument to select one finite Bezout family, proving a fixed
constant exact rank overhead for all integer convolution powers. These newer
modules are queued and NOT verified yet.
