# omega_le_nine_quarters_all_rings

**Private work in progress. The ring theorem is not yet Lean-verified.**

This repository develops the matrix-multiplication 9/4 proof over arbitrary
nontrivial associative rings, through integer-coefficient bilinear schemes.
It derives from OpenAI’s proof and the earlier all-fields extension.
The initial source snapshot retains only the all-fields theorem dependency
closure and license/provenance files; it still proves only the prior field
statement. The new theorem, paper, and audits are in development.

All new proof development and manuscript drafting are AI-generated.
See `docs/IMPORT-MANIFEST.json` for the exact inherited source provenance.

## Development

Lean 4.35.0-rc4 and mathlib f0469b25d97aef3998d4bc06f6f01da670b3d18e
are pinned. Run `lake build` for the default target; while the ring proof is
under construction this target still exports the inherited all-fields entrypoint.
Follow `docs/STATUS.md` for exactly which new components have been checked.
The intended final statement is:

```lean
theorem omega_le_nine_quarters_all_rings
    (R : Type u) [Ring R] [Nontrivial R] :
    Arithmetic.omega R ≤ (9 : ℝ) / 4
```

The shared-machine build queue accepts module requests with
`python3 scripts/lean-queue.py submit --owner NAME Module.Name`.
Only the coordinator runs `worker`; `stop` drains the current build and exits.
