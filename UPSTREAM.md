# Provenance and attribution

This is a focused source fork of the [all-fields extension](https://github.com/selanavot/matrix-multiplication-all-fields/tree/08481ef22bca7dc9ffba091083b7c1e81e537220),
which derives from [OpenAI's mathematics repository](https://github.com/openai/math/tree/adc7f1241b42e322a6451854ab7e4b4c146bf78a).
It is a separate repository, not a GitHub fork relationship.

OpenAI's *An Upper Bound of 9/4 for the Matrix Multiplication Exponent*
(October 2, 2026) supplies the numerical bound, auxiliary separation,
determinant and sector constructions, detecting-character framework,
profile-growth argument, and arithmetic specification.
[Read the pinned preprint](https://github.com/openai/math/blob/adc7f1241b42e322a6451854ab7e4b4c146bf78a/preprints/Matrix-Multiplication-Nine-Fourths-October-2-2026/paper.pdf).
The prior extension adapts the proof to every field and provides fixed
finite-extension descent. This repository develops exact integer schemes
and the resulting bound for arbitrary associative unital rings.

## Imported source

The imported all-fields revision is
`08481ef22bca7dc9ffba091083b7c1e81e537220`; the OpenAI revision is
`adc7f1241b42e322a6451854ab7e4b4c146bf78a`.
The local baseline commit is `45f5de13717ea1e3323730fccdd3ef58bd0c68b3`.
[IMPORT-MANIFEST.json](docs/IMPORT-MANIFEST.json) records the retained files
and their hashes. Only the prior theorem's import closure and provenance/
license files were copied. Other OpenAI problems and unrelated local research
are omitted. The earlier repository's complete extraction and modification
history remains in its [pinned provenance record](https://github.com/selanavot/matrix-multiplication-all-fields/blob/08481ef22bca7dc9ffba091083b7c1e81e537220/UPSTREAM.md).

The ring model differs from this local baseline by exactly seven literal
`[Field F]` to `[Ring F]` substitutions. Gate costs, program evaluation,
correctness, exponent slack, and the infimum definition are unchanged.
The public ring theorem uses the scalar name `R` and includes trivial rings.
An explicit zero-cost program handles the trivial case; the unchanged
real-valued infimum definition then gives zero by Mathlib's convention for
unbounded-below sets. Nontriviality remains on the lower-bound and boundedness
statements. The direct operation-count theorem also includes trivial rings.

## New proof development

The extension uses a subsemiring of tensors restricting to the unit,
extends its characters to all tensors, and proves two integral inputs:
unnormalized Fourier separation patched across consecutive periods, and
convolution interpolation patched across coprime integer norm multipliers.
Coefficient extraction and finite free descent occur after taking powers,
so their fixed or polynomial overhead does not change the exponent.
Integer coefficients are central in every ring, and input multiplication
order is preserved by the arithmetic program construction.

All new proof development and the accompanying manuscript are AI-generated
with Codex under Sela Navot's direction. The paper attributes the inherited
proof explicitly. No improvement of the numerical 9/4 bound, historical
priority of standard algebraic tools, or human peer review is claimed.

## Licenses and dependencies

The [Apache-2.0 license](LICENSE) is retained. Existing modification notices
and source attribution are preserved. New proof and audit files use the same
license. Five required Brouwer modules were previously vendored from harfe's
`fixed-point-theorems-lean4` revision
`770940ddf9878cf61952ed53d910b92bca841838`, retaining the OpenAI compatibility
patch and subsequent module-system port. Their MIT license is preserved at
[lean/FixedPointTheorems/LICENSE.txt](lean/FixedPointTheorems/LICENSE.txt).

Current Lean and Mathlib versions are pinned by `lean-toolchain` and
`lake-manifest.json`. This project upgraded to Lean 4.35.0-rc4 and Mathlib
`f0469b25d97aef3998d4bc06f6f01da670b3d18e` at the user's request.
Dependency sources are not modified by build hooks.
