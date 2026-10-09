# Adversarial review of the verification harness

Reviewed 2026-10-09 by the `check_reply_direction` agent, restricted to the
new private ring repository. This is a source and read-only reproducibility
review, not a second execution of Lean, Lake, Comparator, or the kernel.
The coordinator owns those executions. No proof or verification source was
modified in this review.

## Result

No blocking proof-specification or harness defect was found in the inspected
snapshot. In particular, I found no route by which the deliberately incomplete
Challenge supplies a proof to the real theorem, no omitted axiom check on the
advertised proof, and no definition-hole permission in the Comparator config.
This conclusion does not replace successful execution of the full checks.

## Evidence actually obtained

- `python3 scripts/check-specification.py` exited zero. The Model and the
  Challenge's model prefix equal the immutable initial model after exactly
  seven literal `[Field F]` to `[Ring F]` substitutions. The complete Challenge,
  manifest and toolchain also match their pins. Both Comparator configs equal
  the explicit six-theorem/three-standard-axiom configuration in the checker.
- `python3 scripts/verify-dependencies.py` exited zero. All nine dependency
  Git checkouts have the exact manifest revisions, clean tracked sources, no
  hidden index flags or detected ignored source overrides, and physical paths
  including the dependency-directory ancestors.
- Independently hashed all 130 files recorded in `docs/IMPORT-MANIFEST.json`
  at initial commit `45f5de13717ea1e3323730fccdd3ef58bd0c68b3`. Every hash
  matches. In particular, the original Model hash is
  `1d431b406a1b8bb23b9c99dd0429fed8b8e425062d888b597d05ba5cc23cd729`.
- Read the six Solution proofs, the frozen Challenge, KernelAudit, FinalAudit,
  AllRings, the default package entrypoint and all audit scripts. The Solution
  wrappers use the actual advertised theorems. The explicit integer
  coefficient theorem obtains its witness from the real rank theorem; it does
  not assume that theorem or substitute a functional equality on a finite ring.
- Walked the local source import graph using the project's literal import
  statements. `OAI` and `ComparatorAudit.Solution` each have 144 local modules
  in their closure; `ComparatorAudit.KernelAudit` has 146. None imports
  `ComparatorAudit.Challenge`. The Challenge itself imports only Mathlib.
- Searched local Lean sources for proof holes, added axioms and unsafe/meta
  proof shortcuts. The only actual `sorry` terms found are the six intentional
  Challenge statements. This is a source-search check, not a replacement for
  transitive axiom enumeration or kernel checking.

## Why the harness covers the advertised claim

KernelAudit guards the transitive axiom list of all six Solution theorems with
`#guard_msgs`, requiring only `propext`, `Classical.choice` and `Quot.sound`.
It also imports FinalAudit, which instantiates the result at a noncommutative
matrix ring and spells out the arithmetic-cost quantifiers. Its source is
included in the before/after audit fingerprint.

The frozen arithmetic specification includes gate evaluation, unit costs for
add/sub/mul, correctness for all matrix inputs, positive exponent slack and
one constant for every matrix size. The bound, bounded-below condition,
nonempty condition, lower bound and direct-cost theorem are all separately
named Comparator targets. The sixth target states integer tensor coefficient
identities literally, without importing a project rank definition into the
Challenge. Comparator configuration does not permit definition holes.

I also inspected the installed Lean 4.35.0-rc4 implementation, rather than
assuming what the command-line flags mean. `LeanChecker.lean` implements
`--fresh` by replaying the imported constants into an empty kernel environment.
This is Lean's own kernel. `Lake/CLI/Check.lean` compares the specified targets
and dependency definitions, checks their allowed axioms, and runs the solution
export through the requested bundled checkers. Its `--paranoid` list is Lean
paranoid, lean4lean, nanoda, con-leche and con-ron, followed by Lean default.
Nonzero checker exits propagate to failure; they are not merely printed.

The two negative controls make isolated source copies and require both a
nonzero exit and the expected diagnostic. The changed-cost control must name
`Arithmetic.Gate.cost`; the proof-hole control must identify `sorryAx`.
Cleanup is in a `finally` block. This source review confirms their design;
only the coordinator's completed run can establish that they executed and
were rejected as intended.

## Limits and reporting requirements

1. The scripts intentionally run trusted local code without Comparator's
   Linux sandbox. No hostile-build isolation or externally authenticated
   source-provenance claim follows. Current documentation states this limit.
2. `lake build` is incremental. Fresh kernel replay checks the loaded proof
   declarations; it is not a clean source rebuild. Dependency validation
   explicitly excludes generated `.lake` artifacts from its source audit.
   A completion report should distinguish a clean local-proof rebuild, if
   performed, from dependency-cache reuse and fresh declaration replay.
3. Toolchain labels and source pins are checked, but the scripts do not
   authenticate every installed executable against a release checksum. They
   assume the local toolchain and operating environment are trusted. The
   multiple kernels reduce reliance on one kernel implementation; they do
   not eliminate the toolchain and host trust assumptions.
4. The exclusive lock coordinates these scripts with the repository's build
   worker. It cannot stop arbitrary independent processes. Source fingerprints
   detect persistent changes during a run; they are not an adversarial
   filesystem isolation mechanism. This is consistent with the trusted-local
   scope.
5. At review time the working tree contained uncommitted harness files and
   documentation updates above proof commit `3ccd334`. Successful execution
   logs, the final commit and this report should be retained together before
   reporting a completed verification. The working status document still
   described earlier incomplete assembly, so the coordinator must reconcile
   it with the final observed results.

## Inspected source fingerprint

SHA-256 of the canonical sorted JSON map from each inspected path to its file
SHA-256, using separators `(',', ':')`:

`0518b5f06347c337eda29643d9c2718609718ef6983ccb9ef3c2a1af6426e16a`

The map covers `scripts/{check-specification.py,specification.py,
verify-dependencies.py,audit_runtime.py,check-kernel.py,check-comparator.py,
check-kernel.sh}`, `lean/ComparatorAudit/{Challenge,Solution,KernelAudit}.lean`,
`verification/comparator/{pins,config}.json`, `comparator.json`, `lakefile.lean`
and `lean/OAI.lean`. This fingerprint records the reviewed snapshot, not a
promise that later changes have been reviewed.

## Addendum: targeted fresh-kernel replay

The coordinator replaced the broad `leanchecker --fresh MODULE` invocation
with an export of the six frozen Solution targets and their complete proof
dependencies, followed by `leanchecker --from-export`. The earlier broad run
was stopped without a completed verdict; it must not be counted as a pass.
This addendum independently reviews the revised command's coverage. It does
not report the new run's outcome, which remained the coordinator's task.

I read the revised `scripts/check-kernel.py` and the installed rc4 sources
`LeanExport.lean`, `LeanExport/Basic.lean` and `LeanChecker.lean`:

- The script still checks the frozen specification and dependencies and builds
  KernelAudit before export. It reads the six target names from the validated
  configuration, adds the three allowed axioms and the Quot package, and passes
  those explicit names after the exporter's `--` separator. It does not enable
  the exporter's ignore-missing or unsafe-export options.
- `LeanExport.main` treats the names after `--` as export roots. In
  `LeanExport.Basic.dumpConstant`, definitions, opaque declarations and
  theorems each recursively export constants used in **both their types and
  their values/proof terms**. Axioms export the dependencies of their types.
  Inductive blocks include their constructors, recursors and dependencies of
  recursor rule bodies; the Quot package is exported together. The dependency
  walker calls `dumpConstant` on every name from `Expr.getUsedConstants`.
  Thus the selection excludes unrelated imported theorems, not intermediate
  lemmas or definitions used by the six claims.
- `LeanChecker.checkExport` parses the export, calls
  `Lean.mkEmptyEnvironment`, and invokes kernel replay on its complete constant
  map. It does not import Mathlib declarations as already trusted facts into
  that replay. The automatically generated Quot entries receive the explicit
  post-check used by native Comparator as well. Replay and post-check errors
  return a nonzero exit, which the Python script requires to succeed.
- Kernel replay alone accepts axiom declarations. The standard-axiom
  restriction continues to be supplied by the guarded KernelAudit build and
  by Comparator's separate transitive axiom check; the revised export step
  does not replace or weaken those checks.

This is a valid fresh replay of the complete six-claim proof dependency
closure. It preserves the relevant kernel-checking claim while avoiding a
replay of every unrelated declaration imported through `Mathlib`. The earlier
limits concerning incremental compilation, local toolchain trust and absence
of hostile-build isolation still apply.

Only `scripts/check-kernel.py` changed among the fingerprinted files. Its new
SHA-256 is
`682908cf8a64b961c06ec19012ac593a99b41ae499dbc97c8d83612ec0d0f5f6`.
The revised canonical file-map SHA-256, calculated by the same method above,
is `760413387231aaa4a8d4519485a5fa5ed1f573af3baf8ca77bb09c73081fab49`.
