# Arithmetic ring port

2026-10-09. Work in progress. Ring model, program/compiler, padding, naive
algorithm, nontrivial-ring lower bounds, and arithmetic exponent compiled
on Lean 4.35.0-rc4. Full integer-to-ring bridge retry is queued. Generic
entropy tag bounds compiled; profile modules have a dependency-scope repair
queued. The final 9/4 theorem is not yet established.

The existing `Model` and arithmetic program/compiler definitions now use `Ring`
instead of `Field`. Their defining equations, gate costs, and quantifiers are
unchanged. The output-count lower bounds use `Nontrivial`; the naive upper
bound applies even to the zero ring.

The existing arbitrary-coefficient tensor-rank bridge is retained under
`CommRing`. Integer-coefficient correctness and recursion over arbitrary
associative rings are implemented but await compilation. The final interface
`admissibleExponent_of_int_rank_bounds` consumes exact integer rank schemes
with arbitrary positive slack and preserves the original cost definition.

Build requested: `OAI.LinearAlgebra.MatrixMultiplication.Arithmetic.Exponent`,
then `OAI.LinearAlgebra.MatrixMultiplication.Arithmetic.Growth`.
Only the root coordinator starts builds.

Initial build attempt did not reach Lean sources: the copied mathlib checkout
was at a different revision from the manifest, and Git could not fetch a
missing promisor object without network access. The coordinator is restoring
the pinned dependency cache. This is not evidence about source correctness.

The `Model.lean` diff is exactly seven `Field` → `Ring` typeclass substitutions.
For the final declaration the scalar type must be named `R`, per Sela's
explicit preference. Existing auxiliary identifiers retain their old names.

## Source-level review of the noncommutative bridge

The new proof expands each output as

```
sum_q c_q (sum_x a_qx left_x) (sum_y b_qy right_y).
```

All `a`, `b`, and `c` are integer coefficients cast into the target ring.
`Int.cast_comm` moves only an integer coefficient past an input value.
No step interchanges `left_x` and `right_y`. The expression becomes

```
sum_x sum_y (sum_q a_qx b_qy c_q) left_x right_y.
```

The exact integer tensor identity reduces the inner sum to the matrix
multiplication coefficients, 0 or 1. This is coefficient reasoning, not
inference from equality of polynomial functions on a finite ring.

The existing block program, expression compiler, and operation-count
calculation are reused. Thus the recursion has the same overhead
`6 * rank * blockSize^2 * innerSize^2` in the square case. The only changed
correctness proof is the integral identity above. The abstract geometric
recurrence and padding arguments then apply without a commutativity premise.

`admissibleExponent_of_int_rank_bounds` deliberately includes a second
positive-slack application: choose the fixed integer scheme at epsilon/2,
then obtain programs from recursion at another epsilon/2. The resulting
exponent is exactly the requested `tau + epsilon`, with one constant for
all matrix sizes. No exact O(n^(9/4)) assertion is made.

The zero ring is allowed in this operation-count bridge. Nontriviality is
required only when deriving a meaningful infimum exponent and its lower
bound from distinct output functions.

## Final integration interface

`AuxiliarySeparation/Integral/Arithmetic.lean` now contains an unconditional
bridge, still awaiting compilation:

```
Integral.omega_le_exactRankExponent_int (R) [Ring R] [Nontrivial R] :
  Arithmetic.omega R <= exactRankExponent Int
```

It also exposes the direct positive-slack operation-count statement for every
ring. The only missing numerical ingredient for the final result is the
independently proved integral inequality `exactRankExponent Int <= 9/4`.

## Generic profile and entropy modules

The root's drafts of Character/{Dot,Permutation,Symmetrization},
Convolution/{Basic,Symmetry}, and Growth/NormalizedProfile are now assigned
to this agent for compilation and repair. Their positivity arguments select
a coefficient equal to one; the old field-only nonzero-tensor wrappers remain.

Entropy/Tag now also exposes generic `..._of_value_pos` and
`..._of_coefficient_one` versions of both logarithmic and geometric-mean
integral-type tag bounds. Existing field theorem statements are retained.

Lean 4.35.0-rc4 and its compatible pinned mathlib cache are now in use per the
user's request. Arithmetic and profile/entropy module checks have been
submitted to the serialized queue. No successful check is yet recorded here.

## Compiler evidence (rc4)

Queue request `1791555995654232000-2735df` successfully built Model,
Arithmetic/Complexity, LowerBound, Programs, ProgramComposition, Padding,
NaiveAlgorithm, Exponent, and Polynomial/ExpressionFamily. In particular,
`admissibleExponent_bddBelow` and `omega_two_le` now compile for nontrivial
rings with the original operation model.

RecursiveBlockPrograms reported only three instance-scope errors in legacy
CommRing correctness lemmas: they still referenced the outer Ring instance.
The new integer bilinear identity emitted no errors in that compilation, but
the module as a whole was not accepted. Ring and CommRing scopes have now
been separated, with retry `1791556206499286000-a85055` pending.

The first profile/entropy request built the generic Entropy.Tag, including all
four new positivity/coefficient-one variants. Its failure was in downstream
symmetrization, because the prior Convolution.Basic artifact still carried
unneeded Nontrivial premises. Those premises are now scoped to actual
nonzero/equivalence lemmas; the source-output coefficient-one construction is
generic. A fresh profile request will compile that consistent source state.

CharacterRounding is now generic over CommSemiring; only the final theorem
mentioning `exactRankExponent` needs Nontrivial. Its conditional character
hypotheses remain explicit. ExponentComparison was inspected and is already
purely real-analytic, so it needed no change. CharacterRounding compilation
is queued.
