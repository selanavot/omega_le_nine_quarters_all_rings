# Adversarial mathematical audit

Date: 2026-10-09. Reviewer: Codex agent `beame_scope_review`, independently
assigned within the development team. This is AI source review, not human
peer review or an independent proof kernel.

## Outcome and scope

**No blocking mathematical defect or theorem-meaning mismatch was found in
the reviewed integral extension.** The difficult quantifier orders and the
distinction between coefficient scaling and direct-sum copies are explicit
in the actual Lean statements. The reviewed manuscript matches those
statements and retains the positive-exponent-slack and arithmetic-model
limitations.

I read the actual source of the primitive spectral extension, detecting
character entry point and catalytic use, coefficient extraction, finite-free
rank and restriction descent, monic projection, finite-field lift and norm
specialization, convolution patch, cyclotomic/Fourier separation, finite
separation limit, final rank-to-arithmetic bridge, and `AllRings.lean`, plus
the complete `paper/paper.tex`. I also inspected the ordered-input integer
bilinear identity and its recursive-program use. I did not start Lean or
Lake, modify proof sources, or take external actions. Compilation, axiom
audits, full dependency verification, and fresh kernel/Comparator execution
remain the coordinator's separate evidence.

The base commit when this review began was `3ccd334`. The worktree contained
concurrent documentation, paper, and verification changes. The evidence below
therefore names declarations, rather than treating that commit as the exact
snapshot of every reviewed file.

## Checks and attempted failure modes

### 1. Integral spectrum does not import false field positivity

Over the integers the scalar tensor with coefficient 2 cannot restrict to
the unit tensor: this would give `2abc = 1`. The code explicitly proves this
negative control in
`Tensor/PrimitiveClass.lean:integer_scalar_two_not_unit_dominating`.

`Tensor/Primitive.lean:subsemiring` instead contains zero and classes
dominating the unit. It is closed under addition and multiplication.
Every `x + 1` belongs to it, so the extension

`extend φ x = φ (x + 1) - 1`

is defined for every tensor class. The proofs of additivity and
multiplicativity use equalities after adjoining copies of the unit and
cancellation in the real codomain; they do not assume cancellation in the
tensor semiring. Monotonicity comes from adding the same unit, and
nonnegativity from `1 ≤ x + 1`. The extension agrees with the original
character on the primitive domain.

`Character/Existence.lean:exists_detecting_character` actually invokes the
normalized-state construction on `PrimitiveClass`, not on the full tensor
semiring. The nonzero-catalyst branch supplies an actual `1 ≤ s` witness to
`tensor_catalytic_obstruction_of_scalar_gain_of_one_le`. The zero-catalyst
branch uses `not_tensor_add_positive_nat_le_self`, whose iteration argument
needs monotonicity and exact rank of diagonal tensors, not false additivity
of tensor rank. The final character has the original `Character` interface;
it is not assumed to be faithful on arbitrary nonzero integer tensors.

### 2. Finite-free descent retains the source and charges D² only once

`Integral/FiniteFreeDescent.lean:RankAtMost.project_finite_basis` expands the
first two coefficients in a fixed basis and absorbs the third coefficient
through `π(e_i e_j c)`. This gives D² terms, rather than requiring an algebra
homomorphism from the extension back to the base.

The needed hypothesis `π 1 = 1` is explicit. It is not asserted for every
finite algebra over a ring. `Integral/MonicQuotient.lean` supplies it by
taking the constant coefficient of the unique monic remainder, with the
positive-degree condition checked. The cyclotomic and finite-field-lift
applications both use such monic quotients.

`descend_finite_basis_powers` powers one fixed algebra-valued decomposition
before descending, yielding `r^k * D * D`. The restriction analogue
`Integral/RestrictionDescent.lean:descend_restriction_basis` preserves D²
copies of the original source tensor, rather than merely bounding the
target by an unrelated rank. `scalar_power_restriction_descend` uses this
restriction-level result after extraction. No D^(2k) overhead was silently
dropped.

### 3. Coefficient extraction is genuinely division-free

`Integral/CoefficientExtraction.lean:coeff_mul_mul_bounded` expands the
first two local polynomial maps and reads the remaining coefficient from
the third. `shiftedCoeff` explicitly returns zero when the remaining degree
would be negative. This guards against a genuine possible mistake from
truncated natural subtraction.

`restrict_coefficient` retains `(a+1)(b+1)` copies of the source. The
`PolynomialRestrictionDegeneration.power` construction factors out `X^h`
using vanishing below the leading coefficient and produces degree bounds
linear in k. It does not use field interpolation, cancellation of a
nonunit, or the assertion that arbitrary coefficients commute with
noncommutative input values. All coefficient algebras at this stage are
commutative. Thus extraction of powers costs only a quadratic polynomial
in k.

### 4. The convolution prime witnesses give one finite family before k

`Integral/FiniteFieldLift.lean:exists_integral_powerBasis_lift` specializes a
whole integral basis to the prescribed finite-field basis. This is stronger
than merely having a quotient map to a field, which would not suffice to
identify the norm modulo p.

`Integral/Vandermonde.lean` applies adjugates twice: first to obtain a scheme
for the Vandermonde determinant times convolution, then to multiplication
by that determinant to obtain its integer norm as multiplier. No inverse
of either determinant is used. `Integral/ResidueBasis.lean` proves
specialization of the full multiplication matrix and its determinant. The
distinct residue nodes make the norm nonzero modulo the chosen prime.

The resulting declaration has quantifiers

`∀ prime p, ∃ D d, p ∤ D ∧ d > 0 ∧ ∀ k, rank(D^k C^⊗k) ≤ h^k d²`.

In `Integral/ConvolutionRank.lean:convolution_integer_power_rank`, the set
of usable D is defined with the entire `∀ k` property inside membership.
The ideal/prime-divisor argument extracts a finite set of those D and
their algebras once. Only then is k introduced. `exists_bezout_powers`
allows the Bezout coefficients to vary with k without changing that finite
family or the rank overhead `Σ d_j²`. Hence the proved claim is one fixed
constant times h^k; it does not interchange `∀ k ∃ family` with
`∃ family ∀ k`. The argument includes p = 2 and imposes no large-prime
assumption. Boundary convolution sizes are handled by the Lean statement;
the paper restricts its presentation to positive a and b.

### 5. Fourier multipliers are patched before applying characters

`Integral/Cyclotomic.lean` uses the actual integral cyclotomic quotient, its
domain structure, a primitive root as a unit, and its finite free basis.
`Integral/UnnormalizedFourier.lean` proves the geometric sum without
division by the period. Cancellation of `1-z` occurs in this cyclotomic
domain, not in an arbitrary target ring.

`Integral/SeparationPolynomial.lean:integralSeparationDegeneration` has
source **q direct-sum copies** of the shared tensor and target **q times
the coefficients** of the separated tensor. These are different objects
in the actual types and maps. The weight construction shifts two local
degrees by M², placing the target at degree 2M²; the no-wrap and
leading-coefficient proofs identify exactly the intended target.

`separation_scalar_power_restrictions` chooses local degree bounds before
the tensor-power variable. `value_separationTarget_le_int` separately
instantiates q = 5M and q = 5M+1. It combines their integer restrictions
using `value_le_add_of_coprime_scaled_restrictions` and the Bezout identity
for their powers. Characters are applied to this patched identity; there
is no invalid cancellation of χ(qT), and no treatment of coefficient
scaling as q copies.

The source factors q^k remain in the bound. They yield the larger period
5M+1 after taking roots, while finite-algebra dimensions and quadratic
degree costs disappear. The final estimate is therefore genuinely
`χ(B) ≤ 6M χ(A)`, not `χ(B) ≤ χ(A)`. The subsequent profile interface
explicitly accepts the constant 6. The proof fixes M and both algebras
before this inner power limit; it needs no uniform bound when the outer
sector count later grows.

### 6. The final theorem states arithmetic multiplication over rings

`AllRings.lean:exactRankExponent_int_le_nine_quarters` fills both inputs to
the character-to-rank implication with proved detecting characters and
proved integral convolution/separation. The integer rank exponent is
defined from exact coefficient decompositions of the usual matrix tensor;
it is not a renamed assumed upper bound or a functional identity modulo a
chosen prime. Its finite-size exponent set is nonempty and bounded below.

`Arithmetic/RecursiveBlockPrograms.lean:int_rank_bilinear_identity`
commutes integer constants with ring inputs but preserves the order of a
left input followed by a right input. `int_rank_block_step` applies that
identity to matrix blocks and counts linear-combination work. This is the
necessary argument for noncommutative rings; merely casting a commutative
polynomial identity would not have been enough. The growth bridge uses
this ordered identity and the original program operations.

The final signatures are unconditionally `[Ring R] [Nontrivial R]` for
the infimum bound and `[Ring R]` for direct positive-slack operation counts.
Inspection of `Model.lean` confirms actual matrix product correctness on
all pairs of inputs and unit costs for add/sub/mul. The bound is
`∀ ε>0, ∃ C>0, ∀ n≥1, ∃ program`, not an attained endpoint or a uniform
generator theorem.

## Manuscript assessment and remaining limits

The manuscript explains the same critical distinctions: primitive spectral
objects; finite free rather than arbitrary finite algebras; powers before
descent; the finite prime-witness family fixed before k; and coefficient
multipliers patched before characters. Its arithmetic-ring statement
matches `AllRings.lean`. I found no mathematical correction to request in
the reviewed version.

This audit does not independently re-prove every inherited compactness,
fixed-point, determinant, sector, or real-profile lemma; those remain in
the imported proof and kernel trust chain. It does not establish historical
novelty, practical algorithms, a computable/efficient circuit generator,
bit complexity, or an O(n^(9/4)) endpoint. It also is not a fresh build or
a source-to-binary provenance check. The coordinator should retain the
separate complete audit, kernel replay, and Comparator records before
describing those checks as passed.

Selected SHA-256 snapshot anchors (at review):

```text
73622f0ab4f25665067490bbced2820b5db49e875ba2a2494cd17be9b18bb39a  paper/paper.tex
5e7ea92b02eaef2dd98e97153ed1a3777bc65115cd86715a551968ee2af0eeee  AllRings.lean
53b8d64ea9598a76a6e91adb221a0d358fcc05f90849db4a6784577e6ed1b5e3  Integral/FiniteSeparation.lean
bc3ee55360f196f18d70e3c343aa2edf742ce994b1c6b70a48d274db29aca61e  Integral/ConvolutionRank.lean
7cdd460c7f52b44edbf828e0ce45df9639dc01ff9caf64f7836d8d13f93a8947  Tensor/Primitive.lean
```
