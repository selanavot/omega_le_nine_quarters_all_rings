# Algebraic structures and the scope of the bound

![Connected algebraic hierarchy: rings on the left satisfy the nine-fourths bound; semiring classes on the right contain cubic examples.](assets/algebraic-structures.svg)

The arrows add assumptions, rather than asserting that the displayed classes
are disjoint. In particular, every ring is also a semiring. Multiplication is
associative and unital throughout. A semifield means a commutative semiring
with `0 ≠ 1` and a multiplicative inverse for each nonzero element. `ℕ₀`
includes zero; the strictly positive integers lack the additive identity.

## What the colors mean

**Green applies to every member of the class.** The theorem
[`omega_le_nine_quarters_all_rings`](../lean/OAI/LinearAlgebra/MatrixMultiplication/AllRings.lean)
proves `Arithmetic.omega R ≤ 9/4` for every associative unital ring. This
includes matrix rings and quaternions, as well as commutative rings, integral
domains and fields. The statement retains the documented zero-ring infimum
convention and the direct positive-slack operation-count theorem.

**Orange marks classes containing the listed cubic examples.** It does not
assert a lower bound for every member of those classes. Since the nonnegative
reals belong to all four orange classes, none of those class assumptions alone
can guarantee a universal `9/4` bound in the circuit model below.

## The computational model matters

The comparison uses straight-line arithmetic circuits with addition,
multiplication, and constants from the chosen structure. Intermediate values
stay in that structure. Gates may reuse earlier results. No division gates,
comparisons, branching, or conversion to a larger ring are available.
Possessing multiplicative inverses, as a semifield does, does not add a
division operation to this model.

The repository's actual Lean model also has subtraction gates over rings.
Mathematically, replacing `a - b` by `a + (-1) * b` increases the operation count
by at most a factor of two, preserving the exponent. Constants are free in
the existing model. This equivalence explains the green labels in the
addition/multiplication comparison; the gate-elimination transformation itself
is not a new formalized theorem in this documentation change. In a general
semiring, the needed constant `-1` need not exist.

Additive cancellation (`a + c = b + c` implies `a = b`) does not supply additive
inverses. The nonnegative reals have both additive cancellation and inverses
for nonzero multiplication, yet their division-free circuits still satisfy
the cubic lower bound.

## Classical lower bound

Jerrum and Snir define their `R` as the **nonnegative** reals with ordinary
addition and multiplication in §2.1(ii), printed p. 876
([PDF page 3](https://snir.cs.illinois.edu/listed/J7.pdf#page=3)).
At the end of §4.1, printed p. 886
([PDF page 13](https://snir.cs.illinois.edu/listed/J7.pdf#page=13)), they obtain
`(t - 1) n³` multiplications for a product of `t` square matrices in the
specified semirings. Setting `t = 2` gives `n³`. The ordinary algorithm matches
this multiplication count and uses `O(n³)` total arithmetic operations.
Thus the analogous division-free circuit exponent is exactly `3` for the
nonnegative reals. Section 5.1, p. 893, summarizes the contrast with algorithms
that allow negative constants.

The natural-number and nonnegative-rational examples follow by the same
polynomial-identity argument: a circuit over either computes polynomials with
nonnegative real coefficients. Correctness on its infinite input grid implies
equality with the matrix-product polynomials, so the same circuit would work
on all nonnegative real inputs and is subject to the same lower bound.

These are mathematical background statements. `Arithmetic.omega` in this
repository is defined under `[Ring R]`; the orange labels refer to the
analogous semiring circuit exponent, not a Lean theorem about
`Arithmetic.omega` on semirings. No semiring lower bound is formalized here.

**Reference.** Mark Jerrum and Marc Snir. *Some Exact Complexity Results for
Straight-Line Computations over Semirings*. Journal of the ACM **29**(3),
874–897, July 1982. [DOI: 10.1145/322326.322341](https://doi.org/10.1145/322326.322341).
[Author-hosted PDF](https://snir.cs.illinois.edu/listed/J7.pdf).

## Diagram source

[`assets/algebraic-structures.svg`](assets/algebraic-structures.svg) is the
editable vector source embedded in the README. It uses native SVG text and
paths, with no scripts, external fonts or embedded page content. Its title,
description, text labels and citation keep the meaning available independently
of color. `assets/algebraic-structures.png` is the matching raster fallback.
With an existing installation of librsvg, regenerate the PNG from the
repository root with:

```sh
rsvg-convert --width 1590 --output docs/assets/algebraic-structures.png docs/assets/algebraic-structures.svg
```

The diagram and this explanation are AI-generated documentation. They do not
change the proof, paper, frozen specification, or source snapshot submitted
to Palomar and prepared for Zenodo.
