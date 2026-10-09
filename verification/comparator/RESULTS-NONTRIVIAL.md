# Verification receipt

Completed 2026-10-09. **PASS**: compilation, axiom guards, fresh-kernel replay,
native Comparator, all six bundled checkers, and both deliberate failure controls.

The proof and verification scripts checked here are at immutable revision
`2553d35a056d78c677825311ab9a27229c71fd3e`. Later publication changes affect
the paper and documentation only. Both dedicated audit scripts compared source
snapshots before and after execution and exited successfully without source
changes. The temporary control sources were removed.

## Environment and specification

- Lean: `leanprover/lean4:v4.35.0-rc4`.
- Mathlib: `f0469b25d97aef3998d4bc06f6f01da670b3d18e`.
- Nine dependency source checkouts matched the pinned manifest and were clean.
- Imported model baseline: `45f5de13717ea1e3323730fccdd3ef58bd0c68b3`.
- Model edits: exactly seven literal `[Field F]` to `[Ring F]` substitutions.
  All other model bytes, including costs, semantics and quantifiers, are unchanged.
- Six frozen claims: ring upper bound, BddBelow, nonempty admissible set,
  lower bound 2, direct positive-epsilon costs, and literal integer coefficients.
- No definition holes. Permitted and observed axioms are exactly `propext`,
  `Classical.choice` and `Quot.sound`.
- One Lean thread; build worker stopped during dedicated verification.

The main target has the printed type:

```lean
theorem OAI.MatrixMultiplication.omega_le_nine_quarters_all_rings.{u} :
  ∀ (R : Type u) [Ring R] [Nontrivial R], Arithmetic.omega R ≤ 9 / 4
```

## Compilation

| Targets | Queue request | Exit | Build-graph jobs |
| --- | --- | --- | --- |
| FinalAudit, OAI, complete AllRings import closure | `1791557812451628000-2aa7a8` | 0 | 9175 |
| Challenge, Solution, guarded KernelAudit | `1791557832666381000-053bf2` | 0 | 9176 |
| Legacy AllFields entry point | `1791557921875737000-4a30e6` | 0 | 9165 |

All three queue receipts report no source changes during their build. Job counts
include cached/replayed dependencies; they are not counts of fresh compilations.
FinalAudit also checks a noncommutative coefficient ring, `Matrix (Fin 2) (Fin 2) ℤ`.

## Dedicated checks

```sh
python3 scripts/check-specification.py
python3 scripts/verify-dependencies.py
bash scripts/check-kernel.sh
python3 scripts/check-comparator.py --trusted-local --negative-controls
```

The first two commands are also enforced inside both dedicated audit scripts.
The kernel script and complete Comparator script each exited **0**.
The kernel script exports the complete transitive proof dependency closure of
the six claims and replays it into an empty Lean kernel environment. Final output:

```text
Lean default kernel accepts the solution
PASS: complete six-claim dependency closure replayed in a fresh Lean kernel; unchanged source snapshot.
```

Comparator compared the frozen declarations and accepted all six claims.
Its kernel output included:

```text
Lean paranoid kernel accepts the solution
checked 54820 declarations
lean4lean kernel accepts the solution
nanoda kernel accepts the solution
con-leche: accepted 54823 declarations (--verified)
con-leche kernel accepts the solution
con-ron: accepted 54823 declarations (--verified)
con-ron kernel accepts the solution
Lean default kernel accepts the solution
Your solution is okay!
```

The two intentionally broken copies were rejected for the required reasons:

```text
error: Const does not match between challenge and target 'OAI.MatrixMultiplication.Arithmetic.Gate.cost'
error: Illegal axiom detected: 'sorryAx'
```

Each control returned exit **1**, as required for a passing negative control.
The enclosing script then rechecked the frozen specification and source snapshot
and exited **0**. The real proof contains neither altered cost nor sorry proof.
The Challenge's six deliberate theorem holes are specification-only and are not
imported into the actual proof or its kernel audit.

## Scope and reviews

Verification used trusted local sources and existing generated dependency caches.
Comparator's build sandbox was explicitly disabled; its warning to that effect
is retained in the local logs. This is not a sandbox-isolation audit, a clean-source
rebuild, or external authentication of the compiler/toolchain provenance.
Fresh and independent kernel replay supplies additional evidence beyond loading
cached proof artifacts. An earlier broad `leanchecker --fresh MODULE` run was
stopped without a verdict and is not counted as successful.

Three separate AI source reviews found no blocking defect:
[mathematics](../../docs/adversarial/mathematics.md),
[specification and arithmetic](../../docs/adversarial/specification.md), and
[reproducibility](../../docs/adversarial/reproducibility.md).
The last includes a separate review of the targeted fresh-kernel export.
These are not independent human peer review. The checks validate the formal
declarations, not the manuscript's prose or claims of historical novelty.

## Retained log fingerprints

Detailed local logs remain under ignored `.lake/`; the commands above regenerate
them. These SHA-256 values identify the completed run's logs, not independently
reproducible timestamps or build output bytes:

```text
94dec1adc3613e16297e6609f80960a41b92b32dddbcf20b7e8b1811b305e6d1  kernel-audit.log
1e3eb9483d17cb24d7a7bfbf7e6aabbb3d4c33635837aac98ea5a1aaeae888ac  comparator-audit.log
b1938afe78c3158216a20b737e1253ce48fd4f1d5d2cd239c82b88a8b9b47a6a  comparator-ChangedCost.log
2b29f09ecc6858169671cd483e9e4398b27df9e8cfeecc570d527ac1490cff76  comparator-SorryProof.log
e288edd6efbf893e249c01a96b5a70b1e780b16752e9733167c36ceb2a7a5aab  ring-queue/1791557812451628000-2aa7a8.log
9cd9c5eeb85cdd94b458af18a4bce40ce21b12269b845258ea2e41e22862279b  ring-queue/1791557832666381000-053bf2.log
0f93c4ef4fc8afa69d6291c75a6f195d24258b5e5d262a3af0ea32c8056c0882  ring-queue/1791557921875737000-4a30e6.log
```

Model, Challenge and dependency-manifest hashes are separately frozen in
[pins.json](pins.json). The imported source manifest and upstream attribution
are retained in [UPSTREAM.md](../../UPSTREAM.md).
