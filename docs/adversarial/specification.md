# Adversarial specification and arithmetic-bridge review

Reviewed 2026-10-09 by a separate Codex agent. This is an AI source review,
not human peer review. The repository remained private; no external action
was taken. The agent did not start Lean, Lake, or another build process.

## Result and scope

**No specification weakening, hidden commutativity premise, reversed-input
product, cost omission, quantifier error, or infimum-vacuity problem was found
in the reviewed statement and arithmetic bridge.**

The inspected checkout had HEAD
`3ccd334c9c8025bae9d9f54bd0b07b3b73025a62` plus concurrent verification and
documentation work. The statement, model, and arithmetic bridge reviewed
below were already committed. This review does not independently audit every
integral separation, convolution, or spectral argument; those are separate
proof components and review assignments.

Read sources included `AllRings.lean`, `FinalAudit.lean`, `Model.lean`,
`Arithmetic/{Complexity,Programs,RecursiveBlockPrograms,Growth,LowerBound,
NaiveAlgorithm,Exponent}.lean`, `Polynomial/ExpressionFamily.lean`,
`AuxiliarySeparation/{Arithmetic/RankExponent,Integral/Arithmetic}.lean`,
the exact coefficient-tensor definitions, and both Comparator modules.

## Model preservation

An independent Python byte comparison read the original model directly from
Git baseline `45f5de13717ea1e3323730fccdd3ef58bd0c68b3`, counted exactly seven
occurrences of `[Field F]`, replaced those occurrences by `[Ring F]`, and
asserted equality with the entire current `Model.lean`. The assertion passed.
The separately read `scripts/check-specification.py` also passed, including
its frozen Challenge and configuration checks. No source edits were made to
obtain these outcomes.

The seven changes affect the assumptions for gate evaluation, program
evaluation, matrix-algorithm evaluation/correctness, admissibility, omega,
rectangular admissibility, and rectangular omega. Every other byte of the
model matches the baseline. In particular:

- Gates remain constant/input/add/sub/mul. Multiplication evaluates the first
  register times the second register in that order (`Model.lean:28–34`).
- Addition, subtraction, and multiplication each cost one; only input and
  constant loads cost zero (`Model.lean:36–41`).
- `Program.step` can read only earlier registers, so the object is a finite
  acyclic arithmetic computation (`Model.lean:45–60`).
- A program is correct only if its evaluation equals the usual matrix product
  for **every** input pair, not selected or generic inputs (`Model.lean:86`).
- `omega` remains the real infimum of the same admissible-exponent set
  (`Model.lean:94–99`). It is not replaced by an auxiliary rank exponent.

The baseline is the imported prior all-fields model. The comparison above is
not a new comparison against all of OpenAI's original repository; the import
provenance is recorded separately in `docs/IMPORT-MANIFEST.json`.

## Scope of the final statement

`AllRings.lean:61` quantifies over `(R : Type u) [Ring R] [Nontrivial R]`.
There is no surrounding section variable that contributes an additional
field, commutativity, characteristic, or coefficient-algebra premise. Lean's
`Ring` describes associative unital rings with additive inverses; it does
not impose commutative multiplication. Thus this statement includes
noncommutative rings and rings with zero divisors, but should not be described
as covering nonunital or nonassociative rings.

The direct cost theorem at `AllRings.lean:84` needs only `[Ring R]`, so it also
includes the zero ring. Excluding the zero ring from the exponent theorem is
appropriate: the preserved real-infimum model has no bounded-below
admissible-exponent set there. `FinalAudit.lean` separately instantiates the
theorem at `Matrix (Fin 2) (Fin 2) ℤ`, a concrete noncommutative ring.

The printed theorem in the existing successful build log also has exactly
the hypotheses above. This checks against a possible discrepancy between
the visible source and the elaborated declaration; see the evidence section.

## Exact integers, central constants, and multiplication order

The bridge uses exact integer coefficient identities. `Tensor.RankAtMost`
is the existence of three arrays whose rank-one sum equals the entire
coefficient tensor, coordinate by coordinate. It is not merely an equality
of polynomial functions on a finite input set. `exactRank` is the least
natural number satisfying that predicate, with a proved finite witness.
The independent Comparator `exact_coefficients` statement writes out the
matrix-product coordinates and integer rank-one sum literally, without
relying on a project-specific rank definition.

The noncommutative passage is in
`Arithmetic/RecursiveBlockPrograms.lean:269`,
`int_rank_bilinear_identity`. It starts with a coefficient identity over ℤ
and maps it into the target ring. Its local identity is

```text
w * (u * x) * (v * y) = (u*v*w) * x * y,
```

where `u,v,w` are integer casts. The proof uses associativity and
`Int.cast_comm v x`; its invocation of `ring` permutes only integer
coefficients inside ℤ. It never replaces `x*y` by `y*x` in the target ring.
The resulting formula is explicitly `sum j, left (i,j) * right (j,k)`.

`int_block_identity` preserves this order for matrix blocks, and
`int_algorithm_correct` uses that identity to prove the correctness of the
actual program. The older unrestricted-coefficient identity still requires
`CommRing F`; the all-rings bridge instead calls the new integer-coefficient
path. There is no attempt to infer a commutative instance for arbitrary `R`.

As a separate boundary check, the scalar program loads the left input,
loads the right input, and uses `.mul 1 0`. Because the newest register has
index zero, this is the desired left-times-right product, not its reverse.

## Cost and exponent bookkeeping

The construction retains the original arithmetic accounting:

- `LinearExpression.linear` actually emits a multiplication by each fixed
  coefficient and an addition for each term. `cost_linear` gives twice the
  number of terms, so scalar multiplication has not become free.
- `int_rank_block_step` returns a correct program with cost
  `r * P.cost + 2*r*(n₁*n₂*m₁*m₂ + n₂*n₃*m₂*m₃ + n₁*n₃*m₁*m₃)`.
- For square blocks this is `r * P.cost + 6*r*n²*m²`, the expression used in
  `Growth.admissibleExponent_of_int_rankAtMost`.
- The base program costs one. The growth argument pays the quadratic work,
  uses positive exponent slack, and applies the proved padding theorem to
  cover every positive matrix size.

`admissibleExponent_of_int_rank_bounds` first selects one integer scheme at
slack `ε/2`, then allocates `ε/2` to the recurrence. The chosen block, rank,
and coefficients are fixed before the final matrix size varies. This does
not obtain its bound by changing an overhead constant with the input size.

`Integral/Arithmetic.exactRankExponent_int_admissible` proves actual
admissibility of `exactRankExponent ℤ`; it does not assume the desired
numerical bound or the final ring theorem. `AllRings.lean` then supplies
the independently proved integer exponent bound. The dependency direction
does not appear circular in the inspected source.

## Quantifiers and nonvacuity

The direct operation-count statement has the order

```text
forall R, forall ε > 0, exists C > 0,
forall n >= 1, exists P, P.Correct and cost(P) <= C*n^(9/4+ε).
```

`P.Correct` universally quantifies both input matrices. Thus `C` is fixed
for all matrix sizes, while the program may depend on size. The constant
and family may depend on the ring and positive slack, as the statement says.

Both infima used by the proof have substantive side conditions:

- The arithmetic admissible set is nonempty: `NaiveAlgorithm.lean:86`
  proves exponent three by an explicit program of cost `2*n³`.
- For any nontrivial ring, `LowerBound.lean` uses elementary 0/1 matrices to
  show outputs require distinct arithmetic-producing registers and hence
  cost at least `n²`. It derives every admissible exponent being at least
  two, giving `BddBelow` and the usual lower bound on `omega`.
- `omega_le_of_admissibleExponent` invokes `csInf_le` with that boundedness
  proof. `omega_two_le` uses the independently proved nonemptiness.
- The exact-rank exponent set has a concrete size-two element, quadratic
  lower bounds, and finite cubic upper bounds. The scheme selected from a
  strict upper bound on its infimum is an actual finite integer scheme;
  no attainment of the infimum is assumed.

The direct epsilon theorem supplies a second formulation that does not
depend on interpreting `sInf` at all. The result remains an existence claim
for arithmetic-program families. It does not formally assert an effective
uniform generator, an `O(n^(9/4))` endpoint algorithm, bounded bit complexity,
or practical constants. Integer constants are unit-cost loads in the
preserved model, irrespective of their binary lengths.

## Evidence and limitations

Read the existing serialized-worker record
`.lake/ring-queue/1791557812451628000-2aa7a8.json` and its log. It records
`FinalAudit` and `OAI`, exit code zero, no source files changed during that
build, and successful completion of the 9175-job dependency graph. The log
prints the elaborated ring statement and the model definitions; its six
axiom reports contain only `propext`, `Classical.choice`, and `Quot.sound`.
This agent inspected that evidence but did not rerun the compiler.

The Comparator configuration names six claims, permits only those standard
axioms, and has no definition holes. `Challenge.lean` deliberately contains
specification holes; source searches found no import of it in OAI or the
solution. No `sorry`, `admit`, custom axiom, or `native_decide` was found in
the targeted final, arithmetic, and integral source files inspected here.
These static observations do not replace a complete transitive axiom audit,
fresh-kernel replay, or successful Comparator run. Those runs belong to the
coordinator's final verification record, not this review.

At review time the main README and `docs/STATUS.md` still described earlier
unfinished assembly work. They should be reconciled with the eventual final
verification results before reporting the repository complete. This is a
documentation synchronization item, not a defect in the reviewed theorem.

### Reviewed source hashes (SHA-256)

Paths in this table are relative to `lean/OAI/LinearAlgebra/MatrixMultiplication/`
unless written with a leading `lean/`.

| File | SHA-256 |
| --- | --- |
| `Model.lean` | `e98d51cf7cf83e7b7fa048b3d3b1a2bb4489d873c6c322be2c68b33802311a8d` |
| `AllRings.lean` | `5e7ea92b02eaef2dd98e97153ed1a3777bc65115cd86715a551968ee2af0eeee` |
| `FinalAudit.lean` | `b2da6e7747fb702a89b06cfce69dac78ac1ca9bfcebb8805af09619fda9d0d14` |
| `Arithmetic/RecursiveBlockPrograms.lean` | `ab16e7f6e50d7b3474e2170991677f05be5431f0fe17043d742f3eae48b9b33c` |
| `Arithmetic/Growth.lean` | `2a944e55976b1e6979441d60eb2f63f1baea64dedce54392700610519d3c0515` |
| `AuxiliarySeparation/Integral/Arithmetic.lean` | `3eee5184072cd4fc692942a77d33bfe0bdfeed20c566ac47dfd9a758f098da2e` |
| `lean/ComparatorAudit/Challenge.lean` | `1a0e162d1a5c259bf08c5b0a57475319df31fabd19c3a16e3c9d1f302b0f5e71` |
| `lean/ComparatorAudit/Solution.lean` | `81d09fd95f690322fa1f7bda9cec45a8a35f38e2bf7137244f509ff887e5e452` |
