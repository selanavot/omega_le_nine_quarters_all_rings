# Status

2026-10-09. Repository and PR #1 are PRIVATE. Branch: prove-all-rings.
https://github.com/selanavot/omega_le_nine_quarters_all_rings/pull/1

**The ring 9/4 theorem is not yet verified or implemented end-to-end.**

Target: `omega_le_nine_quarters_all_rings (R : Type u) [Ring R] [Nontrivial R]`.
Lean 4.35.0-rc4 and mathlib f0469b25d97aef3998d4bc06f6f01da670b3d18e
were selected at Sela's request to use current Lean. Both are installed/cached.
The new checkout now has its own physical dependency copy; inherited shared
cache links were removed, and the prior shared cache's pins/oleans restored.

## Confirmed compiler evidence

- Ring Model, arithmetic programs/composition/padding, naive bound, output-count
  lower bound, and Arithmetic.Exponent compile. BddBelow and omega >= 2 retain
  nontriviality.
- Arithmetic.RecursiveBlockPrograms, Growth, and Integral.Arithmetic compile.
  The unconditional bridge `omega R <= exactRankExponent Z` is checked, including
  central integer coefficients and ordered noncommutative products. Queue a85055.
- Generic exact tensor rank/exponent and matrix rank lower bound compile.
- Generalized original polynomial approximation/degeneration structures compile.
- Integral.Restriction, FiniteFreeDescent and MonicQuotient compile.
- Generic Entropy.Tag compiles.

These are foundations, NOT verification of the 9/4 result.

## Work in progress

- Primitive tensor spectrum/detecting-character layer: source drafted; compiler
  repair in progress. Negative control rejects scalar-2 -> scalar-1 over Z.
- Integral coefficient extraction, Vandermonde/norm clearing, finite field lifts,
  Bezout patching: source drafted; compiler repair in progress.
- Cyclotomic units, unnormalized Fourier, polynomial local maps and determinant
  basis over rings: source drafted; awaiting/repairing compiler checks.
- Character comparison/profile integration, full integer exponent bound, final
  ring theorem, clean kernel/Comparator audits and paper remain unfinished.

All requests/logs live under ignored .lake/ring-queue. Only root starts the
worker; agents submit/status. Separate ARITHMETIC/SPECTRUM/TRANSPORT status files
have owner-level details. Imported provenance is in IMPORT-MANIFEST.json.
