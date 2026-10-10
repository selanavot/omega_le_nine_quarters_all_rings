# Palomar verification and rendering

## Current rc3 registry rendering

**PASS**, rendered at `2026-10-10T05:28:41Z`; the hosted render job completed
successfully at 05:28:46 UTC. This is the registry's official rendering check
for intake **`psdxspsdhwdz`**, following the mechanical pass below. It resolves
the earlier rc4 rendering failure for the unchanged Challenge on rc3.

- [Registry render run 38027359827](https://github.com/PalomarRegistry/PalomarSubmission/actions/runs/38027359827).
- [Public artifact 11660827709](https://github.com/PalomarRegistry/PalomarSubmission/actions/runs/38027359827/artifacts/11660827709),
  named `challenge-render-a2dc6dde0708465fbed1605feb42d1bf`.
- Source: `selanavot/omega_le_nine_quarters_all_rings` at exact commit
  `9d10116c89f9bdcdaccd58aacea353d4b7ae6e90`, root `comparator.json`.
- Frozen Challenge SHA-256:
  `e5ce8a1491d77029211b59a6b54d066e7e6a7449ef9c619c23e96c0a09b9978c`.
- Lean `leanprover/lean4:v4.35.0-rc3`, Verso
  `8fc7a297f14d5adc1a551b5b4ecf283c08bd691f`, renderer
  `d4e41c1d5b0d114c4859e6e5831dc6d3ad1d0d44`.
- [Bounded report](registry-render-psdxspsdhwdz.json), SHA-256:
  `1a99eb7cb8748a4970e03d4c6f7826a6413c334d454acf6894d113a88101f2a4`.
- [Artifact manifest](registry-render-psdxspsdhwdz-manifest.json), SHA-256:
  `c91190f0783d2b8ba5d4a4705112ba3f6ce9f093737da64817df1663c3b23de0`.
- Report `status: pass`, `stage: complete`, empty error list; all six configured
  declarations and their audit signatures are present.

Every manifest file's size and SHA-256 matched the downloaded public artifact
(19 files). The manifest's artifact-tree hash matches the report:
`cbd0a1cd8d17c4c5ac4c7a623df164de4ca59eef199081cb64b29e0fe248de06`.
Only the bounded report and manifest are retained here, not the HTML bundle.
This hosted result is distinct from the earlier [local rendering receipt](RC3-RENDER.md).
A separate artifact audit found the complete hosted bundle byte-identical to
the prior local rc3 output, with matching core-audit declarations and exactly
one HTML definition anchor for each of the six claims.
At 05:31 UTC no private review was available (HTTP 404). Rendering success is
not review completion or registration; see [the current handoff](../../docs/PALOMAR.md).

## Current rc3 registry verification

**PASS**, checked at `2026-10-10T04:53:15Z`. This is the registry's own
mechanical verification after acceptance of intake **`psdxspsdhwdz`**, distinct
from the preceding preflight and from later rendering, review and registration.

- Source: `selanavot/omega_le_nine_quarters_all_rings` at exact commit
  `9d10116c89f9bdcdaccd58aacea353d4b7ae6e90`.
- Root `comparator.json`, all six claims and the same configuration hash as
  the passing rc3 preflight.
- [Registry run 38025286082](https://github.com/PalomarRegistry/PalomarSubmission/actions/runs/38025286082).
- [Public artifact 11659133367](https://github.com/PalomarRegistry/PalomarSubmission/actions/runs/38025286082/artifacts/11659133367).
- [Complete bounded report](registry-psdxspsdhwdz.json), SHA-256:
  `840407d2271e7d4b89f038fd8ef0cb71d42bdb02a35e3cec9e9634a9a9108e49`.
- Report `status: pass`, `stage: complete`, empty error and warning lists.
- Execution profile: `palomar-namespace-16x32-v1`.
- Default Lean, NanoDa and con-ron accepted the solution.

The later hosted rendering pass is recorded separately above. Neither workflow
establishes the submission API's current state or completed review. See
[the current handoff](../../docs/PALOMAR.md) for service-status observations.
No registration has been performed.

## Current rc3 compatibility preflight

**PASS, 2026-10-10**, checked at `2026-10-10T04:38:01Z`.
The official full workflow verified the corrected immutable source snapshot
[`9d10116c89f9bdcdaccd58aacea353d4b7ae6e90`](https://github.com/selanavot/omega_le_nine_quarters_all_rings/tree/9d10116c89f9bdcdaccd58aacea353d4b7ae6e90)
in [PR #6](https://github.com/selanavot/omega_le_nine_quarters_all_rings/pull/6).
This report was added afterward; it does not certify later documentation commits
as separate snapshots. The theorem sources and executable audit harness are
unchanged between that tested commit and this receipt update.

- [Hosted run 38024128253](https://github.com/selanavot/omega_le_nine_quarters_all_rings/actions/runs/38024128253).
- Request/artifact: `ringsrc3test` / `mechanical-report-ringsrc3test`.
- [Complete bounded report](preflight-ringsrc3test.json), SHA-256:
  `fe82e887c25ae2764247c888e3213a5b045e9312f2376c4660c13baf866bc305`.
- Pipeline: `d4e41c1d5b0d114c4859e6e5831dc6d3ad1d0d44`;
  mode `full`, execution profile `palomar-standard-v1`.
- Lean `leanprover/lean4:v4.35.0-rc3`, Mathlib
  `c55e6e786f49471c72fbddbec5415808896aec1e`.
- Root `comparator.json`, all six claims, matching configuration and Challenge hashes.
- Report `status: pass`, `stage: complete`, empty error and warning lists.
- Protected Comparator accepted the solution with default Lean, NanoDa and con-ron.

This hosted Linux provenance/sandbox check complements the
[local six-checker/fresh-kernel receipt](../comparator/RESULTS-RC3.md).
The workflow does not include Challenge rendering; the complete native rc3
rendering check has its [own receipt](RC3-RENDER.md). Local rendering and a
passed hosted mechanical preflight do not establish registry rendering,
editorial acceptance or registration. After Sela's explicit approval and
PR #6's merge, corrected intake **`psdxspsdhwdz`** was accepted for the exact
preflighted rc3 commit, root `comparator.json`, relationship `maintainer`.
The temporary ownership tag and secret gist were deleted. Initial status was
`verifying`; the registry subsequently passed its mechanical verification,
recorded separately above. The original rc4 submission and frozen Zenodo
archive remain unchanged.

## Historical rc4 preflight

**PASS**, 2026-10-09. This is the full official preflight, distinct from
Palomar's subsequent verification, editorial review and permanent registration.

- Source: `selanavot/omega_le_nine_quarters_all_rings` at
  `2d2cc89859d17d3143cd40c4a4b3df49801aa533`.
- Root project; `comparator.json`; `formalization.yaml`; all six compared claims.
- Pipeline: `PalomarRegistry/PalomarSubmission` at
  `d4e41c1d5b0d114c4859e6e5831dc6d3ad1d0d44`.
- Workflow mode: `full`; execution profile: `palomar-standard-v1`.
- [GitHub Actions run](https://github.com/selanavot/omega_le_nine_quarters_all_rings/actions/runs/37967750557).
- Artifact: `mechanical-report-ringsfull001`.
- [Complete bounded report](preflight-ringsfull001.json), SHA-256:
  `43b5351bf246e6936107829c57930972f3e14618ca4c7a5d75244f121d4b390e`.

The downloaded report has `status: pass`, `stage: complete`, and empty error
and warning lists. Its source, config path and configuration hash match the
approved snapshot. The protected Comparator run accepted all six declarations
with Lean's default kernel and the NanoDa and con-ron checkers. The report
retains the source requirements, dependency provenance, sandbox configuration,
tool digests and resource observations used by the official workflow.

The final Comparator output is:

```text
con-ron: accepted 54841 declarations (--verified)
con-ron kernel accepts the solution
nanoda kernel accepts the solution
Lean default kernel accepts the solution
Your solution is okay!
```

After this pass, intake `pq5sjorephuw` was submitted using Palomar's supported
agent protocol. The temporary proof-of-write tag and secret gist were deleted.
The submission access token and any private review are deliberately excluded
from this repository. A completed intake or passed preflight is not registration;
the final registry URL will be recorded only after registration actually succeeds.

The prior local six-checker and fresh-kernel results remain separately scoped
in [the Comparator receipt](../comparator/RESULTS.md).

## Registry verification after intake

The registry's [own verification run](https://github.com/PalomarRegistry/PalomarSubmission/actions/runs/37969772632)
also completed successfully on 2026-10-09. Its
[bounded mechanical report](registry-pq5sjorephuw.json) has `status: pass`,
`stage: complete`, and empty report error and warning lists. It records the
same approved source, root Comparator configuration and six claims.

- Submission ID: `pq5sjorephuw`.
- Artifact: `mechanical-report-pq5sjorephuw`.
- Checked at: `2026-10-09T18:03:27Z`.
- SHA-256: `0e7026f10fd7a26f94df7b459ccc6de5a1cc30b52f7ae7b27e8916bca5f2d0c0`.

The reports' empty warning lists do not mean their build logs are free of Lean
linter warnings. Mechanical success is distinct from editorial review and
registration. The original submission later settled at `verification-error` after Challenge
rendering failed. Editorial review had not started. Subsequent API HTTP 500
responses are a separate service issue. See [the diagnosis](RC3-RENDER.md) and
[current handoff](../../docs/PALOMAR.md); no review or registration approval is
included here.
