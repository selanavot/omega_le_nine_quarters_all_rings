# Palomar mechanical verification

The reports below certify the original rc4 snapshot. The later rc3 compatibility
branch has a separate [local rendering receipt](RC3-RENDER.md) and
[proof verification receipt](../comparator/RESULTS-RC3.md). Those local checks
do not replace a hosted preflight for a new submitted commit.

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
