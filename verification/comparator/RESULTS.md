# Verification receipt: all rings including the trivial ring

Completed 2026-10-09. **PASS**: full compilation, axiom guards, fresh-kernel
replay, and native Comparator with all six bundled checkers.

The proof and verification harness checked here are at immutable revision
`63ddeef94ef18a08a9825c30f41b833c1a339260`. Subsequent changes affect only the
paper and documentation. The full build and both dedicated audits compared
source snapshots before and after execution; all exited successfully with
unchanged sources.

```lean
theorem OAI.MatrixMultiplication.omega_le_nine_quarters_all_rings.{u} :
  ∀ (R : Type u) [Ring R], Arithmetic.omega R ≤ 9 / 4
```

## Strengthened statement and specification

The upper bound now includes the trivial ring. Its explicit one-register
constant-zero program has cost zero and computes every matrix product.
Every real exponent is admissible in this case, so the admissible set is not
bounded below. The unchanged real-valued definition gives `omega R = 0`
by `Real.sInf_univ`; this is a convention, not a genuine real infimum.
The direct operation-count theorem also covers the trivial ring.

`Nontrivial R` remains on the lower bound 2 and BddBelow. Of the six frozen
Comparator statements, only the upper bound changed in this strengthening.
The model, the other five statements, costs, semantics and exponent definition
are unchanged from the preceding verified version.

- Lean: `leanprover/lean4:v4.35.0-rc4`.
- Mathlib: `f0469b25d97aef3998d4bc06f6f01da670b3d18e`.
- All nine dependency source checkouts matched the pinned manifest and were clean.
- Imported model baseline: `45f5de13717ea1e3323730fccdd3ef58bd0c68b3`.
- Model edits from that baseline: exactly seven literal `[Field F]` to
  `[Ring F]` substitutions; all other bytes are preserved.
- Six frozen claims: ring upper bound, BddBelow, nonempty admissible set,
  lower bound 2, direct positive-epsilon costs, and literal integer coefficients.
- No definition holes. The audited dependencies use only `propext`,
  `Classical.choice` and `Quot.sound`.
- Challenge SHA-256:
  `e5ce8a1491d77029211b59a6b54d066e7e6a7449ef9c619c23e96c0a09b9978c`.
- One Lean thread; no concurrent build worker during dedicated verification.

All specification and manifest hashes are retained in [pins.json](pins.json).

## Completed runs

```sh
LEAN_NUM_THREADS=1 lake build OAI OAI.LinearAlgebra.MatrixMultiplication.FinalAudit ComparatorAudit.Challenge ComparatorAudit.KernelAudit
bash scripts/check-kernel.sh
python3 scripts/check-comparator.py --trusted-local
```

All three commands exited **0**. The full build completed 9179 build-graph jobs,
including cached/replayed dependencies; this is not a count of fresh compilations.
FinalAudit additionally checks the explicit zero-cost program, `omega PUnit = 0`,
all-real admissibility, failure of BddBelow in the trivial case, and an example
over the noncommutative ring `Matrix (Fin 2) (Fin 2) ℤ`.

Both dedicated scripts enforce `check-specification.py` and
`verify-dependencies.py`. The kernel script exports the six claims and their
complete transitive proof/type/value/inductive dependency closure, then replays
the export into an empty Lean kernel environment. Its final output was:

```text
Lean default kernel accepts the solution
PASS: complete six-claim dependency closure replayed in a fresh Lean kernel; unchanged source snapshot.
```

Comparator accepted the frozen declarations and all six claims. Its output was:

```text
Lean paranoid kernel accepts the solution
checked 54838 declarations
lean4lean kernel accepts the solution
nanoda kernel accepts the solution
con-leche: accepted 54841 declarations (--verified)
con-leche kernel accepts the solution
con-ron: accepted 54841 declarations (--verified)
con-ron kernel accepts the solution
Lean default kernel accepts the solution
Your solution is okay!
PASS: six theorems, frozen definitions, standard axioms, bundled kernel checks.
```

The Challenge's six deliberate theorem holes are specification-only; they are
not imported into the actual proof or its kernel audit.

## Previous controls and independent source review

The earlier nontrivial-ring receipt, including both deliberate failure controls,
is preserved in [RESULTS-NONTRIVIAL.md](RESULTS-NONTRIVIAL.md). The control
implementation, gate-cost definition, and injected-sorry target are unchanged;
**the controls were not rerun for this strengthening**. At the earlier tested
revision `2553d35`, changed multiplication cost was rejected at
`Arithmetic.Gate.cost`, and the deliberately unproved cost theorem was rejected
for `sorryAx`. These are previous-run evidence for the unchanged control harness,
not additional executions against the strengthened statement.

A separate [review of the trivial-ring change](../../docs/adversarial/trivial-ring.md)
found no blocking defect. The earlier reviews of
[mathematics](../../docs/adversarial/mathematics.md),
[specification and arithmetic](../../docs/adversarial/specification.md), and
[reproducibility](../../docs/adversarial/reproducibility.md) cover the preceding
substantive proof. All are AI source reviews, not independent human peer review.

## Scope and retained log fingerprints

Verification used trusted local sources and existing dependency caches.
Comparator's build sandbox was explicitly disabled. This is not a clean-source
rebuild, a sandbox-isolation audit, or external authentication of toolchain
provenance. The complete target dependency closure was freshly replayed;
unrelated imported Mathlib declarations were not all replayed. An earlier broad
`leanchecker --fresh MODULE` run was stopped without a verdict and is not counted
as a successful check. Formal verification validates Lean declarations, not the
manuscript's prose or historical novelty.

Detailed logs and the phase exit-code receipt remain under ignored `.lake/`.
The following SHA-256 hashes identify these completed local logs; rerunning
commands need not reproduce identical log bytes:

```text
ca2834eb773f27313d68743ac40f37fb1f2023f63d53d811cc52b2c7ed347c23  all-rings-zero-build.log
3989813709830cfc969d44c2f0d989af3c7423966559797e201713e6b432ecc5  zero-ring-kernel-audit.log
1611170954ba46f3e16f33887b95f2279359befa90f4df0563eefc662f0cf959  zero-ring-comparator-audit.log
```

`.lake/zero-ring-verification-process.json` records exit code 0 for each dedicated
audit. Upstream attribution and imported source provenance are in
[UPSTREAM.md](../../UPSTREAM.md).
