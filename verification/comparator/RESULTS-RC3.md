# Verification receipt: unchanged all-rings proof on Lean rc3

**PASS, 2026-10-10.** Full compilation, axiom guards, fresh-kernel replay,
Comparator with all six bundled checkers, and both deliberate rejection tests
passed on Lean 4.35.0-rc3.

The proof sources, dependency pins and executable audit harness checked here
are at [`fd3d1cf942ae05c1437d26cc0d83d813ce20a4c9`](https://github.com/selanavot/omega_le_nine_quarters_all_rings/tree/fd3d1cf942ae05c1437d26cc0d83d813ce20a4c9).
All 160 tracked Lean files under `lean/` are byte-identical to the preceding
`be15d1a0239bf682a31bde07d025d86fc5a3d521` version. Only the compiler/dependency
pins and the audit's toolchain/manifest pins changed. Later receipt, README
and paper-version edits do not change the proof or executable audit harness.

This downgrade addresses a Palomar **rendering** incompatibility. The original
rc4 proof had already passed verification; this run rechecks the unchanged
proof under the selected older environment. See the separate
[unmodified rc3 renderer receipt](../palomar/RC3-RENDER.md).

## Frozen specification and scope

```lean
theorem OAI.MatrixMultiplication.omega_le_nine_quarters_all_rings.{u} :
  ∀ (R : Type u) [Ring R], Arithmetic.omega R ≤ 9 / 4
```

All six frozen statements are unchanged: the ring upper bound, boundedness
below for nontrivial rings, nonempty admissible exponents, lower bound 2 for
nontrivial rings, direct positive-epsilon operation costs for all rings, and
exact integer coefficient identities. No definition holes are allowed. Each
audited axiom list is exactly `propext`, `Classical.choice`, `Quot.sound`.
The arithmetic model still differs from its imported baseline only by the
seven approved `Field` to `Ring` substitutions.

The upper bound includes the zero ring with the documented real-infimum
convention. The direct cost theorem avoids that convention. This is not an
exact endpoint O(n^(9/4)), efficient uniform generation or bit-complexity claim.

- Lean: `leanprover/lean4:v4.35.0-rc3`.
- Mathlib: `c55e6e786f49471c72fbddbec5415808896aec1e`.
- Root manifest SHA-256: `c05a9086b5052d029dc52feb20c3542df6fee766acff1ee14533b511146ed62c`.
- Challenge SHA-256: `e5ce8a1491d77029211b59a6b54d066e7e6a7449ef9c619c23e96c0a09b9978c`.
- Ring model SHA-256: `e98d51cf7cf83e7b7fa048b3d3b1a2bb4489d873c6c322be2c68b33802311a8d`.
- All nine dependency source checkouts match their pins and are clean.
- Physical per-project dependency copies; no shared-cache directory symlinks.
  `LEAN_PATH` remains inside this checkout and its rc3 toolchain.
- No local rc4 proof artifacts were copied into the rc3 checkout.

## Successful commands

```sh
LEAN_NUM_THREADS=1 lake build OAI OAI.LinearAlgebra.MatrixMultiplication.FinalAudit ComparatorAudit.Challenge ComparatorAudit.KernelAudit
bash scripts/check-kernel.sh
python3 scripts/check-comparator.py --trusted-local --negative-controls
```

All three exited **0**. The build completed 9,108 graph jobs, including cached
or replayed dependencies. An initial invocation also requested the nonexistent
`FixedPointTheorems.lean` library root and therefore exited 1 despite building
the actual theorem/audit targets successfully. Removing that mistaken extra
target produced the successful full command above. No Lean source was changed.
The imported fixed-point modules were built through the OAI dependency closure.

The kernel script exported all six claims and their complete transitive
dependency closure, then replayed it into an empty Lean kernel environment:

```text
Lean default kernel accepts the solution
PASS: complete six-claim dependency closure replayed in a fresh Lean kernel; unchanged source snapshot.
```

Comparator accepted the frozen declarations and all six claims:

```text
Lean paranoid kernel accepts the solution
checked 54710 declarations
lean4lean kernel accepts the solution
nanoda kernel accepts the solution
con-leche: accepted 54709 declarations (--verified)
con-leche kernel accepts the solution
con-ron: accepted 54709 declarations (--verified)
con-ron kernel accepts the solution
Lean default kernel accepts the solution
Your solution is okay!
PASS: six theorems, frozen definitions, standard axioms, bundled kernel checks.
```

Both deliberate failure controls were rerun in this environment:

```text
PASS negative control ChangedCost: exit 1; Const does not match between challenge and target
PASS negative control SorryProof: exit 1; Illegal axiom detected: 'sorryAx'
```

The first failure was specifically at `OAI.MatrixMultiplication.Arithmetic.Gate.cost`.
The generated controls were removed afterward. The final specification check
and both scripts' source-snapshot guards passed. The Challenge's six `sorry`
holes remain specification-only and are not imported by the actual proof.

## Limits and retained evidence

These checks used native macOS ARM64, one Lean thread and reused dependency
caches. Comparator's build sandbox was explicitly disabled for trusted local
sources. This is not a clean-source rebuild, Linux sandbox certification or
external toolchain-provenance audit. The full six-claim dependency closure was
replayed, not all unrelated Mathlib declarations. Formal verification validates
Lean declarations, not manuscript prose or historical novelty.

The [rc4 receipt](RESULTS.md) and [earlier nontrivial-ring receipt](RESULTS-NONTRIVIAL.md)
remain historical records. No new Palomar registration or Zenodo release is
established by this local run. Hosted verification must name its own exact
commit and report.

Detailed logs remain under ignored `.lake/rc3-verification/` and `.lake/`.
Their SHA-256 hashes identify these runs; reruns need not produce identical logs:

```text
a02962e8c7af6a69a8d4605902a95a5b1907517d736c88b9f6a54c2264dc8d4d  full-build.log
47209e6fe03fe6ec3f60c10b15b249f71d1f4a3f400e45d80e0284399da80439  kernel.log
e26b1cb95e75a5df3a420e45292249284652d23b2a25b7e8c98bd775e07a9ada  comparator.log
428a2ebf71940b4b611ceac6a0c10e16dfc161b37b12020d975568f4bd3fcdaf  comparator-ChangedCost.log
f3763c19683d367e7462aa4a6bc7316e011cf0c263466701ec3cc1052d7c4632  comparator-SorryProof.log
```

The local status file records the three successful stages and completion at
`2026-10-10T04:24:29.684185+00:00`. Independent AI source reviews found no changed proof
semantics, pin inconsistency or cache-directory sharing, and checked the
renderer output/hashes separately. They are not human peer review.
