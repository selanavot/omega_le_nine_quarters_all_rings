# Palomar release and submission handoff

Updated on 2026-10-10. Sela confirmed the human creator/maintainer credit,
approved the public repository and the PR #2 merge, and authorized submission
of snapshot `2d2cc89859d17d3143cd40c4a4b3df49801aa533` with root
`comparator.json` as its responsible maintainer. The repository is now public.
[PR #2](https://github.com/selanavot/omega_le_nine_quarters_all_rings/pull/2)
was merged at `83923f946c6834ae392aa40c5169191745d9e519`.

The [full mechanical preflight](https://github.com/selanavot/omega_le_nine_quarters_all_rings/actions/runs/37967750557)
passed for the approved snapshot, with empty report error and warning lists. Its
[public receipt](../verification/palomar/README.md) retains the complete bounded
mechanical report. Palomar intake `pq5sjorephuw` was then submitted via the
required tag/gist protocol; both one-use artifacts were removed. Permanent
registration has not been performed. Do not create a duplicate intake.
The registry's [verification run](https://github.com/PalomarRegistry/PalomarSubmission/actions/runs/37969772632)
also completed successfully; its bounded mechanical report says `pass` and
`complete` for the same snapshot and six claims. Both reports are retained in
the public receipt. This does not establish that editorial review is complete.
After earlier HTTP 500 responses, the last confirmed submission API status was
`verification-error`: Palomar could not complete the Challenge renderability
check after multiple attempts. The final recorded attempt failed at
2026-10-09 20:54:31 UTC. Editorial review has not started; the review endpoint
returned HTTP 404. The public failure report omitted the underlying renderer
error; local investigation recovered it as described below. Preserve the
existing submission and token; do not create a duplicate intake.
The confirmed human credit describes orchestration and responsibility, not
handwritten proofs or prose. Permanent registration still needs explicit
approval after Sela receives the complete review.

## Renderer diagnosis and rc3 compatibility

The submitted rc4 Challenge compiles, but Palomar's pinned Verso renderer fails
while preparing highlighted code with
`error finding highlighted code: missing data file for module Mathlib`.
The failure also reproduces with a tiny module importing Mathlib and proving
`True`; it does not require the matrix-multiplication theorem. In the pinned
rc4 renderer, an import requests private compiled data while Lake supplies the
exported and editor-support data for a `module` file. The local investigation
corrected that request and rendered the original Challenge successfully.
The public failed attempt is
[run 37989444912](https://github.com/PalomarRegistry/PalomarSubmission/actions/runs/37989444912).

Sela then authorized checking older supported versions and making a repository
compatibility change if successful. The unchanged Challenge rendered locally
with the **unmodified rc3 renderer**, and all six displayed theorem signatures
matched those from the locally corrected rc4 renderer. Literal extraction,
HTML generation, the trusted core-notation audit and sanitization also passed
locally under rc3. The compatibility branch therefore pins Lean
`leanprover/lean4:v4.35.0-rc3` with Mathlib
`c55e6e786f49471c72fbddbec5415808896aec1e`. See
[the rc3 rendering check](../verification/palomar/RC3-RENDER.md).

Full proof compilation, fresh-kernel replay, Comparator with all six bundled
checkers and both negative controls also passed locally under rc3 at
source/pins/harness commit `fd3d1cf942ae05c1437d26cc0d83d813ce20a4c9`. All 160
Lean files under `lean/` are unchanged. See
[the rc3 verification receipt](../verification/comparator/RESULTS-RC3.md).
The official hosted rc3 preflight has not started. These local proof and
rendering passes are not a passing hosted Palomar workflow or acceptance.
The original intake still names the rc4 commit. No replacement submission has
been authorized or made; preserve that intake and its token. A dependency
change in Git cannot repair or silently retarget an immutable submission.

## Conditions for a corrected submission

The original `verification-error` is a settled state under the
[agent protocol](https://submit.palomar-registry.org/llms.txt). Follow its
reported next action and observe the submission cooldown before any retry.
The [official submission page](https://submit.palomar-registry.org/) directs
unsuccessful submissions to leave **Existing Palomar ID** blank when retrying;
that field is for a new version of an already registered result. The intake ID
`pq5sjorephuw` is not a registered-result ID and must not be placed there.

The local rc3 proof and rendering checks are complete. Before any corrected
intake, push the exact intended commit and obtain Sela's approval identifying its full
immutable SHA, `comparator.json` and the responsible-maintainer relationship.
Run the official full mechanical preflight for that same snapshot and require
its report to say `status: pass`. Preflight does not include Challenge
rendering, editorial review or registration, so preserve the separate rendering
evidence too. Read the live protocol and respect any reported cooldown or
retry restriction. No corrected intake has been authorized or started.

## Pinned workflow and current eligibility

The manual workflow `.github/workflows/palomar-preflight.yml` calls
[PalomarSubmission](https://github.com/PalomarRegistry/PalomarSubmission/tree/d4e41c1d5b0d114c4859e6e5831dc6d3ad1d0d44)
at `d4e41c1d5b0d114c4859e6e5831dc6d3ad1d0d44` in both `uses` and `pipeline_commit`.
It requests `mode: full`, `execution_profile: palomar-standard-v1`, root
`comparator.json`, and root `formalization.yaml`. It has read-only contents
permissions, receives no inherited secrets, and has no push/PR trigger.
The upstream job fetches a public source snapshot without private-repository
credentials. The repository's approved visibility change satisfies that
prerequisite.

The compatibility branch's `leanprover/lean4:v4.35.0-rc3` exceeds the pinned pipeline's
[rc2 minimum](https://github.com/PalomarRegistry/PalomarSubmission/blob/d4e41c1d5b0d114c4859e6e5831dc6d3ad1d0d44/toolchains.json)
and matches its selected Mathlib toolchain. Toolchain eligibility alone did not
prevent the rc4 rendering failure: the submitted snapshot used the
[Verso rc4 tag](https://github.com/leanprover/verso/tree/v4.35.0-rc4), resolving to
`01a09f320122475119588526857a07d218aef600`. The rc3 rendering receipt records the
tested replacement environment. Recheck live policy and support before any
future intake; the historical rc4 reports certify only their recorded snapshot.

The submitted-snapshot source inspection found 161 tracked Lean files, all with the required
module header except the permitted Lakefile exemption. The largest has 1,613
lines. Challenge is 166 lines/5,233 bytes, imports only Mathlib, and fits the
preferred review surface. The submitted comparator configuration uses only
accepted fields and the three standard axioms, with no definition holes.
There are no tracked submodules, symlinks, LFS pointers, or compiled artifacts;
tracked files total about 1.6 MB. Root has one Apache-2.0 license. The proof's
vendored MIT notice remains in its own subdirectory. This inspection is not
Palomar's full mechanical verification.

The standard hosted profile specifies at least 14 GiB memory and 20 GiB free
workspace, a 350-minute job ceiling, and a 19,800-second execution budget.
These are ceilings, not runtime estimates. A clean sandboxed build can take
substantial time and consume CI allowance; no dollar estimate is asserted.
The existing macOS checks reused caches and disabled the local Comparator
sandbox. They do not replace this Linux provenance/sandbox run. Do not retry
an OOM or timeout unchanged or silently purchase a different runner.
See the pinned [resource policy](https://github.com/PalomarRegistry/PalomarSubmission/blob/d4e41c1d5b0d114c4859e6e5831dc6d3ad1d0d44/verification-profile.json).

## What the metadata says

`formalization.yaml` uses v0.4 and treats this repository as the substantive
development, not a thin wrapper. It explicitly records adaptation of OpenAI's
preprint and the pinned all-fields formalization, plus related formalizations.
No claim of numerical improvement, historical priority, or human peer review
is made. Palomar reserves project authors/maintainers for humans; Codex's
material role is disclosed under automation and in the production account.
Sela Navot confirmed the human project creator/maintainer credit.

All six frozen statements are explained in the metadata's `alignment` table:
upper bound for all rings; BddBelow for nontrivial rings; nonempty admissible
set for all rings; lower bound two for nontrivial rings; direct positive-slack
program costs for all rings; and literal exact integer coefficient identities.
The zero-ring real-infimum convention and its explicit zero-cost program are
stated separately. The paper remains without an author byline.

The original release preparation did not change the proof source or Comparator
model. The rc3 compatibility work preserves the model and six frozen statements.
The earlier receipts retain their precise scope. Metadata validation is not
proof verification, and successful preflight is not editorial approval.

## Completed mechanical verification and next step

The release metadata is merged, the source is public, and the approved full
40-character commit is `2d2cc89859d17d3143cd40c4a4b3df49801aa533`.
Both the completed preflight and submitted intake use that immutable
snapshot and root `comparator.json`, not a moving branch, documentation follow-up
or the newer rc3 compatibility work. Sela explicitly confirmed the responsible
maintainer relationship; it was not inferred from GitHub ownership.

The full workflow completed successfully with request ID `ringsfull001`.
Its report has `status: pass`, the exact approved repository/commit/config,
and the standard hosted execution profile. Lean's default kernel, NanoDa and
con-ron accepted the proof under the pipeline's protected Comparator setup.
This preflight does not perform Challenge rendering or editorial review;
the submitted intake runs those registry stages separately.

Local checks completed successfully before submission:

- Ruby safe YAML parsing and the workflow input/pin/full-mode structural checks.
- The official Palomar metadata contract at the pinned pipeline commit, using
  `PyYAML==6.0.3`.
- The complete upstream v0.4 JSON schema at
  `99c678e569c7c4c0772db297c5ddd5e4c9b6322e`, using
  `PyYAML==6.0.3` and `jsonschema==4.25.1` via `uv run`.

The last check applies `yaml.safe_load` and `jsonschema.validate` with the
pinned `schema/v0.4.schema.json`. These preparation checks passed. The full
Palomar preflight and registry mechanical verification subsequently passed.
Challenge rendering, editorial review and registry registration remain separate
stages; the mechanical report does not certify their completion. The two zero sorry
counts exclude the six deliberate Challenge theorem holes.

The current metadata parser is
[`load_formalization_metadata`](https://github.com/PalomarRegistry/PalomarSubmission/blob/d4e41c1d5b0d114c4859e6e5831dc6d3ad1d0d44/scripts/submission_contract.py)
in the pinned pipeline. A local parser check needs only its source tree and
its pinned/hash-checked PyYAML requirements, not Lean. With that tree available
on `PYTHONPATH`, call the function on this repository's `formalization.yaml`.
It validates Palomar's additional metadata requirements; the upstream v0.4
JSON schema alone is not the full Palomar contract. The decisive check remains
the full reusable workflow.

## Agent intake, review, and final registration

Read the live [agent protocol](https://submit.palomar-registry.org/llms.txt)
before the first API request. Agents must not automate the GitHub OAuth/browser
sign-in flow. The supported machine route uses authenticated `gh` with repository
write and gist access. It is weaker identity evidence than the browser route;
it establishes repository-write control plus a named gist account.

After the passed full preflight and the exact submission agreement above:

1. `POST /api/submit` with the repository, full commit, explicit
   `comparator_config_path: comparator.json`, and the agreed
   `authorization_relationship` (`maintainer` or `approved`). Use the default
   root project/metadata paths. Do not invent an existing Palomar ID; this ring
   result is a separate submission unless a specific existing record is chosen.
2. Create the requested temporary `palomar-verify-<challenge>` tag at that exact
   commit and a **secret** gist with `palomar.txt` containing the challenge.
   Call `POST /api/verify` with the pending secret and gist ID, then delete both
   temporary artifacts. Complete the exchange in one sitting; intake expires
   after fifteen minutes. Do not weaken the protocol if permissions are missing.
3. Keep the returned submission link/token in a user-approved private location
   outside Git. Treat it as a credential: it can read review and register the
   result. Never put it in a PR, workflow log, shell history, or this document.
4. Monitor `GET /api/submission` with the bearer token. Poll at most once a minute
   while running, and at most once per five minutes awaiting review. Retrieve
   `GET /api/review` when available; do not publish the private review.
5. Show Sela the complete review and explain the permanent public record.
   **Obtain a new explicit instruction to register that reviewed result.** Only
   then call `POST /register` with its exact `review_sha256`. Initial permission
   to submit does not authorize publishing an unseen review. Record the final
   versioned Palomar URL only after registration actually completes.

If authenticated `gh`, gist scope, or tag creation is unavailable, hand the
submission form to Sela for manual authentication; do not automate it or replace
the required ownership proof. If a token is lost, recovery is likewise a human
browser action. Resolve failed preflight/verification diagnostics before a new
attempt and honor service cooldowns.

Verification dispatch publicly exposes the repository, commit, submission ID,
authorization relationship, and any approval evidence. Review remains private
until registration but is retained by the operators and service providers.
Registration publishes the review and fixed source record; ordinary history is
append-only. These details must be part of Sela's final decision.

Primary references: [submission standard](https://github.com/PalomarRegistry/PalomarPolicy/blob/main/CONTRIBUTING.md),
[protocol](https://submit.palomar-registry.org/llms.txt),
[official workflow](https://github.com/PalomarRegistry/PalomarSubmission/blob/d4e41c1d5b0d114c4859e6e5831dc6d3ad1d0d44/.github/workflows/submission.yml),
and [metadata standard](https://github.com/mathlib-initiative/formalization.yaml).
