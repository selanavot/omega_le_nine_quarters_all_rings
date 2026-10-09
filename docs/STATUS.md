# Status

2026-10-09. Repository and draft PR #1 are PRIVATE. Branch: prove-all-rings.
https://github.com/selanavot/omega_le_nine_quarters_all_rings/pull/1

**The ring 9/4 theorem is not yet verified end-to-end.**

Target: `omega_le_nine_quarters_all_rings (R : Type u) [Ring R] [Nontrivial R]`.
Lean 4.35.0-rc4 and mathlib f0469b25d97aef3998d4bc06f6f01da670b3d18e
are installed and pinned. The checkout has independent physical dependencies.

## Confirmed compiler evidence

- Ring arithmetic model, programs, naive bound, output-count lower bound,
  BddBelow, and omega >= 2. The model has only seven Field -> Ring changes.
- Integer coefficient identities produce recursive arithmetic programs over
  arbitrary rings; the unconditional bridge omega(R) <= exactRankExponent(Z)
  is checked, including ordered products for noncommutative rings.
- Primitive tensor subsemiring, character extension, and detecting characters
  for integer exact rank. Negative control excludes scalar-2 -> scalar-1 over Z.
- Coefficient extraction, finite free rank/restriction descent, monic quotient
  projection, Vandermonde norm clearing, finite field lift, and finite Bezout
  patch. The complete convolution power rank and character bound compile.
- Cyclotomic algebra/unit/basis/projection; unnormalized Fourier sum;
  polynomial separation construction; integer restriction descent compile.
- Generic determinant/sector/tag/profile argument compiles: explicit separation
  and convolution assumptions imply each character exponent sum <= 9/4.
- SpectrumAudit and TransportAudit report only propext, Classical.choice,
  and Quot.sound for the audited intermediate declarations.

## Remaining

- Integral finite-separation assembly (consecutive periods, descent, coprime
  powers and polynomial overhead): compiler repair in progress.
- AllRings and FinalAudit drafted; awaiting that last dependency and checks.
- Comparator with frozen definitions and negative controls, full build and
  fresh kernel replay remain. Manuscript and PDF are being prepared.

Build requests/logs are ignored under .lake/ring-queue. Only root runs the
worker. Owner details are in ARITHMETIC/SPECTRUM/TRANSPORT-STATUS.md.
