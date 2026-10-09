# Status

## Active strengthening: include the trivial ring

Sela authorized removing Nontrivial from the upper-bound theorem on 2026-10-09.
The new target is `(R : Type u) [Ring R] : Arithmetic.omega R ≤ 9/4`.
Arithmetic/TrivialRing gives an explicit zero-cost program, all-real admissibility,
failure of BddBelow in the trivial case, and omega=0 by Real.sInf_univ.
The main theorem splits trivial/nontrivial cases. Lower bound and BddBelow keep
Nontrivial; Model and its frozen prefix are unchanged.

The revised full build PASSED (9179 jobs, exit 0, unchanged source snapshot), with
output in `.lake/all-rings-zero-build.log`. All printed axiom lists contain only
the standard three. Paper source has been revised; its native compile passed.
Fresh-kernel and positive Comparator checks are next for this stronger statement;
sources and harness files must stay frozen throughout these sequential runs.
The prior negative-control implementation and targets are unchanged; keep their
previous-run evidence identified separately. No merge or publication authorized.

Owners for this change: ring_statement (TrivialRing, AllRings, FinalAudit),
ring_spectrum (Challenge, Solution, pins), omega_constructions (paper source and
paper README), root (builds, all other docs, PDF, Git). They have finished edits.
beame_scope_review is reviewing the small new proof and paper remark independently.

## Previous completed nontrivial-ring snapshot

The following records the earlier scope, not validation of the new change.

2026-10-09. Branch: prove-all-rings.
https://github.com/selanavot/omega_le_nine_quarters_all_rings/pull/1

**The full ring 9/4 theorem, fresh-kernel replay, Comparator, and both deliberate
failure controls passed.** The paper and committed PDF are ready for review.
The repository remains private until Sela authorizes publication. No PR merge
is authorized. Paper and README use wording suitable for joint publication.

Target: `omega_le_nine_quarters_all_rings (R : Type u) [Ring R] [Nontrivial R]`.
Lean 4.35.0-rc4 and mathlib f0469b25d97aef3998d4bc06f6f01da670b3d18e
are pinned. The checkout has independent physical dependency sources.

## Proven scope

- Exact integer coefficient tensor-rank exponent is at most 9/4.
- The arithmetic exponent over every nontrivial associative unital ring is
  at most 9/4, including noncommutative rings.
- For every ring and every positive epsilon, one constant bounds correct
  programs at every positive matrix size by C*n^(9/4+epsilon).
- Boundedness and nonemptiness of the admissible set, and the lower bound 2
  for nontrivial rings, are proved.
- The arithmetic model differs from the imported baseline by exactly seven
  Field-to-Ring substitutions. All other model bytes are preserved.
- No smaller numerical exponent, exact O(n^(9/4)) endpoint, efficient uniform
  circuit generator, or bit-complexity theorem is claimed.

## Completed checks

- AllRings, OAI and FinalAudit: request 1791557812451628000-2aa7a8,
  exit 0, 9175 build-graph jobs, no concurrent source changes.
- Comparator Challenge, Solution and guarded KernelAudit:
  request 1791557832666381000-053bf2, exit 0, 9176 jobs.
- Legacy AllFields: request 1791557921875737000-4a30e6,
  exit 0, 9165 jobs.
- Six audited claims depend only on propext, Classical.choice and Quot.sound.
- Model/Challenge specification hashes and all nine pinned dependency source
  checkouts passed.
- The complete six-claim proof dependency closure was exported and replayed
  into a fresh Lean kernel; exit 0 and unchanged source snapshot.
- Native frozen-specification Comparator passed with its Lean paranoid,
  lean4lean, nanoda, con-leche, con-ron and default Lean checkers.
- The altered multiplication-cost control was rejected at Arithmetic.Gate.cost.
  The deliberately unproved epsilon-cost theorem was rejected for sorryAx.
  Both controls failed for their required reasons; temporary sources were removed.
- Three separate adversarial AI reviews found no blocking defect. Their
  reports and limits are in [adversarial/](adversarial/).
- Both LaTeX compilers passed. All six rendered pages were inspected; there
  are no unresolved references or box warnings, author metadata, or PDF dates.
  The abstract cites the prior all-fields extension beside OpenAI's complex result.

The commands, exact versions, log hashes and concise output excerpts are in
[the verification receipt](../verification/comparator/RESULTS.md).
Dependency caches were reused; this is not a clean-source rebuild or an
externally authenticated toolchain-provenance audit. Comparator used trusted
local sources with its build sandbox explicitly disabled. Formal checks
validate Lean declarations, not the prose manuscript or historical novelty.

## Restart notes

The serialized build worker is stopped. Detailed build and audit logs are
ignored under .lake. All proof/harness sources were frozen during the final
runs. The audited code and harness are at commit 2553d35; later changes are
paper and documentation only.

An earlier broad leanchecker --fresh MODULE run was stopped without a verdict.
It is not counted as a successful check. The completed replacement exports
the six claims and every dependency, then replays that closure using
leanchecker --from-export into an empty kernel. This method received a
separate source-review addendum.

Owner files ARITHMETIC/SPECTRUM/TRANSPORT-STATUS.md retain chronological
development notes. This status and the verification receipt supersede their
earlier pending-build descriptions. Continue changes through the existing PR;
obtain Sela's specific approval before any merge.
