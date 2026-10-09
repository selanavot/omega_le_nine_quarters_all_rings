# Matrix multiplication: ω ≤ 9/4 over every nontrivial ring

OpenAI proved ω ≤ 9/4 over the complex numbers in its
[matrix multiplication preprint](https://github.com/openai/math/blob/adc7f1241b42e322a6451854ab7e4b4c146bf78a/preprints/Matrix-Multiplication-Nine-Fourths-October-2-2026/paper.pdf).
Our [earlier all-fields extension](https://github.com/selanavot/matrix-multiplication-all-fields)
establishes the same bound over every field.
This private repository extends the result to arbitrary associative unital
rings, including noncommutative rings.
The full theorem compiles in Lean. Independent verification is in progress;
see [current status](docs/STATUS.md).

**Both the extension's Lean proof development and the [paper](paper/paper.pdf)
are AI-generated with Codex under human direction.** The numerical exponent
and main proof architecture are OpenAI's. This is an extension of scope,
with no claim of a better numerical bound or independent human peer review.

## The theorem

[AllRings.lean](lean/OAI/LinearAlgebra/MatrixMultiplication/AllRings.lean):

```lean
theorem omega_le_nine_quarters_all_rings
    (R : Type u) [Ring R] [Nontrivial R] :
    Arithmetic.omega R ≤ (9 : ℝ) / 4
```

The substantive statement change from the prior theorem is small:

```diff
- (F : Type u) [Field F] : Arithmetic.omega F ≤ (9 : ℝ) / 4
+ (R : Type u) [Ring R] [Nontrivial R] : Arithmetic.omega R ≤ (9 : ℝ) / 4
```

The arithmetic model has exactly seven `Field` → `Ring` substitutions.
Its gate costs, evaluation, correctness quantifiers, positive exponent slack,
and infimum definition are unchanged. Nontriviality supplies the usual
lower bound and makes the infimum interpretation nonvacuous.

The stronger intermediate theorem is `exactRankExponent_int_le_nine_quarters`:
the exponent of exact **integer coefficient tensor rank** is at most 9/4.
Those identities give programs over every ring, since integer constants are
central and each left-input factor stays before its right-input factor.

The direct operation-count theorem says that for every ε > 0 there is a
constant C > 0 and, for every matrix size n ≥ 1, a correct program costing
at most C n^(9/4 + ε) additions, subtractions and multiplications. This also
includes the zero ring. It is an existence theorem for arithmetic programs;
it does not establish an exact O(n^(9/4)) endpoint, an efficient uniform
circuit generator, or a bit-complexity bound.

## What the extension adds

- A suitable integral tensor spectrum, avoiding the false assumption that
  every nonzero integer tensor restricts to the unit tensor.
- Division-free coefficient extraction and descent through one fixed finite
  free integer algebra after taking powers.
- Consecutive unnormalized Fourier periods, with their scalar multipliers
  cancelled by Bezout before character evaluation.
- Integral convolution schemes obtained by finite-field specialization,
  Vandermonde adjugates, integer norms, and a finite coprime patch.
- The inherited determinant, sector and profile argument over these inputs,
  followed by the bridge to arbitrary ring arithmetic.

See the [paper PDF](paper/paper.pdf), [LaTeX source](paper/paper.tex), and
[provenance](UPSTREAM.md). The paper has no author byline or date and is
associated with its repository commit.

## Build and verify

Lean **4.35.0-rc4** and Mathlib
`f0469b25d97aef3998d4bc06f6f01da670b3d18e` are pinned.

```sh
lake exe cache get
LEAN_NUM_THREADS=1 lake build
LEAN_NUM_THREADS=1 lake build OAI.LinearAlgebra.MatrixMultiplication.FinalAudit
python3 scripts/check-specification.py
bash scripts/check-kernel.sh
python3 scripts/check-comparator.py --trusted-local --negative-controls
```

The specification checker freezes the original model plus only the seven
approved typeclass substitutions. Comparator checks six statements, including
BddBelow, the lower bound, direct costs, and exact integer coefficients.
Its deliberate controls must reject changed multiplication cost and `sorry`.
The local Comparator command disables its build sandbox; it is not a claim
of sandboxed source-provenance verification. See [audit details](verification/comparator/README.md).

Development uses a serialized build queue on this machine:
`python3 scripts/lean-queue.py submit --owner NAME Module.Name`.
Only the coordinator starts `worker`; `stop` drains the current request.
Stop the worker before kernel/Comparator checks; the scripts share its lock.
The [working agreements](AGENTS.md) document ownership and resource limits.
