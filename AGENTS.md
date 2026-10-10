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
Historical rc4 intake `pq5sjorephuw` used the required tag/gist
protocol; both temporary artifacts were removed. The access token and private review are outside Git; never publish
them in this repository. Registry mechanical verification also passed in run
37969772632; see verification/palomar for both public receipts. That submission
settled at `verification-error`: Palomar could not complete the
Challenge renderability check, and editorial review had not started.
On 2026-10-09 Sela explicitly requested that the existing Zenodo upload be made
live. Record 23268534 is now published as version 0.1.0 with the same five
checked release files from the approved snapshot. Its version DOI is
10.5281/zenodo.23268534 and concept DOI is 10.5281/zenodo.23268533.
Do not create a duplicate record or replace the frozen release with later docs.
The approved Zenodo documentation PR #5 was merged at
`be15d1a0239bf682a31bde07d025d86fc5a3d521`. Its merge approval is used and does
not authorize later merges.
After successful compatibility testing, Sela explicitly approved the rc3
change, its corrected intake and overnight monitoring.
Compatibility [PR #6](https://github.com/selanavot/omega_le_nine_quarters_all_rings/pull/6)
merged at `00976b9efed79b4c01ea42565b0832f491ccae75` on
2026-10-10 at 04:45:34 UTC. Its approval does not authorize merging this or any
later documentation PR.
The accepted current Palomar intake is **`psdxspsdhwdz`**, for exact preflighted
commit `9d10116c89f9bdcdaccd58aacea353d4b7ae6e90`, root `comparator.json` and
relationship `maintainer`. Its required temporary tag and secret gist were
deleted after verification of ownership. After initial status `verifying`,
[registry run 38025286082](https://github.com/PalomarRegistry/PalomarSubmission/actions/runs/38025286082)
passed mechanical verification for the exact submitted snapshot; the public
report is checked at 2026-10-10 04:53:15 UTC and retained in
verification/palomar/registry-psdxspsdhwdz.json. The official
[render run 38027359827](https://github.com/PalomarRegistry/PalomarSubmission/actions/runs/38027359827)
also passed for that exact source and frozen Challenge at 05:28:41 UTC; its
bounded report and artifact manifest are retained beside the mechanical report.
The earlier rendering blocker is resolved on the official rc3 pipeline.
At 05:31 UTC the private-review endpoint returned HTTP 404, so no review was
available. The last status-API request returned HTTP 500; do not infer an
advanced API state from the workflow passes. Monitor
this new ID, not the historical rc4 intake. Do not create another intake or
substitute a later receipt/docs commit. The authorized monitor checks every
15 minutes through 2026-10-10 09:00 America/New_York; do not create a duplicate
monitor. Keep credentials and private review outside Git. The Zenodo archive
remains unchanged.
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

The repository pins Lean 4.35.0-rc3 and Mathlib
`c55e6e786f49471c72fbddbec5415808896aec1e`, following Sela's request to test an
older supported renderer before changing the project. Keep exact versions
pinned. Full local proof compilation, fresh-kernel replay, Comparator with all
six bundled checkers, both negative controls and rendering passed at the
source/pins/harness commit `fd3d1cf942ae05c1437d26cc0d83d813ce20a4c9`; see
docs/STATUS.md and verification/comparator/RESULTS-RC3.md. All 160 Lean files
under `lean/` are unchanged. The official hosted rc3 preflight also passed for
`9d10116c89f9bdcdaccd58aacea353d4b7ae6e90` in
[run 38024128253](https://github.com/selanavot/omega_le_nine_quarters_all_rings/actions/runs/38024128253).
That report is mechanical verification, not rendering, editorial review,
registration or authorization for a new intake.
The archived release and earlier verification receipts remain on rc4 and
Mathlib `f0469b25d97aef3998d4bc06f6f01da670b3d18e`. Preserve those records as
historical evidence; never relabel them with new dependency versions.
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

When comparing toolchain versions, invoke Lake with the process working
directory set to the target project and confirm `lake env lean --version`
there. Passing `lake -d PATH` alone does not select that directory's toolchain:
the caller's working directory can already have selected a different version
through Elan. Apply this check to isolated renderer and core-notation audit
helpers as well as the main proof. Rebuild any helper created under the wrong
toolchain before counting its output as evidence.
