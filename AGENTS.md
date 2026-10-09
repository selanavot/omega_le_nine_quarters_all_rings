# Matrix multiplication over rings

## Authorized scope and publication

Sela originally authorized this repository
`selanavot/omega_le_nine_quarters_all_rings` as private for the Lean proof and
paper of the reviewed integral/ring extension. On 2026-10-09, Sela explicitly
approved merging PR #2, making this repository public, and crediting Sela Navot
as its human creator and responsible maintainer. PR #2 was merged at
`83923f946c6834ae392aa40c5169191745d9e519`; the repository is now public.
The old proof repository and unrelated local research remain read-only; do not
push this work there.
Push checkpoints and open/update a PR here. Each merge requires Sela's
explicit approval identifying that particular PR; PR #2's approval does not
authorize later merges.

Sela approved Palomar submission of the immutable snapshot
`2d2cc89859d17d3143cd40c4a4b3df49801aa533` with root `comparator.json`, as the
responsible maintainer. Its full mechanical preflight passed:
https://github.com/selanavot/omega_le_nine_quarters_all_rings/actions/runs/37967750557.
Do not replace that approved snapshot with later documentation commits.
Palomar intake `pq5sjorephuw` has been submitted using its required tag/gist
protocol; both temporary artifacts were removed. Do not create a duplicate
submission. The access token and private review are outside Git; never publish
them in this repository. Registry mechanical verification also passed in run
37969772632; see verification/palomar for both public receipts. The latest
submission status is `verification-error`: Palomar could not complete the
Challenge renderability check, and editorial review has not started.
On 2026-10-09 Sela explicitly requested that the existing Zenodo upload be made
live. Record 23268534 is now published as version 0.1.0 with the same five
checked release files from the approved snapshot. Its version DOI is
10.5281/zenodo.23268534 and concept DOI is 10.5281/zenodo.23268533.
Do not create a duplicate record or replace the frozen release with later docs.
Sela also explicitly authorized merging the documentation PR prepared on
`docs/zenodo-publication` after its edits and validation are complete; that
authorization is specific to this publication update.
Permanent Palomar registration requires a further explicit instruction after
Sela receives the complete review; submission approval is not that instruction.
See docs/ZENODO.md and docs/PALOMAR.md for the current publication steps.

## Trusted specification

Target: `OAI.MatrixMultiplication.omega_le_nine_quarters_all_rings` with
`(R : Type u) [Ring R]` and conclusion
`Arithmetic.omega R ≤ (9 : ℝ) / 4`.
Preserve the existing program semantics, gate costs, correctness quantifiers,
positive exponent slack, and infimum definition. Generalize typeclasses only
where supported. Prove BddBelow for nontrivial rings and the direct operation-count
theorem for all rings. Sela explicitly authorized removing Nontrivial from the
upper bound on 2026-10-09: handle the zero ring with an explicit zero-cost program
and document the real-infimum convention. Retain Nontrivial on the lower bound
and BddBelow statements; do not change the definition of omega.
The stronger intermediate is exact integer coefficient rank exponent ≤9/4.
No new axioms, sorry/admit, vacuous assumptions, or circular definitions in
completed proofs. Keep incomplete obligations explicit and outside the final
audit target. Never describe a conditional or partial theorem as the result.

## Restart and ownership

Read README.md, docs/STATUS.md, docs/PLAN.md, and docs/OWNERSHIP.md first.
Inspect Git status and latest commits before editing; preserve shared work.
Every agent owns distinct source and audit files. Keep those docs current.
This repository starts from the minimal import closure of the all-fields
entrypoint at 08481ef22bca7dc9ffba091083b7c1e81e537220; exact hashes are in
`docs/IMPORT-MANIFEST.json`. OpenAI upstream is adc7f1241b42e322a6451854ab7e4b4c146bf78a.
Retain licenses and clear attribution for inherited and modified code.

## Verification and resources

Use Lean 4.35.0-rc4 and mathlib f0469b25d97aef3998d4bc06f6f01da670b3d18e,
upgraded at Sela’s explicit request on 2026-10-09. Keep exact versions pinned.
24GB host: LEAN_NUM_THREADS=1. Only root starts build processes. Source
editing may be parallel. If a serialized build queue is installed, agents
may submit requests; they may not start additional Lake/Lean processes.
Only count actual compiler success as checked. At completion run full build,
inspect axioms, verify unchanged semantics, and use fresh-kernel replay and
Comparator where supported. Reuse dependency caches, not stale local OAI
artifacts. Keep generated caches and large logs out of Git.

## Paper

Use one standalone `paper/paper.tex`, no author byline/date or author PDF
metadata, with rigorous attribution to OpenAI and the prior field extension.
Clearly identify AI-generated proof development and text. Do not represent
unformalized statements as Lean-verified. Build and commit paper/paper.pdf,
link it from README, and visually inspect all pages. Use the built-in editor
and compiler for source preview. A reproducible repo PDF build may additionally
use existing tools. Do not install TeX solely for the native editor.

No brain icons or graphics. Never merge without specific human approval.

Before reusing dependency caches, resolve `.lake/packages` itself and every
ancestor: inspecting its children does not detect a parent symlink. Keep a
physical copy per independently upgraded project; verify `lake env printenv
LEAN_PATH` stays inside this checkout before starting builds.
