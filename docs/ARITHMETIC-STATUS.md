# Arithmetic and analytic endgame

2026-10-09. All arithmetic and generic analytic modules assigned to this agent
have passed target builds on Lean 4.35.0-rc4. The final `AllRings.lean` assembly
and `FinalAudit.lean` are drafted and queued as `1791557571747002000-a5404e`.
Their build still depends on the coordinator's integral separation proof.
Do not treat the final numerical theorem as checked until that build passes.

## Unchanged specification

`Model.lean` differs from its inherited version by exactly seven `Field` →
`Ring` typeclass substitutions. Defining equations, gate costs, correctness
quantifiers, positive exponent slack, and the infimum are unchanged. Constants
and inputs cost zero; addition, subtraction, and multiplication cost one.
Correctness quantifies over all pairs of input matrices.

The lower-bound proof uses only `0 ≠ 1`. The admissible-exponent set is bounded
below by 2 for every nontrivial ring, and its infimum is at least 2. Nontriviality
is needed here: the zero ring does not have a meaningful bounded-below exponent
set. The direct operation-count theorem includes the zero ring.

The final scalar variable is `R`, as requested. Existing auxiliary identifiers
retain old names to keep the model diff small.

## Integer schemes over noncommutative rings

`Arithmetic/RecursiveBlockPrograms.lean` keeps the legacy coefficient-rank
bridge under `CommRing`. Its new integer bridge expands each output as

```
sum_q c_q (sum_x a_qx left_x) (sum_y b_qy right_y).
```

All coefficients are integers cast into the target ring. `Int.cast_comm` moves
only an integer coefficient past an input; no step interchanges the left and
right input values. The result is

```
sum_x sum_y (sum_q a_qx b_qy c_q) left_x right_y.
```

The exact integer tensor identity reduces the inner sum to the matrix
multiplication coefficients, zero or one. This is coefficient reasoning, not
inference from equality of polynomial functions on a finite ring.

The same block program, compiler, padding, and cost recurrence apply. The
square block overhead remains `6 * rank * blockSize^2 * innerSize^2`.
`Arithmetic.admissibleExponent_of_int_rank_bounds` selects a finite scheme at
slack ε/2 and applies recursion at another ε/2, yielding the required ε and
one constant for all matrix sizes. It does not assert exact O(n^(9/4)) cost.

`Integral/Arithmetic.lean` proves, without a numerical assumption:

```
Integral.omega_le_exactRankExponent_int (R) [Ring R] [Nontrivial R] :
  Arithmetic.omega R <= exactRankExponent Int
```

It also gives the direct positive-slack circuit-cost theorem for every ring.
The numerical ingredient is supplied separately in `AllRings.lean`.

## Generic character endgame

Character, convolution, and normalized-profile modules now work over the
appropriate commutative semiring/ring. Positivity uses an explicit coefficient
one, rather than the invalid assertion that every nonzero integer tensor
restricts to the unit. Legacy field wrappers remain available.

Entropy/Tag, Tensor/SharedPadding, and Tensor/TagInequality provide generic
positive-value and coefficient-one tag bounds. Determinant/Character and
Sector/Character use the division-free polynomial-degeneration character
comparison, with explicit coefficient-one branch witnesses.

The generic endpoint is
`Character.exponent_sum_le_nine_quarters_of_separation_and_convolution`.
Its two assumptions remain explicit: finite separation for all characters,
and `chi(convolution a b) <= a+b-1` for all characters. `AllRings.lean`
discharges them with `Integral.finiteSeparation_bound_int` and
`Character.value_convolution_le_int`, then uses detecting characters and
integer rounding to bound the integer rank exponent. No new class or axiom
hides either obligation.

## Compiler evidence

All builds use the serialized queue. Successful request IDs:

- `1791556206499286000-a85055`: RecursiveBlockPrograms, Growth,
  Integral.Arithmetic; core Model, Exponent, LowerBound, compiler, naive
  algorithm and padding passed in its preceding request.
- `1791556544880997000-93de23`: generic CharacterRounding.
- `1791556877119393000-98a61f`: SharedPadding and TagInequality.
- `1791556924274633000-804b24`: normalized profiles, convolution symmetry,
  TagInequality and dependencies.
- `1791557195516484000-76907f`: Determinant.Character and Sector.Character.
- `1791557237379643000-9d5c82`: generic Polynomial.Inequalities endpoint.

Early dependency-copy failures were setup failures, not Lean proof errors.
The coordinator repaired the pinned rc4 cache and replaced the inherited
`.lake/packages` symlink with an independent physical directory. The active
build environment is isolated inside this repository.

## Final audit scope

`FinalAudit.lean` checks the exact Ring + Nontrivial theorem type, BddBelow,
the lower bound, the explicit direct-cost correctness quantifiers, and a
concrete coefficient ring `Matrix (Fin 2) (Fin 2) Int` to catch hidden
commutativity hypotheses. It prints the model definitions and transitive
axioms. Fresh-kernel and Comparator harnesses are owned by the spectrum agent.
