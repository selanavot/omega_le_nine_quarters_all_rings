# Zenodo archival release

Version **0.1.0** was published on **2026-10-09** as an open software record:
[Zenodo record 23268534](https://zenodo.org/records/23268534).

- Version DOI: [10.5281/zenodo.23268534](https://doi.org/10.5281/zenodo.23268534).
  Cite this DOI for the exact 0.1.0 release.
- Concept DOI: [10.5281/zenodo.23268533](https://doi.org/10.5281/zenodo.23268533).
  This identifies the project's version series.
- Archived source commit: [`2d2cc89859d17d3143cd40c4a4b3df49801aa533`](https://github.com/selanavot/omega_le_nine_quarters_all_rings/tree/2d2cc89859d17d3143cd40c4a4b3df49801aa533).

The existing draft was published with Sela's authorization; no duplicate record
was created. The release files remain frozen at the source commit above.
Later publication-status documentation and Palomar reports are outside this
archive. Do not substitute the current branch for the archived source snapshot.

Palomar is a separate workflow. Its full mechanical preflight and registry
mechanical verification passed, but Zenodo publication does not establish
Palomar editorial approval or permanent registration. See
[the Palomar status](PALOMAR.md) and
[verification receipts](../verification/palomar/README.md).

## Published files

The record contains these five files from the immutable release snapshot.
All five uploads completed, and their displayed MD5 checksums matched the local
release files both before and after publication. The published record shows
open access, and the version DOI resolves to that record.

| File | Bytes | Uploaded MD5 |
| --- | ---: | --- |
| `omega_le_nine_quarters_all_rings-0.1.0.zip` | 771958 | `e9ec7c45335b64bed6118d45cda6e80c` |
| `paper.pdf` | 298585 | `07940ef8e98692f851168cc70f00f3a2` |
| `source-history.bundle` | 738269 | `ff7dd209bf2d8f8fcbafdcc655997350` |
| `RELEASE.json` | 548 | `9d2d48284425d987d96b7517ae09ed24` |
| `SHA256SUMS` | 352 | `cea738464868171f2070649793cb5fd8` |

The source ZIP passed integrity checking and contains the committed PDF.
The history bundle was restored separately and the baseline specification audit
passed there. The supplementary SHA-256 manifest covers the release files.

The ZIP contains the tracked Lean sources, toolchain and dependency pins, paper
source and PDF, build instructions, licenses, provenance, verification harness
and receipts. The standalone `paper.pdf` is the same committed paper.
`RELEASE.json` records the version and full source commit.

## Record and attribution

The single software record associates the proof, specification, explanatory
paper and reproducibility evidence with one version.

| Field | Published value |
| --- | --- |
| Title | The Matrix Multiplication Bound ω ≤ 9/4 over Associative Rings |
| Resource type | Software |
| Version | 0.1.0, matching `lakefile.lean` |
| Creator | Sela Navot, human direction and responsible maintenance of the project |
| ORCID | [0009-0001-8002-5835](https://orcid.org/0009-0001-8002-5835) |
| License | Apache-2.0, with the retained MIT license for the five vendored fixed-point modules |
| Publication date | 2026-10-09 |
| Version DOI | 10.5281/zenodo.23268534 |
| Concept DOI | 10.5281/zenodo.23268533 |

The record also includes English language, Lean programming language, six
keywords and the four related identifiers prepared in `.zenodo.json`. Its
description preserves the AI disclosure, attribution, scope and limitations,
and records the exact source snapshot and Git-bundle reproduction note.
The confirmed creator credit does not add an author byline, date or author
metadata to the PDF.

Both repository metadata files disclose that the new Lean proof development and
manuscript are AI-generated with Codex under Sela Navot's direction. Codex is
described as a tool, not listed as a human creator. Exact model identifiers for
this ring extension are not asserted from the earlier field extension's
attribution. OpenAI receives explicit credit for the numerical 9/4 bound, main
proof architecture and arithmetic specification; the prior all-fields extension
is credited separately. Pinned source revisions and the earlier archive DOI
are recorded as provenance. That earlier DOI, `10.5281/zenodo.23219128`,
identifies the all-fields work and must not be used as this project's DOI.

[`.zenodo.json`](../.zenodo.json) retains the prepared archive metadata.
[`CITATION.cff`](../CITATION.cff) supplies the software citation used by GitHub
and other citation tools and now identifies the published version DOI, date
and source commit. Keep their title, version, creator, license and claims
aligned. The Apache-2.0 archive-level value does not override
[`lean/FixedPointTheorems/LICENSE.txt`](../lean/FixedPointTheorems/LICENSE.txt).

## Reproduction

The source ZIP builds the Lean development, but a ZIP has no Git history.
`scripts/check-specification.py` uses `git show` against the recorded baseline
`45f5de13717ea1e3323730fccdd3ef58bd0c68b3`; reproducing that audit requires a
full clone or restoration from the supplied history bundle. For example:

```sh
git clone source-history.bundle omega_le_nine_quarters_all_rings
cd omega_le_nine_quarters_all_rings
git checkout 2d2cc89859d17d3143cd40c4a4b3df49801aa533
```

Follow the archived README's pinned build and verification instructions from
that checkout. The archive's verification receipts document the actual checks
and their limits.

Zenodo publication alone does not establish Software Heritage ingestion. Its
manual software guide requests one source ZIP; the PDF, history bundle and
manifests are supplementary files. Confirm any Software Heritage record
separately before claiming that additional archival status.
[Manual software-upload documentation](https://help.zenodo.org/docs/github/archive-software/manual-upload/).

## Future versions

Use this project's existing Zenodo record and its **New version** workflow for
changes to archived files. This is a distinct version series from the earlier
all-fields deposit. Do not create another independent record or enable a
second automatic archive of this same 0.1.0 release.

1. Prepare repository changes through a PR and obtain Sela's explicit approval
   before merging that PR. Choose and record the exact new release commit.
2. Prepare a source ZIP, the matching committed paper, a history bundle,
   release manifest and checksums from that commit. Preserve licenses,
   upstream pins, attribution and the AI disclosure. Include the baseline
   needed by the specification audit, and verify the bundle by restoration.
3. Create a new version from the existing Zenodo record. Set the actual new
   version and publication date, upload its files and check the saved metadata
   and file checksums. Review and publish within Sela's authorized scope.
4. Verify the published record and record its real version DOI, date and source
   commit in a follow-up citation/documentation PR. Keep the concept DOI for
   this series. Keep Palomar review and registration status separate.

Published metadata can be corrected through Zenodo's editing workflow; changing
archived files requires a new version.
[Versioning documentation](https://help.zenodo.org/docs/deposit/manage-versions/).

## Release description

The Matrix Multiplication Bound ω ≤ 9/4 over Associative Rings — version 0.1.0

This release contains a Lean proof that ω(R) ≤ 9/4 for every associative unital
ring R, including noncommutative rings, together with its explanatory paper
and verification records. The proof passes through exact integer coefficient
tensor schemes. For every ε > 0 it establishes correct arithmetic programs
with at most C n^(9/4 + ε) operations; the trivial ring has an explicit zero-cost
program.

OpenAI supplied the numerical bound and main proof architecture. This work
extends the earlier all-fields formalization to rings. The new proof development
and manuscript are AI-generated with Codex under Sela Navot's direction.
Compilation, axiom inspection, fresh-kernel replay
and frozen-specification Comparator with six bundled checkers passed locally.
The archive preserves their scope and receipts. No human peer review, smaller
numerical exponent, exact O(n^(9/4)) endpoint, efficient uniform circuit
generator or bit-complexity theorem is claimed.
