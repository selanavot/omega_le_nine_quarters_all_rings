# Proof plan

## Current compatibility work

Local steps 1–4 passed on 2026-10-10 at source/pins/harness commit
`fd3d1cf942ae05c1437d26cc0d83d813ce20a4c9`; see
[the rc3 receipt](../verification/comparator/RESULTS-RC3.md). Documentation and
paper updates are prepared in
[PR #6](https://github.com/selanavot/omega_le_nine_quarters_all_rings/pull/6).
The [hosted mechanical preflight](https://github.com/selanavot/omega_le_nine_quarters_all_rings/actions/runs/38024128253)
passed exact candidate `9d10116c89f9bdcdaccd58aacea353d4b7ae6e90`. Later receipt
and documentation commits do not retarget that result. All six steps below
are complete; merging PR #6 and a corrected intake still require explicit
approval. The existing Zenodo archive and original submission remain unchanged.

1. Test the exact submitted Challenge against supported unmodified renderers
   before changing dependencies. The local rc3 rendering check passed.
2. Pin Lean 4.35.0-rc3 with Mathlib
   `c55e6e786f49471c72fbddbec5415808896aec1e` in an isolated worktree, preserving
   the arithmetic model, all six Challenge statements and Comparator settings.
3. Rebuild the complete proof and axiom audit; validate the frozen specification
   and clean dependency sources. Root alone runs builds, with one Lean thread.
4. Run fresh-kernel replay and Comparator with all bundled checkers, including
   both deliberate negative controls. Record completed outcomes separately from
   the original rc4 receipts; no success is inferred from rendering alone.
5. Update current build instructions and the paper's environment description.
   Preserve the published Zenodo snapshot and original Palomar submission.
6. Push the verified snapshot, open a compatibility PR, and run the official
   full mechanical preflight against that exact commit. Its merge and any
   replacement Palomar submission are separate actions; neither has been
   approved here.

## Original proof-development plan

1. Preserve the arithmetic semantics while generalizing to all rings, treating
   the trivial ring separately with its zero-cost program and real-infimum convention.
2. Generalize coefficient rank and restriction semiring to commutative rings.
3. Use the zero-or-1-restricting tensor subsemiring for spectral detection;
   extend its characters to all tensors by chi(T+1)-1 if verified.
4. Prove polynomial coefficient extraction without interpolation, finite free
   descent with fixed degree-squared overhead, and coprime scalar patching.
5. Implement integral Fourier separation via consecutive periods and
   asymptotic convolution interpolation via coprime norm denominators.
6. Port determinant/profile/growth arguments and prove integer exponent ≤9/4.
7. Convert integer bilinear schemes to programs over arbitrary associative
   rings using central integer constants and unchanged input order.
8. Audit full theorem, definitions, dependencies and axioms; Comparator and
   clean kernel replay. Draft paper in parallel but label status honestly.
9. Push private PR for review. No merge without approval for that PR.

Reviewed mathematical input: local research checkpoint7de4777, specifically
round9_integral_descent and its independent audits. Rectangular extensions
are out of the first target's scope.
