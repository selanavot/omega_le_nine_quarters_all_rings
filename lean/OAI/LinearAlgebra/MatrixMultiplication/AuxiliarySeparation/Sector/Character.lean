module

/-
Upstream source and modification notice
Modified from OpenAI's matrix-multiplication sources to support arbitrary fields.
See UPSTREAM.md for provenance and changes; Apache-2.0 license retained in LICENSE.
-/

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Sector.Degeneration
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Character.Degeneration
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.CharacterTransport
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Polynomial.Laws
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Tensor.TagInequality
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Sector.Branches
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Separation.BranchTagging

public section

@[expose] section

namespace OAI

/-!
# The character inequality from the three-sector degeneration

The retained tensor has three branches sharing its actual first-input space.
Their two remaining coordinate intervals determine matching branch labels.
The uniform three-branch tag inequality and polynomial degeneration then yield
the character inequality of Section 5.2 before symmetrization.
-/

noncomputable section

open scoped BigOperators Classical
open MatrixMultiplication.Foundation

namespace MatrixMultiplication.AuxiliarySeparation.Sector

variable {K : Type*} [CommRing K] [Nontrivial K]

/-- The actual three retained tensors in their original ambient spaces. -/
def branchFamily (a h : ℕ) (b : Fin 3) :
    Tensor K (Fin a) (YIndex a h) (ZIndex a h) :=
  if b = 0 then leftTensor (K := K) a h
  else if b = 1 then middleTensor (K := K) a h
  else rightTensor (K := K) a h

@[simp] theorem branchFamily_zero (a h : ℕ) :
    branchFamily (K := K) a h 0 = leftTensor (K := K) a h := by simp [branchFamily]

@[simp] theorem branchFamily_one (a h : ℕ) :
    branchFamily (K := K) a h 1 = middleTensor (K := K) a h := by simp [branchFamily]

@[simp] theorem branchFamily_two (a h : ℕ) :
    branchFamily (K := K) a h 2 = rightTensor (K := K) a h := by simp [branchFamily]

/-- Label a second-leg coordinate by its interval. -/
def yLabel (a h : ℕ) (j : YIndex a h) : Fin 3 :=
  if j.val < h then 0 else if j.val < rightStart a h then 1 else 2

/-- Label a third-leg coordinate by its corresponding interval. -/
def zLabel (a h : ℕ) (k : ZIndex a h) : Fin 3 :=
  if k.val < h + a - 1 then 0 else if k.val < rightStart a h then 1 else 2

/-- Every nonzero branch coefficient lies in the two matching labelled sectors. -/
theorem branchFamily_labels (a h : ℕ) (b : Fin 3) (i : Fin a)
    (j : YIndex a h) (k : ZIndex a h) (hn : branchFamily (K := K) a h b i j k ≠ 0) :
    yLabel a h j = b ∧ zLabel a h k = b := by
  fin_cases b
  · have hb : LeftBranch a h i.val j.val k.val := by
      by_contra hb
      exact hn (by simp [branchFamily, leftTensor, hb])
    have h := (leftBranch_iff hb.support).mp hb
    simp [yLabel, zLabel, h.1, h.2]
  · have hb : MiddleBranch a h i.val j.val k.val := by
      by_contra hb
      exact hn (by simp [branchFamily, middleTensor, hb])
    rcases (middleBranch_iff hb.support).mp hb with ⟨⟨hy₀, hy₁⟩, ⟨hz₀, hz₁⟩⟩
    simp [yLabel, zLabel, not_lt.mpr hy₀, hy₁, not_lt.mpr hz₀, hz₁]
  · have hb : RightBranch a h i.val j.val k.val := by
      by_contra hb
      exact hn (by simp [branchFamily, rightTensor, hb])
    rcases (rightBranch_iff hb.support).mp hb with ⟨hy, hz⟩
    have hi := i.isLt
    have hy₀ : h ≤ j.val := by unfold rightStart at hy; omega
    have hz₀ : h + a - 1 ≤ k.val := by unfold rightStart at hz; omega
    simp [yLabel, zLabel, not_lt.mpr hy₀, not_lt.mpr hy,
      not_lt.mpr hz₀, not_lt.mpr hz]

/-- The branch family sums to exactly the retained tensor. -/
theorem sum_branchFamily (a h : ℕ) :
    (∑ b : Fin 3, branchFamily (K := K) a h b) = retained (K := K) a h := by
  simp only [Fin.sum_univ_three, branchFamily_zero, branchFamily_one, branchFamily_two]
  exact (retained_eq_three_branches (K := K) a h).symm

/-- The character comparison uses the actual polynomial degeneration. -/
theorem value_retained_le_source_ring (χ : (Character K)) (a h : ℕ) :
    χ.value (retained (K := K) a h) ≤ χ.value (source (K := K) a h) :=
  χ.value_polynomialRestrictionDegeneration_le_ring (restriction (K := K) a h)

/-- Both interval labels can be recovered without changing the common first
input, so the tagged branch tensor has precisely the retained tensor's value. -/
theorem value_sharedFirst_branchFamily (χ : (Character K)) (a h : ℕ) :
    χ.value (sharedFirstTensor (branchFamily (K := K) a h)) = χ.value (retained (K := K) a h) := by
  rw [χ.value_sharedFirstTensor_eq_sum (branchFamily (K := K) a h)
    (yLabel a h) (zLabel a h) (branchFamily_labels (K := K) a h), sum_branchFamily]

theorem branchFamily_nonzero {a h : ℕ} (ha : 0 < a) (hh : 0 < h)
    (b : Fin 3) : branchFamily (K := K) a h b ≠ 0 := by
  fin_cases b
  · simpa [branchFamily] using leftTensor_nonzero (K := K) ha hh
  · simpa [branchFamily] using middleTensor_nonzero (K := K) ha hh
  · simpa [branchFamily] using rightTensor_nonzero (K := K) ha hh

/-- All retained branches have a coefficient one in their displayed convolution
coordinates; the middle branch uses the recorded first-input reversal. -/
theorem branchFamily_coefficient_one {a h : ℕ} (ha : 0 < a) (hh : 0 < h)
    (b : Fin 3) : ∃ i j k, branchFamily (K := K) a h b i j k = 1 := by
  let i : Fin a := ⟨0, ha⟩
  let r : Fin h := ⟨0, hh⟩
  let z := convolutionOutput i r
  have hc : convolution (K := K) a h i r z = 1 := convolution_at_output i r
  fin_cases b
  · refine ⟨i, leftY a h r, leftZ a h z, ?_⟩
    have hp := congrFun (congrFun (congrFun (leftTensor_pullback (K := K) a h) i) r) z
    exact (show leftTensor (K := K) a h i (leftY a h r) (leftZ a h z) = _ from hp).trans hc
  · refine ⟨i.rev, middleY a h z, middleZ a h r, ?_⟩
    have hp := congrFun (congrFun (congrFun (middleTensor_pullback (K := K) a h) i) z) r
    exact (show middleTensor (K := K) a h i.rev (middleY a h z) (middleZ a h r) = _ from hp).trans hc
  · refine ⟨i, rightY a h r, rightZ a h z, ?_⟩
    have hp := congrFun (congrFun (congrFun (rightTensor_pullback (K := K) a h) i) r) z
    exact (show rightTensor (K := K) a h i (rightY a h r) (rightZ a h z) = _ from hp).trans hc

/-- The uniform branch product combines the two outer convolution values. -/
theorem uniform_branchFamily_product (χ : (Character K)) (a h : ℕ)
    (ha : 0 < a) (hh : 0 < h) :
    (∏ b, χ.value (branchFamily (K := K) a h b) ^ (FiniteLaw.uniform (Fin 3)).mass b) =
      χ.value ((convolution (K := K)) a h) ^ (2 / 3 : ℝ) *
        χ.value (exchangedConvolution (K := K) a h) ^ (1 / 3 : ℝ) := by
  rw [uniformThree_product]
  simp only [branchFamily_zero, branchFamily_one, branchFamily_two,
    value_leftTensor, value_middleTensor, value_rightTensor]
  have hc : 0 < χ.value ((convolution (K := K)) a h) :=
    lt_of_lt_of_le zero_lt_one (χ.one_le_value_of_coefficient_one
      ⟨⟨0, ha⟩, ⟨0, hh⟩, convolutionOutput ⟨0, ha⟩ ⟨0, hh⟩, convolution_at_output _ _⟩)
  calc
    χ.value ((convolution (K := K)) a h) ^ (1 / 3 : ℝ) *
        χ.value (exchangedConvolution (K := K) a h) ^ (1 / 3 : ℝ) *
        χ.value ((convolution (K := K)) a h) ^ (1 / 3 : ℝ) =
      (χ.value ((convolution (K := K)) a h) ^ (1 / 3 : ℝ) *
        χ.value ((convolution (K := K)) a h) ^ (1 / 3 : ℝ)) *
          χ.value (exchangedConvolution (K := K) a h) ^ (1 / 3 : ℝ) := by ring
    _ = _ := by
      rw [← Real.rpow_add hc]
      norm_num

/-- The per-character three-sector inequality, before multiplication over
the six tensor-leg permutations. All tensor values are actual convolution
values, with only the middle branch exchanging its last two legs. -/
theorem convolution_tripling_tag_of_separation (χ : Character K)
    (hsep : ∀ {M : ℕ} {X' Y' Z' : Type} [Fintype X'] [Fintype Y'] [Fintype Z'],
      0 < M → ∀ B' : Fin M → Tensor K X' Y' Z',
        (∑ i, χ.value (B' i)) * (M : ℝ) ^ χ.pX ≤
          6 * (M : ℝ) * χ.value (sharedFirstTensor B'))
    (a h : ℕ)
    (ha : 0 < a) (hh : 0 < h) :
    (3 : ℝ) ^ χ.pX * χ.value ((convolution (K := K)) a h) ^ (2 / 3 : ℝ) *
      χ.value (fun i s r => (convolution (K := K)) a h i r s) ^ (1 / 3 : ℝ) ≤
        χ.value ((convolution (K := K)) a (3 * h + a - 1)) := by
  have htag := χ.sharedFirst_tag_of_separation_of_coefficient_one hsep (FiniteLaw.uniform (Fin 3))
    (branchFamily (K := K) a h) (branchFamily_coefficient_one (K := K) ha hh)
  rw [uniformThree_entropy_factor, uniform_branchFamily_product χ a h ha hh,
    value_sharedFirst_branchFamily] at htag
  have hresult := htag.trans (value_retained_le_source_ring χ a h)
  change (3 : ℝ) ^ χ.pX * (χ.value ((convolution (K := K)) a h) ^ (2 / 3 : ℝ) *
    χ.value (fun i s r => (convolution (K := K)) a h i r s) ^ (1 / 3 : ℝ)) ≤
      χ.value ((convolution (K := K)) a (3 * h + a - 1)) at hresult
  simpa only [mul_assoc] using hresult

section Field

variable {K : Type*} [Field K]

theorem value_retained_le_source [Infinite K] (χ : Character K) (a h : ℕ) :
    χ.value (retained (K := K) a h) ≤ χ.value (source (K := K) a h) :=
  value_retained_le_source_ring χ a h

theorem convolution_tripling_tag [IsAlgClosed K] (χ : Character K) (a h : ℕ)
    (ha : 0 < a) (hh : 0 < h) :
    (3 : ℝ) ^ χ.pX * χ.value (convolution (K := K) a h) ^ (2 / 3 : ℝ) *
      χ.value (fun i s r => convolution (K := K) a h i r s) ^ (1 / 3 : ℝ) ≤
        χ.value (convolution (K := K) a (3 * h + a - 1)) :=
  convolution_tripling_tag_of_separation χ (by
    intro M X' Y' Z' _ _ _ hM B'
    exact χ.finiteSeparation_bound hM B') a h ha hh

end Field

end MatrixMultiplication.AuxiliarySeparation.Sector

end

end OAI
