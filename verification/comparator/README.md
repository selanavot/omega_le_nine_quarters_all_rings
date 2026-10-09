# Frozen-model Comparator verification

Status: harness prepared; current end-to-end Comparator and fresh-kernel runs
have not yet been recorded. Do not infer a verification result from the presence
of these files. Completed results will be saved here after the coordinator runs
the commands below.

The harness uses native `lake comparator` from Lean **4.35.0-rc4**, with its
bundled independent kernel checkers requested by `--paranoid`. The local run
explicitly disables the build sandbox. It is verification of trusted local
sources, not a sandbox-isolation or external provenance certification.

## Specification and attribution

`ComparatorAudit.Challenge` is compiled separately from the real proof. Its
arithmetic model is the complete imported all-fields model at immutable commit
`45f5de13717ea1e3323730fccdd3ef58bd0c68b3`, with exactly seven literal
`[Field F]` to `[Ring F]` substitutions and no other byte changed.
The baseline is the new repository's initial trimmed import; upstream OpenAI
and field-extension provenance remain in `UPSTREAM.md` and the import manifest.

The preserved definitions include gate evaluation and costs, program evaluation,
input/output coordinates, correctness for all input matrices, positive exponent
slack, a constant uniform over matrix sizes, and the infimum defining omega.
There is no commutativity assumption on the ring being multiplied.
`check-specification.py` independently reconstructs the seven substitutions,
compares both Model and the frozen Challenge, and checks hashes of the complete
Challenge statements, toolchain, and dependency manifest.

The Challenge has six theorem holes. They are a specification, not proof holes
in the actual development. Neither the real OAI proof nor the Solution/KernelAudit
imports Challenge. The actual six Solution theorems are:

1. `omega_bound`: omega(R)≤9/4 for every nontrivial ring in any universe.
2. `admissible_bddBelow`: the infimum's admissible set is bounded below.
3. `admissible_nonempty`: the admissible set is nonempty, also for the zero ring.
4. `omega_lower`: omega(R)≥2 for every nontrivial ring.
5. `epsilon_cost`: for every ring and positive epsilon, one positive constant
   bounds correct programs at every positive size by C*n^(9/4+epsilon).
6. `exact_coefficients`: exact **integer** rank-one coefficient identities for
   a matrix block of size at least two with at most n^(9/4+epsilon) terms.

The sixth theorem spells out all coordinates and integer coefficient vectors.
It imports no project tensor/rank definition into the Challenge. It is stronger
than equality of functions over any chosen finite field. The exponent theorem
does not assert an exact endpoint O(n^(9/4)), efficient uniform circuit generation,
or bit complexity for arbitrary ring encodings.

Root `comparator.json` and local `config.json` must be identical. No definition
holes are permitted. The only allowed axioms are `propext`, `Classical.choice`,
and `Quot.sound`. `ComparatorAudit.KernelAudit` also guards each theorem's exact
axiom list and imports the public theorem's representative-ring FinalAudit.

## Reproduction

Only the coordinator runs Lean/build/audit processes on this 24 GB host. Agents
may submit modules through the serialized queue. For normal compilation:

```sh
python3 scripts/lean-queue.py submit --owner audit ComparatorAudit.Challenge ComparatorAudit.KernelAudit
```

Before the dedicated audits, stop the queue worker and let its current build
finish. The verification commands take the same exclusive filesystem lock as
the worker and fail if it is still active. They force one Lean thread, check
sources against the pins, and reject source changes during their run.

Run from repository root, sequentially:

```sh
python3 scripts/check-specification.py
python3 scripts/verify-dependencies.py
bash scripts/check-kernel.sh
python3 scripts/check-comparator.py --trusted-local --negative-controls
```

`check-kernel.sh` builds KernelAudit and runs `leanchecker --fresh --verbose`.
This replays imported declarations in a fresh environment using **Lean's own
kernel**. It is distinct from the independent bundled kernels requested by
Comparator. Dependency validation verifies source checkouts and revisions;
generated ignored build caches are not independently source-audited by that
script. The fresh and independent kernel checks provide separate evidence.

The negative controls alter copies, never the real specification or proof:

- `ChangedCost` sets multiplication cost to zero in a separate Challenge and
  requires rejection specifically at `Arithmetic.Gate.cost`.
- `SorryProof` replaces the epsilon-cost proof in a separate Solution with
  `sorry` and requires rejection of `sorryAx`.

Generated control sources are removed in a `finally` block. Ignored detailed
logs remain under `.lake`. A run passes only when both controls fail for their
expected reasons. The checked source fingerprint excludes only these temporary
control files; ordinary proof, harness, and configuration changes abort the audit.
