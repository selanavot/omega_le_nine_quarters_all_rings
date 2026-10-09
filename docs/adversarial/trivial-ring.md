# Adversarial source review: including the trivial ring

Date: 2026-10-09. Reviewer: Codex agent `beame_scope_review`, separately
assigned within the development team. This is AI source review, not human
peer review or an independent kernel check.

## Result

**No blocking defect found in the authorized strengthening.** The new
upper-bound signature includes every `Ring`, while the bounded-below and
lower-bound statements correctly retain `Nontrivial`. The zero-ring branch
uses both a real zero-cost program and the existing real-infimum convention;
it does not pretend that all real numbers have a real greatest lower bound.

I read `Arithmetic/TrivialRing.lean`, the `AllRings.lean` and
`FinalAudit.lean` changes, the Comparator Challenge/Solution changes, the
zero-ring manuscript remark and related statement edits, and the relevant
Mathlib real-infimum declarations. I did not start Lean/Lake, edit source or
paper, or perform external actions. This report therefore asserts no build,
axiom-check, kernel-replay, or Comparator-run verdict for the revised code.
Those checks belong to the coordinator's separate validation.

## Concrete checks

1. **Actual algorithm and cost.** `zeroConstantAlgorithm` has one register,
   containing `.constant 0`, and every output uses that register. This is a
   valid finite program even when matrix dimensions are zero; there is no
   attempt to point an output into an empty register set. Under the unchanged
   gate model the constant costs zero and output wiring is free, so the cost
   equality is definitional. The algorithm is defined for all rings; only its
   correctness theorem requires `Subsingleton R`. Its use of
   `Subsingleton.elim` is justified because both output matrices and the true
   product have entries in a subsingleton type.

2. **All exponents really are admissible.**
   `admissibleExponent_of_subsingleton` supplies the same positive constant
   `C = 1` and the explicit zero-cost program at every size. Its inequality is
   `0 ≤ n^(τ+ε)`, so it works for negative as well as positive τ. The
   admissible-exponent set is therefore exactly `Set.univ`, not merely a set
   containing 9/4. The separate theorem
   `admissibleExponent_not_bddBelow_of_subsingleton` correctly states that
   this set is not bounded below.

3. **Infimum convention is explicit and matches the dependency.**
   `omega_eq_zero_of_subsingleton` unfolds the unchanged definition of omega,
   substitutes the universal admissible set, and uses `Real.sInf_univ`.
   The pinned Mathlib source at
   `Mathlib/Algebra/Order/Archimedean/Real/Basic.lean` contains both
   `sInf_univ : sInf (Set.univ : Set ℝ) = 0` and
   `sInf_of_not_bddBelow : ¬ BddBelow s → sInf s = 0`.
   This is a totalized real-valued operation, not a genuine real infimum of
   an unbounded-below set. The paper explicitly says that an extended-real
   infimum would instead be negative infinity. Its zero-ring remark and the
   source documentation agree.

4. **The substantial proof remains confined to its valid case.**
   `omega_le_nine_quarters_all_rings` splits
   `subsingleton_or_nontrivial R`. It uses the preceding convention only in
   the subsingleton branch. The other branch invokes the existing exact
   integer-rank argument with a `Nontrivial` instance. It does not apply
   `csInf_le` to the unbounded-below admissible set. The direct cost theorem
   already applied to all rings and remains unchanged.

5. **Audit hypotheses are preserved.** `FinalAudit.infimum_bounded_below`
   and `FinalAudit.ring_lower_bound` still require `[Nontrivial R]`.
   The new audit statements include `omega PUnit = 0`, a general
   subsingleton zero-cost witness, and axiom inspections for both all-real
   admissibility and failure of boundedness. This does not claim the false
   inequality `2 ≤ omega PUnit`.

6. **Comparator spec changed only where authorized.** Relative to HEAD,
   Challenge and Solution each change exactly the `omega_bound` signature
   by removing `[Nontrivial R]`. Their bounded-below and lower-bound targets
   retain that hypothesis. The direct-cost and literal integer-coefficient
   statements are unchanged. I compared the Challenge bytes before the
   frozen-model marker with HEAD: they are identical.

7. **No model or lower-bound mutation.** A byte comparison against HEAD
   confirmed that `Model.lean`, `Arithmetic/LowerBound.lean`, and
   `Arithmetic/Exponent.lean` are unchanged. The model therefore retains the
   original ring-generalized program semantics, positive slack, gate costs,
   correctness quantifiers, and `sInf` definition. This check is relative to
   the preceding checked ring snapshot, not a new full upstream provenance
   audit.

## Limits and presentation

The upper bound for the zero ring is mathematically harmless but obtains the
displayed numerical omega value from the chosen totalization convention.
The operational fact is stronger and independent of that convention:
matrix multiplication has cost exactly zero. The current paper and README
explain this distinction. The strengthening adds no new asymptotic algorithm
for nontrivial rings and does not remove the hypotheses needed by their
lower bounds.

The paper labels verification of the revised statement as pending and
distinguishes it from completed checks of the previous statement. This is
appropriate at this review stage. The existing receipts must not be treated
as a replay of the new proof until the coordinator's reruns finish.

## Snapshot anchors

Base HEAD: `2cc45b7` (`Record complete kernel and Comparator verification
results`). Reviewed worktree SHA-256 values:

```text
163f45cbb1b34ab526a4cf8c493170c1f727660578ed3f94972fae7bdfabc5d5  Arithmetic/TrivialRing.lean
7670f17aeb69763394ad5c587508b69f5e688d8954cfe8617459c6d3c97d30d9  AllRings.lean
7e0fd708ecd954d5a7dc68012761a62eb3e51508df301dd40d8ee8f8954ec9e1  FinalAudit.lean
e5ce8a1491d77029211b59a6b54d066e7e6a7449ef9c619c23e96c0a09b9978c  ComparatorAudit/Challenge.lean
f694719c443323ec3b824afea68604a173465ae5205ba5254bf3f36ae09b24b0  ComparatorAudit/Solution.lean
e40d0998bfe98880be482fcd53ea84f08e717e27ff7e11f73f2c94d2b1aa6ecf  paper/paper.tex
e98d51cf7cf83e7b7fa048b3d3b1a2bb4489d873c6c322be2c68b33802311a8d  Model.lean (unchanged)
3af151109d3c08c5e7d5652a1f1f35db363261516d29f81f2c0b25353bff27b0  Arithmetic/LowerBound.lean (unchanged)
73b4144c592b2c8f1137f074edb3de838b839485d875883501bb54e78b58c89d  Arithmetic/Exponent.lean (unchanged)
```
