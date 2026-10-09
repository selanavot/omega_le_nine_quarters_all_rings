# Zenodo release preparation

Status: **0.1.0** is saved as unpublished
[Zenodo draft 23268534](https://zenodo.org/uploads/23268534).
Its [preview](https://zenodo.org/records/23268534?preview=1) requires access to
the intended Zenodo account. No version DOI has been reserved or registered.
The preview displays the automatically allocated concept DOI
`10.5281/zenodo.23268533`, explicitly unregistered until first publication;
do not cite it as a published archive. Sela confirmed the creator/maintainer credit and
approved making the repository public. The repository is now public, and
[PR #2](https://github.com/selanavot/omega_le_nine_quarters_all_rings/pull/2)
was merged at `83923f946c6834ae392aa40c5169191745d9e519` with explicit approval.
Publishing the concrete Zenodo deposit/release remains a separate approval step.
The `open` access setting in `.zenodo.json` does not itself publish anything.

The approved Palomar snapshot is
`2d2cc89859d17d3143cd40c4a4b3df49801aa533` with `comparator.json`. Its
[full mechanical preflight](https://github.com/selanavot/omega_le_nine_quarters_all_rings/actions/runs/37967750557)
passed, and Palomar intake `pq5sjorephuw` was submitted. This does not establish
editorial approval or permanent registry registration.

## Saved draft and uploaded files

The draft was saved and its preview inspected on 2026-10-09. It contains the
title, Software type, version 0.1.0, creator Sela Navot with the confirmed ORCID
and no affiliation, Apache-2.0 license, English language, Lean programming
language, six keywords, and all four related identifiers from `.zenodo.json`.
The description preserves the AI disclosure, attribution, scope and limitations,
and adds the exact source snapshot and Git-bundle reproduction note.
The draft publication date is 2026-10-09, when the source became public.

All five uploads reached 100%; their displayed MD5 checksums match the local
files byte for byte. The release is frozen at
`2d2cc89859d17d3143cd40c4a4b3df49801aa533`:

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
Later publication-status documentation and Palomar reports are outside this
frozen release. The saved preview explicitly states that the record has not
yet been published. Do not create a second draft or trigger automatic archival
for this same release.

## Record and attribution

Prepare one **software** record containing the Lean source, paper and
verification records. This keeps the proof, specification, explanatory text
and reproducibility evidence associated with one version. A separate paper
deposit is optional later; it is not needed for this release. If one is made,
cross-link the real software and paper DOIs using `isDocumentedBy` and
`documents` instead of inventing identifiers now.

| Field | Prepared value |
| --- | --- |
| Title | The Matrix Multiplication Bound ω ≤ 9/4 over Associative Rings |
| Resource type | Software |
| Version | 0.1.0, matching `lakefile.lean` |
| Confirmed creator | Sela Navot, human direction and responsible maintenance of the project |
| ORCID | 0009-0001-8002-5835 |
| License | Apache-2.0, with the retained MIT license for the five vendored fixed-point modules |
| Publication date | 2026-10-09 in the saved draft; date the source first became public |
| DOI | No registered DOI; the preview's concept identifier is not yet registered |

The creator name and ORCID were copied from the prior all-fields project's
existing `CITATION.cff`, not inferred from a name search. Zenodo requires a
creator, and that credit appears in its citation. The confirmed software credit
does not add an author byline, date or author metadata to the PDF.
[Zenodo creator documentation](https://help.zenodo.org/docs/deposit/describe-records/creators/).

Both metadata files disclose that the new Lean proof development and manuscript
are AI-generated with Codex under Sela Navot's direction. Codex is described as
a tool, not listed as a human creator. Exact model identifiers for this ring
extension are not asserted from the earlier field extension's attribution.
OpenAI receives explicit credit for the numerical 9/4 bound, main proof
architecture and arithmetic specification; the prior all-fields extension is
credited separately. Pinned source revisions and the earlier archive DOI are
recorded as provenance. That earlier DOI, `10.5281/zenodo.23219128`, identifies
the all-fields work and must not be used as this project's DOI.

[`.zenodo.json`](../.zenodo.json) controls Zenodo's GitHub-release metadata when
both files exist. [`CITATION.cff`](../CITATION.cff) supplies the software citation
used by GitHub and other citation tools. Keep their title, version, creator,
license and claims aligned. The Apache-2.0 archive-level value does not override
[`lean/FixedPointTheorems/LICENSE.txt`](../lean/FixedPointTheorems/LICENSE.txt).
[Zenodo JSON documentation](https://help.zenodo.org/docs/github/describe-software/zenodo-json/).

## Release contents and reproduction

PR #2 merged the reviewed metadata. Record the exact commit chosen for the
Zenodo release; do not silently substitute later documentation changes for
the approved Palomar snapshot. Prepare these files from that exact commit:

- One source ZIP containing tracked Lean sources, toolchain and dependency
  pins, paper source and PDF, build instructions, licenses, provenance,
  verification harness and receipts.
- The same committed `paper/paper.pdf` as a convenient standalone file.
- A Git bundle retaining the project's history, including baseline
  `45f5de13717ea1e3323730fccdd3ef58bd0c68b3`.
- `SHA256SUMS` covering the release files, plus the full release commit ID in
  the record description or an accompanying manifest.

The source ZIP builds the Lean development, but a ZIP has no Git history.
`scripts/check-specification.py` uses `git show` against the recorded baseline;
reproducing that audit requires a full clone or restoration from the supplied
Git bundle. Verify that the bundle contains the baseline and chosen release
commit. Review its reachable history before publication, since it exposes more
than the final source tree. Do not include `.lake`, dependency caches, secrets,
unrelated research, temporary logs or local configuration. The repository's
verification receipts document the actual checks and their limits.

Zenodo's manual software guide requests one source ZIP and warns that multiple
compressed files prevent Software Heritage ingestion. Keep only one ZIP;
the PDF, Git bundle and checksum manifest are supplementary files. Check the
record's eventual Software Heritage status rather than assuming that a Zenodo
deposit proves ingestion. If the supplementary bundle prevents ingestion,
preserve reproducibility and resolve the packaging with Zenodo before claiming
Software Heritage archival.
[Manual software-upload documentation](https://help.zenodo.org/docs/github/archive-software/manual-upload/).

## Manual draft

The manual path remains available now that the repository is public. It allows
review of one concrete deposit before publication. GitHub integration is an
alternative below; do not create duplicate records for the same release.

1. Metadata validation, review and the approved PR #2 merge are complete.
   Freeze the exact release commit and prepare the files above. Any further
   repository changes require their own PR and specific merge approval.
2. In the intended Zenodo account, create a new upload with resource type
   **Software**. Upload the release files and copy the prepared metadata.
   Verify the creator and provenance in the actual form; uploading
   `.zenodo.json` as an attachment does not apply its fields automatically.
3. Save the draft. A real DOI may be reserved in the draft if needed, but do
   not invent one or copy the older project's DOI. Use the eventual public
   release date in the publication-date field.
4. Review the concrete draft and files with Sela. Obtain approval to publish
   that Zenodo deposit; the completed GitHub visibility change does not itself
   publish or approve the archival deposit.
5. After publication, verify the record's files, checksums, version, creator,
   license and related identifiers. Record the issued version DOI and URL in a
   follow-up metadata PR. Confirm any Software Heritage link separately.

Published record metadata is public even when files have restricted access;
a saved, unpublished draft is the preparation state here.
[Create-upload documentation](https://help.zenodo.org/docs/deposit/create-new-upload/).

## GitHub integration alternative

The public-repository prerequisite is satisfied. After approval of the concrete
archival release, link the intended GitHub and Zenodo accounts, sync repositories
and enable this repository in Zenodo **before** creating the release. Include
the reviewed metadata in the chosen release commit, then publish GitHub release
`v0.1.0`. The enabled integration archives releases automatically, so publishing
that GitHub release is a publication step, not merely draft preparation.
Verify the resulting Zenodo record and supplementary reproduction files. Do not
publish both a manual record and an automatic record for the same release by
accident. [Enable-repository guide](https://help.zenodo.org/docs/github/enable-repository/),
[GitHub release-archiving guide](https://help.zenodo.org/docs/github/archive-software/github-upload/).

This is a new project archive, not a new version in the earlier all-fields
deposit series. Later changes to this project's archived files should use its
own Zenodo versioning workflow.
[Versioning documentation](https://help.zenodo.org/docs/deposit/manage-versions/).

## Draft release text

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

## Checks before publication

- Creator credit and public GitHub visibility are confirmed. Select the
  archival path and obtain approval for the concrete Zenodo publication.
- Validate both metadata files and check `0.1.0` against the package version.
- Confirm the archive and PDF come from the same immutable release commit.
- Verify licenses, upstream source pins, the Git bundle and file checksums.
- Use the actual publication date and only a Zenodo-issued DOI.
- Keep Palomar intake status separate: the local verification receipt is not
  registry acceptance. Follow [PALOMAR.md](PALOMAR.md) for that submission.
