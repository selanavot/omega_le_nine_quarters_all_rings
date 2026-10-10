# Local Palomar rendering compatibility: Lean rc3

**PASS, 2026-10-10.** The exact submitted Challenge renders on unmodified
Lean/Verso 4.35.0-rc3. Extraction, HTML generation, Palomar's trusted
core-notation audit, and its HTML sanitizer all passed. This is a native
macOS ARM64 reproduction, not a new Palomar Linux sandbox result, editorial
review, or registration.

The branch changes compiler/dependency pins, not any Lean proof or statement.
The proof verification has its own [receipt](../comparator/RESULTS-RC3.md).
The original submission and the Zenodo 0.1.0 archive remain tied to
`2d2cc89859d17d3143cd40c4a4b3df49801aa533`.

## Version choice and diagnosis

The original rc4 Challenge compiled, then its literate extractor failed with:

```text
error finding highlighted code: missing data file for module Mathlib
```

Verso rc4 [passes Lake's module setup to the extractor](https://github.com/leanprover/verso/blob/01a09f320122475119588526857a07d218aef600/lakefile.lean#L631-L659).
For an ordinary module import, this contains exported/server artifacts.
The extractor [imports those artifacts without selecting an import level](https://github.com/leanprover/verso/blob/01a09f320122475119588526857a07d218aef600/src/verso-literate/VersoLiterateMain.lean#L641-L649),
so Lean requests private data that the setup did not supply. Locally, adding
`(level := if Compat.isModule headerStx then .server else .private)` fixed rc4
without changing the Challenge. That patch is not part of this project.

The preceding rc3 renderer does not pass that setup map. It was chosen over
rc2 because it is the nearest earlier release, is above Palomar's rc2 minimum,
and a [successful public rc3 render](https://github.com/PalomarRegistry/PalomarSubmission/actions/runs/38001354188)
provided a control. We then tested our own complete Challenge. We do not claim
that every rc4 project fails or that older Lean is mathematically necessary.

## Exact inputs

| Component | Pin |
| --- | --- |
| Lean | `leanprover/lean4:v4.35.0-rc3` |
| Lean commit | `470d5ce1400764999581fd26d5d72b00d990b0f4` |
| Mathlib | `c55e6e786f49471c72fbddbec5415808896aec1e` |
| Verso | `8fc7a297f14d5adc1a551b5b4ecf283c08bd691f` |
| SubVerso | `d047cb484b2f3598187450935dbcc84d078cb581` |
| Palomar pipeline | `d4e41c1d5b0d114c4859e6e5831dc6d3ad1d0d44` |
| Challenge SHA-256 | `e5ce8a1491d77029211b59a6b54d066e7e6a7449ef9c619c23e96c0a09b9978c` |

All 13 renderer dependency checkouts matched their pins and had no tracked
source modifications. Mathlib caches were reused; the Verso executables were
built locally. Project and renderer dependency directories were physical,
not symlinks into another toolchain's checkout. The Lean search path was
checked. Only one Lean build was run at a time.

## Checks and retained evidence

- `lake build Challenge:literate` completed successfully: 9,274 graph jobs
  including cached dependencies, not 9,274 fresh compilations.
- JSON output contains all six declarations, exact displayed source text,
  and definition-site signatures identical to the repaired rc4 control.
- Zero rendered errors; six expected `sorry` warnings in the independent
  Challenge specification. They are not holes in the actual proof.
- Generated HTML contains exactly one definition anchor for each claim.
- The unchanged pipeline's core-notation audit returns all six declarations.
- Its unchanged sanitizer succeeds; clean metadata contains all six claims
  and audit signatures. Every file hash/size in the final manifest was checked.

[rc3-render.json](rc3-render.json) retains the results, pins, anchors, output-tree
hash and log hashes. Detailed local logs are ignored, not committed.
A sanitizer attempt begun before the audit JSON was ready failed on empty
input; the completed audit output was then supplied and the final run passed.
No renderer code was changed to obtain this result.

## Reproduction setup

Use a separate checkout of this repository. Replace its Lakefile only in that
disposable checkout with the following generated `lakefile.toml`, remove the
competing `lakefile.lean`, and copy [rc3-render-manifest.json](rc3-render-manifest.json)
to its root as `lake-manifest.json`. Keep the pinned rc3 `lean-toolchain` and
unchanged `lean/ComparatorAudit/Challenge.lean`.

```toml
name = "PalomarChallengeRender"
defaultTargets = ["Challenge"]
[[require]]
name = "mathlib"
git = "https://github.com/leanprover-community/mathlib4.git"
rev = "c55e6e786f49471c72fbddbec5415808896aec1e"
[[require]]
name = "verso"
git = "https://github.com/leanprover/verso.git"
rev = "8fc7a297f14d5adc1a551b5b4ecf283c08bd691f"
[[lean_lib]]
name = "Challenge"
srcDir = "lean"
roots = ["ComparatorAudit.Challenge"]
```

From that checkout (so Elan selects its toolchain), run:

```sh
lake exe cache get
LEAN_NUM_THREADS=1 lake build Challenge:literate
LEAN_NUM_THREADS=1 lake exe verso-html .lake/build/literate .lake/build/palomar-render-raw
```

This reproduces the extraction and HTML stages. The remaining local checks
used `scripts/core_notation_audit.lean` and `scripts/render_challenge.py sanitize`
from the pinned Palomar pipeline. The audit executable must also be built
with rc3, then run in the renderer checkout's `lake env` for the six theorem
names in the JSON receipt. Its declaration JSON is the sanitizer's
`--audit-declarations` input. These native runs do not replace Palomar's
own isolated Linux execution.

A new intake requires a passing official mechanical preflight and an approved
immutable commit. See [the submission handoff](../../docs/PALOMAR.md).
