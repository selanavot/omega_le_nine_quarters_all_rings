# Matrix multiplication over rings

## Authorized scope and privacy

Sela authorized this NEW PRIVATE repository `selanavot/omega_le_nine_quarters_all_rings`
for the Lean proof and paper of the reviewed integral/ring extension.
Keep it PRIVATE. Do not change its visibility. The old proof repository and
unrelated local research remain read-only; do not push this work there.
Push checkpoints and open/update a PR here. Each merge requires Sela's
explicit approval identifying that particular PR.

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
