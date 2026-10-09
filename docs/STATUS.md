# Status

## Zenodo publication

On 2026-10-09 Sela requested that the existing upload be made live and the
README updated. [Zenodo record 23268534](https://zenodo.org/records/23268534)
is now published and open as version 0.1.0. The version DOI
[10.5281/zenodo.23268534](https://doi.org/10.5281/zenodo.23268534) resolves to
the published record; [10.5281/zenodo.23268533](https://doi.org/10.5281/zenodo.23268533)
is its concept DOI. The five published file checksums match the prepared
release at `2d2cc89859d17d3143cd40c4a4b3df49801aa533`.
See [the release record](ZENODO.md). This documentation update does not
change the proof, paper or frozen archive. Sela authorized merging the
specific `docs/zenodo-publication` PR after editing and validation.

## Algebraic-structure diagram

After Sela merged PR #3 at `505371ebed8922bedcc95ae5bcb6e1262323a947`,
branch `docs/algebraic-structures` adds the requested connected hierarchy to
the README, with editable SVG, PNG fallback and
[model/citation notes](ALGEBRAIC-STRUCTURES.md). Green marks the scope of the
all-rings theorem; orange marks classes containing cubic semiring examples.
The Jerrum–Snir lower bound is cited background, not an additional Lean result.
Proof sources, specifications, dependencies, paper and archival files are
unchanged. The already submitted immutable snapshot remains the same.

## Public release and Palomar preflight

On 2026-10-09 Sela explicitly approved merging PR #2, making this repository
public, using Sela Navot as creator/responsible maintainer, and submitting
`2d2cc89859d17d3143cd40c4a4b3df49801aa533` with `comparator.json` to Palomar.
PR #2 is merged at `83923f946c6834ae392aa40c5169191745d9e519`; GitHub visibility
is public. The approved proof snapshot remains unchanged.

The full official preflight passed, with empty report error and warning lists:
https://github.com/selanavot/omega_le_nine_quarters_all_rings/actions/runs/37967750557
Request ID: `ringsfull001`. The bounded report is retained in
[verification/palomar](../verification/palomar/README.md).
Palomar intake `pq5sjorephuw` was submitted with authorization relationship
`maintainer`; the temporary ownership tag and secret gist were removed.
The registry's mechanical verification also passed:
https://github.com/PalomarRegistry/PalomarSubmission/actions/runs/37969772632.
The report is retained beside the preflight receipt. After earlier HTTP 500
responses, the submission API reports `verification-error`: Palomar could not
complete the Challenge renderability check after multiple attempts. Editorial
review has not started, and no private review is available.
Do not create a duplicate submission. Permanent registry
registration remains a later decision after Sela views the actual review.
Zenodo [23268534](https://zenodo.org/records/23268534) is now published with
the five release files from the approved snapshot. The public record confirms
the creator, license, version, AI disclosure and related works; all five
displayed MD5 checksums match the local release files. See [ZENODO.md](ZENODO.md).

The sections below retain the earlier preparation and proof snapshots.

## Historical release preparation (before PR #2 merged)

PR #1 was merged by Sela at `97298f64dc4ae420a104db473b6a74162a280729`.
Branch `release/zenodo-palomar` prepares citation/archive metadata and the
pinned Palomar preflight workflow. The Lean proof, model, six Comparator
statements, toolchain, dependency pins and paper are unchanged. The previously
completed proof verification below still applies to those exact files.

Zenodo publication and Palomar submission are not yet complete. The repository
is still private; its visibility must be explicitly authorized before public
release. Palomar also requires a passing full mechanical preflight and an
agreed immutable commit, config path and submitter relationship before intake.
See [ZENODO.md](ZENODO.md) and [PALOMAR.md](PALOMAR.md).

Preparation checks passed: CFF 1.2.0 validation with cffconvert 2.0.0,
the pinned official Palomar metadata contract, the full formalization v0.4
schema, JSON syntax, unchanged proof/specification checks, and a separate
source review of the metadata and workflow. The prior project's Zenodo DOI
and ORCID come from its existing citation record; a live Zenodo API read
returned HTTP 504 during preparation. No new Zenodo record or release exists.

The following is the completed proof snapshot, before archival preparation.

2026-10-09. Branch: prove-all-rings.
https://github.com/selanavot/omega_le_nine_quarters_all_rings/pull/1

**The upper bound now covers every associative unital ring, including the
trivial ring. Compilation, fresh-kernel replay, and Comparator with all six
bundled checkers passed again.** The paper and committed PDF are ready for
review. The repository remains private until Sela authorizes publication.
No PR merge is authorized.

## Proven scope

```lean
theorem omega_le_nine_quarters_all_rings
    (R : Type u) [Ring R] :
    Arithmetic.omega R ≤ (9 : ℝ) / 4
```

- Exact integer coefficient tensor-rank exponent is at most 9/4.
- The arithmetic upper bound covers all associative unital rings, including
  noncommutative rings.
- For every ring and every positive epsilon, one constant bounds correct
  programs at every positive matrix size by C*n^(9/4+epsilon).
- The trivial ring has an explicit zero-cost program. Every real exponent is
  admissible, so its admissible set is not bounded below. The unchanged
  real-valued infimum definition gives omega=0 by Real.sInf_univ, not a
  genuine real infimum. The direct cost theorem avoids this convention.
- The lower bound 2 and BddBelow retain Nontrivial. The substantive
  integer-to-ring infimum bridge is used only in the nontrivial branch.
- The arithmetic model differs from the imported baseline by exactly seven
  Field-to-Ring substitutions. All other model bytes are preserved.
- No smaller numerical exponent, exact O(n^(9/4)) endpoint, efficient uniform
  circuit generator, or bit-complexity theorem is claimed.

## Current verification

Audited proof/harness revision:
`63ddeef94ef18a08a9825c30f41b833c1a339260`.
Later changes are paper and documentation only. Lean 4.35.0-rc4 and mathlib
f0469b25d97aef3998d4bc06f6f01da670b3d18e are pinned.

- Full revised OAI/FinalAudit/Challenge/KernelAudit build passed:
  9179 build-graph jobs, exit 0, unchanged source snapshot.
- All audited axiom lists contain only propext, Classical.choice and Quot.sound.
- Frozen specification hashes and all nine pinned dependency source checkouts passed.
- The complete six-claim dependency closure was exported and replayed into a
  fresh Lean kernel; exit 0 and unchanged source snapshot.
- Comparator accepted the frozen specification and all six claims with its
  Lean paranoid, lean4lean, nanoda, con-leche, con-ron and default Lean checkers.
  The complete script exited 0 with unchanged sources.
- The preceding revision's two negative controls rejected changed gate cost and
  sorryAx. They were not rerun for this strengthening; their implementation,
  gate-cost definition and injected-sorry target are unchanged.
- The new trivial-ring source review found no blocking defect. Earlier
  mathematics, specification and reproducibility reviews cover the unchanged
  substantive argument. These are AI reviews, not human peer review.
- Both LaTeX compilers passed. All seven final rendered pages were inspected;
  there are no unresolved references or box warnings, author metadata, or PDF
  dates. The paper credits OpenAI and our earlier all-fields extension and
  discloses AI-generated proof development and text.

The [current receipt](../verification/comparator/RESULTS.md) records commands,
versions, log hashes, scope and successful output. The
[archived receipt](../verification/comparator/RESULTS-NONTRIVIAL.md) preserves
the preceding nontrivial-ring scope and negative controls. Reviews are in
[adversarial/](adversarial/).

Dependency caches were reused; this is not a clean-source rebuild or an
externally authenticated toolchain-provenance audit. Comparator ran on trusted
local sources with its build sandbox explicitly disabled. The complete target
dependency closure was freshly replayed; unrelated imported Mathlib declarations
were not all replayed. Formal verification validates Lean declarations, not
manuscript prose or historical novelty.

## Restart notes

No build worker or audit is running. Detailed logs are ignored under .lake:

- all-rings-zero-build.log
- zero-ring-kernel-audit.log
- zero-ring-comparator-audit.log
- zero-ring-verification-process.json

An earlier broad leanchecker --fresh MODULE run was stopped without a verdict.
It is not counted as successful. The completed replacement exports the six
claims and every dependency, then uses leanchecker --from-export into an empty
kernel. The export method received a separate source review.

Owner status files retain chronological development notes. This status and
the current receipt supersede earlier pending-build descriptions.
PRs #1–#4 are merged. Continue the Zenodo documentation on
`docs/zenodo-publication` through its own PR; Sela has specifically authorized
merging that PR after editing and validation. Keep the archived and submitted
snapshot unchanged.
