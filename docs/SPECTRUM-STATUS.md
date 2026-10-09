# Integral spectral detection port

**Final coordinator update (2026-10-09):** the full ring theorem, fresh-kernel
replay, Comparator, and both failure controls passed. See [STATUS.md](STATUS.md)
and the [verification receipt](../verification/comparator/RESULTS.md).
The chronological notes below preserve earlier work stages; their pending
descriptions are superseded by that final evidence.

Owner: ring_spectrum. Status: full primitive spectral detection and division-free
character transport compiled successfully. Final 9/4 theorem remains separate.

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


## Verified milestones (Lean 4.35.0-rc4)

The following modules successfully compiled in the serialized queue:

- Generic matrix identity-minor lower bound and exact rank exponent.
- Tensor semiring, scalar rank, total character interface and conversions.
- Entire catalytic obstruction, generic normalized-state/convex machinery.
- `Tensor.Primitive`: zero-or-unit-dominating subsemiring and the full
  `phi(T+1)-1` semiring-hom extension with monotonicity and nonnegativity.
- `Tensor.PrimitiveClass`: primitive matrix classes and the negative control
  that scalar 2 over integers does not dominate scalar 1.
- `Tensor.SixfoldProductBounds`: coefficient-one positivity over coefficient
  semirings and retained field-only nonzero wrappers.
- `Integral.CharacterTransport` (request `1791557001818588000-fef322`):
  coefficient-extraction degeneration monotonicity over CommRing,
  quadratic-overhead removal, binary coefficient patch for unrelated source
  coordinate types, and coprime-power character comparison. No character is
  applied to a scalar-multiplied target before the coefficient patch.

`Character.Existence` retry `1791557165907216000-7dffc1` is pending after
repairing the explicit coercion of a primitive catalytic comparison into the
full tensor semiring. The whole theorem must not yet be called verified.

New `Integral.ConvolutionCharacter` drafts the sharp value/profile bounds from
`convolution_integer_power_rank`; initial request failed in its dependency
`Integral.ResidueBasis` before elaborating this new module. The transport
owner is repairing that dependency.


## Full spectral success

Request `1791557165907216000-7dffc1` completed successfully (9075 jobs).
`exists_detecting_character` now compiles for `[CommSemiring K] [Nontrivial K]`,
including K = integers. The primitive subsemiring, stabilization extension,
ordinary exact rank exponent, and catalytic obstruction are all included.
No mathematical gap was encountered; compiler repairs concerned universe and
subtype-order elaboration. No proof holes or custom axioms were added.

An explicit integer specialization and axiom checks are now in
`Integral/SpectrumAudit.lean`, request `1791557271724071000-736fb2` PASSED.
Its integer specialization, stabilization extension, scalar-2 negative control,
ring degeneration monotonicity, and coprime scaled-restriction patch all report
exactly `[propext, Classical.choice, Quot.sound]`.
The final all-rings 9/4 bound is not asserted by this audit module.


## Integral convolution frontier

Transport request `1791557437577360000-2d19ff` verified the fixed-overhead
integer convolution power-rank bound. The new `Integral.ConvolutionCharacter`
wrapper was submitted as `1791557503201765000-181ae6` to remove that fixed
overhead and feed the sharp value bound into the normalized profile.

`Integral.ConvolutionCharacter` request `1791557503201765000-181ae6` PASSED
(3362 jobs). Both the sharp integer convolution value and normalized-profile
bounds are now compiler-verified. The read-only mathematical review of root
finite-separation sources is in `docs/FINITE-SEPARATION-AUDIT.md`.


## Final verification harness

ComparatorAudit Challenge/Solution/KernelAudit and frozen specification scripts
are drafted. Model is byte-identical to baseline 45f5de1 after exactly seven
Field-to-Ring substitutions. Read-only source dependency validation passed for
all nine frozen Git packages. Queue 1791557832666381000-053bf2 requests Challenge
and KernelAudit. Native Comparator, negative controls, and fresh kernel replay
remain coordinator-run obligations. Commands and scope are documented in
verification/comparator/README.md.
