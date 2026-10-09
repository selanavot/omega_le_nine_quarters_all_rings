# Integral spectral detection port

Owner: ring_spectrum. Status: drafted; compilation pending dependency cache setup.

## Implemented source

- Generalized identity-minor rank lower bounds to nontrivial commutative semirings,
  using the strong rank condition instead of field matrix rank.
- Generalized exact rank, its matrix exponent, tensor restriction quotient,
  scalar rank, and class-to-character conversion to that same coefficient scope.
- Retained field-only nonzero/faithfulness lemmas in separate sections.
- Added generic zero-or-unit-dominating subsemiring, and the extension
  `phi(T+1)-1` from its real-valued characters to the full tensor semiring.
- Added primitive matrix classes and ported detecting-character construction
  to that subsemiring. Generic spectral state/cone machinery is unchanged.
- Added coefficient-one positivity lemmas for total characters and sixfold
  products. Existing field clients may still use their old nonzero lemmas.

## Important distinction

The extended character need not be faithful on arbitrary integral tensors.
`T != 0` is not sufficient for value >= 1 over integers. All new profile
positivity calls must supply a coefficient-one or actual unit-restriction witness.
The underlying rank and order remain ordinary exact tensor coefficient rank and
integral linear restriction. No new axioms or proof holes have been inserted.

## Compiler requests

- Tensor.Characters: 1791555389110406000-30d17f
- Tensor.Primitive: 1791555444572003000-25893a

Both were submitted before the dependency-cache repair notice. Further requests
await root's indication that the pinned cache is ready. No compiler success yet.

## Cache and toolchain update

The two initial requests failed before elaborating project code because pinned
Git dependencies could not be fetched in the initial sandboxed worker. The root
coordinator repaired network/cache access, then received the user's explicit
instruction to upgrade Lean. Compilation is now paused for the toolchain and
compatible Mathlib refresh. These infrastructure failures provide no Lean proof
validation or invalidation. Additional drafted modules are `Tensor.PrimitiveClass`
and the generalized `Character.Existence` theorem.

## Current verification target

Root reports cache ready on Lean 4.35.0-rc4 and Mathlib f0469b25.
Submitted queue request `1791555996076949000-a55339` for:

- `OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Character.Existence`
- `OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Tensor.SixfoldProductBounds`

These cover the primitive spectral construction and coefficient-one positivity.
Compilation is queued; no successful result claimed yet.
