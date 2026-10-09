# Zenodo release preparation

Status: metadata prepared for **0.1.0**, not published. No DOI has been
assigned to this project. The repository is private. Sela's confirmation of
the proposed creator credit and authorization of public release are pending.
The `open` access setting in `.zenodo.json` describes the proposed publication;
it does not publish files or authorize a change in repository visibility.

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
| Proposed creator | Sela Navot, human direction of the project |
| ORCID | 0009-0001-8002-5835 |
| License | Apache-2.0, with the retained MIT license for the five vendored fixed-point modules |
| Publication date | Set to the actual release date when publishing; omitted from prepared metadata |
| DOI | Omitted until Zenodo reserves or issues a real identifier |

The creator name and ORCID were copied from the prior all-fields project's
existing `CITATION.cff`, not inferred from a name search. Zenodo requires a
creator, and that credit appears in its citation. The proposed software credit
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

Freeze one reviewed commit after the metadata PR is merged with Sela's specific
approval. Prepare these files from that exact commit:

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

## Manual draft, keeping GitHub private

This is the prepared path while repository visibility remains private. Zenodo's
GitHub integration has no access to private repositories.
[Official GitHub-permissions FAQ](https://support.zenodo.org/help/en-gb/24-github-integration/127-which-github-permissions-do-you-request-and-why).

1. Finish local metadata validation and review; merge the preparation PR only
   with approval identifying that PR. Freeze the exact release commit and
   prepare the files above.
2. In the intended Zenodo account, create a new upload with resource type
   **Software**. Upload the release files and copy the prepared metadata.
   Verify the creator and provenance in the actual form; uploading
   `.zenodo.json` as an attachment does not apply its fields automatically.
3. Save the draft. A real DOI may be reserved in the draft if needed, but do
   not invent one or copy the older project's DOI. Use the eventual public
   release date in the publication-date field.
4. Review the concrete draft and files with Sela. Publishing an open archive
   exposes those files even if the GitHub repository stays private. Obtain the
   required public-release authorization before publishing.
5. After publication, verify the record's files, checksums, version, creator,
   license and related identifiers. Record the issued version DOI and URL in a
   follow-up metadata PR. Confirm any Software Heritage link separately.

Published record metadata is public even when files have restricted access;
a saved, unpublished draft is the preparation state here.
[Create-upload documentation](https://help.zenodo.org/docs/deposit/create-new-upload/).

## GitHub integration alternative

Use this path only if Sela authorizes making the repository public and its
public release. Link the intended GitHub and Zenodo accounts, sync repositories
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

- Confirm creator credit, public-release authorization and the selected path.
- Validate both metadata files and check `0.1.0` against the package version.
- Confirm the archive and PDF come from the same immutable release commit.
- Verify licenses, upstream source pins, the Git bundle and file checksums.
- Use the actual publication date and only a Zenodo-issued DOI.
- Keep Palomar intake status separate: the local verification receipt is not
  registry acceptance. Follow [PALOMAR.md](PALOMAR.md) for that submission.
