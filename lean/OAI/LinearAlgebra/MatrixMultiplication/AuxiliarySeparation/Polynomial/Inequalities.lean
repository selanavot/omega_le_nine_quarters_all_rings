module

/-
Upstream source and modification notice
Modified from OpenAI's matrix-multiplication sources to support arbitrary fields.
See UPSTREAM.md for provenance and changes; Apache-2.0 license retained in LICENSE.
-/

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Convolution.Symmetry
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Character.Permutation
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Polynomial.Laws
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Determinant.Character
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Sector.Character
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Polynomial.ProductBounds
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Growth.Profile

public section

@[expose] section

namespace OAI

/-!
# The inequalities for the polynomial profile

The six character values are combined before the common probability law is
optimized. Each first-leg exponent occurs twice, so the total entropy exponent
is exactly six times the mean exponent used to normalize the profile.
-/

noncomputable section

open scoped BigOperators
open MatrixMultiplication.Foundation

namespace MatrixMultiplication.AuxiliarySeparation.Character

variable {K : Type*} [CommRing K] [Nontrivial K]

variable (χ : (Character K))

/-- All six permuted characters have the same mean singleton-leg exponent. -/
theorem permutedCharacter_meanExponent (i : Fin 6) :
    (χ.permutedCharacter i).meanExponent = χ.meanExponent := by
  fin_cases i <;> simp [permutedCharacter, meanExponent] <;> ring

/-- The exponents of the six permuted characters have the normalization total. -/
theorem sum_permutedCharacter_pX_mean :
    (∑ i : Fin 6, (χ.permutedCharacter i).pX) = 6 * χ.meanExponent := by
  rw [χ.sum_permutedCharacter_pX]
  unfold meanExponent
  ring

/-- All six factors associated to a positive-size polynomial tensor are positive. -/
theorem permutedCharacter_convolution_pos {a b : ℕ} (ha : 0 < a) (hb : 0 < b)
    (i : Fin 6) : 0 < (χ.permutedCharacter i).value ((convolution (K := K)) a b) :=
  (χ.permutedCharacter i).value_convolution_pos ha hb

/-- Exchanging the two output-side positions reorders the six convolution factors. -/
theorem prod_permutedCharacter_swapped_convolution (a b : ℕ) :
    (∏ i : Fin 6, (χ.permutedCharacter i).value
      (fun x z y => (convolution (K := K)) a b x y z)) =
    ∏ i : Fin 6, (χ.permutedCharacter i).value ((convolution (K := K)) a b) := by
  rw [χ.prod_permutedCharacter_value, χ.prod_permutedCharacter_value]
  exact χ.sixfoldProduct_swap23 _

/-- The actual polynomial profile is concave in its second positive index. -/
theorem convolutionProfile_concave_of_separation
    (hsep : ∀ ψ : Character K,
      ∀ {M : ℕ} {X' Y' Z' : Type} [Fintype X'] [Fintype Y'] [Fintype Z'],
        0 < M → ∀ B' : Fin M → Tensor K X' Y' Z',
          (∑ i, ψ.value (B' i)) * (M : ℝ) ^ ψ.pX ≤
            6 * (M : ℝ) * ψ.value (sharedFirstTensor B'))
    {a b : ℕ} (ht : 0 < χ.meanExponent)
    (ha : 0 < a) (hb : 2 ≤ b) :
    χ.convolutionProfile a (b - 1) + χ.convolutionProfile a (b + 1) ≤
      2 * χ.convolutionProfile a b := by
  have h := finite_product_concavity
    (fun i : Fin 6 => (χ.permutedCharacter i).value ((convolution (K := K)) a b))
    (fun i : Fin 6 => (χ.permutedCharacter i).value ((convolution (K := K)) a (b + 1)))
    (fun i : Fin 6 => (χ.permutedCharacter i).value ((convolution (K := K)) a (b - 1)))
    (fun i : Fin 6 => (χ.permutedCharacter i).pX)
    (mul_pos (by norm_num : (0 : ℝ) < 6) ht) χ.sum_permutedCharacter_pX_mean
    (fun i => χ.permutedCharacter_convolution_pos ha (by omega) i)
    (fun i => χ.permutedCharacter_convolution_pos ha (by omega) i)
    (fun i => χ.permutedCharacter_convolution_pos ha (by omega) i)
    (fun i q hq₀ hq₁ =>
      (χ.permutedCharacter i).convolution_concavity_tag_of_separation
        (hsep (χ.permutedCharacter i)) a b ha hb q hq₀ hq₁)
  simp only [χ.prod_permutedCharacter_value] at h
  change χ.convolutionProfile a (b + 1) + χ.convolutionProfile a (b - 1) ≤
    2 * χ.convolutionProfile a b at h
  simpa only [add_comm] using h

/-- The actual three-sector degeneration triples the normalized profile. -/
theorem convolutionProfile_tripling_of_separation
    (hsep : ∀ ψ : Character K,
      ∀ {M : ℕ} {X' Y' Z' : Type} [Fintype X'] [Fintype Y'] [Fintype Z'],
        0 < M → ∀ B' : Fin M → Tensor K X' Y' Z',
          (∑ i, ψ.value (B' i)) * (M : ℝ) ^ ψ.pX ≤
            6 * (M : ℝ) * ψ.value (sharedFirstTensor B'))
    {a h : ℕ} (ht : 0 < χ.meanExponent)
    (ha : 0 < a) (hh : 0 < h) :
    3 * χ.convolutionProfile a h ≤ χ.convolutionProfile a (3 * h + a - 1) := by
  have hsw : ∃ x z y, (fun i s r => convolution (K := K) a h i r s) x z y = 1 :=
    ⟨⟨0, ha⟩, convolutionOutput ⟨0, ha⟩ ⟨0, hh⟩, ⟨0, hh⟩, convolution_at_output _ _⟩
  have h := finite_product_tripling
    (fun i : Fin 6 => (χ.permutedCharacter i).value ((convolution (K := K)) a (3 * h + a - 1)))
    (fun i : Fin 6 => (χ.permutedCharacter i).value ((convolution (K := K)) a h))
    (fun i : Fin 6 => (χ.permutedCharacter i).value (fun x z y => (convolution (K := K)) a h x y z))
    (fun i : Fin 6 => (χ.permutedCharacter i).pX)
    (mul_pos (by norm_num : (0 : ℝ) < 6) ht) χ.sum_permutedCharacter_pX_mean
    (fun i => χ.permutedCharacter_convolution_pos ha (by omega) i)
    (fun i => χ.permutedCharacter_convolution_pos ha hh i)
    (fun i => zero_lt_one.trans_le
      ((χ.permutedCharacter i).one_le_value_of_coefficient_one hsw))
    (fun i => Sector.convolution_tripling_tag_of_separation (χ.permutedCharacter i)
      (hsep (χ.permutedCharacter i)) a h ha hh)
    (χ.prod_permutedCharacter_swapped_convolution a h)
  simpa only [χ.prod_permutedCharacter_value, convolutionProfile, symmetrizedProfile] using h

/-- The polynomial profile satisfies every hypothesis of the scalar growth theorem. -/
def toScalarProfile_of_separation_and_convolution
    (hsep : ∀ ψ : Character K,
      ∀ {M : ℕ} {X' Y' Z' : Type} [Fintype X'] [Fintype Y'] [Fintype Z'],
        0 < M → ∀ B' : Fin M → Tensor K X' Y' Z',
          (∑ i, ψ.value (B' i)) * (M : ℝ) ^ ψ.pX ≤
            6 * (M : ℝ) * ψ.value (sharedFirstTensor B'))
    (hconv : ∀ ψ : Character K, ∀ a b : ℕ,
      ψ.value (convolution (K := K) a b) ≤ (a + b - 1 : ℕ))
    (ht : 0 < χ.meanExponent) : ScalarProfile χ.meanExponent where
  value := χ.convolutionProfile
  positive a b ha hb := χ.convolutionProfile_pos (by omega) (by omega)
  symmetric a b _ _ := χ.convolutionProfile_comm a b
  boundary b hb := χ.convolutionProfile_one_left ht (by omega)
  concave a b ha hb := χ.convolutionProfile_concave_of_separation hsep ht (by omega) hb
  tripling a h ha hh := χ.convolutionProfile_tripling_of_separation hsep ht (by omega) (by omega)
  rank_bound a b ha hb := by
    have h := χ.convolutionProfile_le_of_character_value_bounds (a := a) (b := b) ht
      (fun ψ => hconv ψ a b)
    have hab : 1 ≤ a + b := by omega
    simpa only [Nat.cast_sub hab, Nat.cast_add, Nat.cast_one] using h

/-- Every actual tensor character has mean singleton-leg exponent at most `3/4`. -/
theorem meanExponent_le_three_quarters_of_separation_and_convolution
    (hsep : ∀ ψ : Character K,
      ∀ {M : ℕ} {X' Y' Z' : Type} [Fintype X'] [Fintype Y'] [Fintype Z'],
        0 < M → ∀ B' : Fin M → Tensor K X' Y' Z',
          (∑ i, ψ.value (B' i)) * (M : ℝ) ^ ψ.pX ≤
            6 * (M : ℝ) * ψ.value (sharedFirstTensor B'))
    (hconv : ∀ ψ : Character K, ∀ a b : ℕ,
      ψ.value (convolution (K := K) a b) ≤ (a + b - 1 : ℕ))
    : χ.meanExponent ≤ 3 / 4 := by
  by_cases ht : 0 < χ.meanExponent
  · exact (χ.toScalarProfile_of_separation_and_convolution hsep hconv ht).exponent_le_three_quarters ht
  · have hle : χ.meanExponent ≤ 0 := le_of_not_gt ht
    linarith

/-- The three dot-product exponents of an actual character sum to at most `9/4`. -/
theorem exponent_sum_le_nine_quarters_of_separation_and_convolution
    (hsep : ∀ ψ : Character K,
      ∀ {M : ℕ} {X' Y' Z' : Type} [Fintype X'] [Fintype Y'] [Fintype Z'],
        0 < M → ∀ B' : Fin M → Tensor K X' Y' Z',
          (∑ i, ψ.value (B' i)) * (M : ℝ) ^ ψ.pX ≤
            6 * (M : ℝ) * ψ.value (sharedFirstTensor B'))
    (hconv : ∀ ψ : Character K, ∀ a b : ℕ,
      ψ.value (convolution (K := K) a b) ≤ (a + b - 1 : ℕ))
    : χ.pX + χ.pY + χ.pZ ≤ 9 / 4 := by
  have h := χ.meanExponent_le_three_quarters_of_separation_and_convolution hsep hconv
  unfold meanExponent at h
  linarith

section Field

variable {K : Type*} [Field K] [IsAlgClosed K] (χ : Character K)

/-- Legacy field profile concavity, with the concrete separation theorem supplied. -/
theorem convolutionProfile_concave {a b : ℕ} (ht : 0 < χ.meanExponent)
    (ha : 0 < a) (hb : 2 ≤ b) :
    χ.convolutionProfile a (b - 1) + χ.convolutionProfile a (b + 1) ≤
      2 * χ.convolutionProfile a b :=
  χ.convolutionProfile_concave_of_separation (by
    intro ψ M X' Y' Z' _ _ _ hM B'
    exact ψ.finiteSeparation_bound hM B') ht ha hb

theorem convolutionProfile_tripling {a h : ℕ} (ht : 0 < χ.meanExponent)
    (ha : 0 < a) (hh : 0 < h) :
    3 * χ.convolutionProfile a h ≤ χ.convolutionProfile a (3 * h + a - 1) :=
  χ.convolutionProfile_tripling_of_separation (by
    intro ψ M X' Y' Z' _ _ _ hM B'
    exact ψ.finiteSeparation_bound hM B') ht ha hh

def toScalarProfile (ht : 0 < χ.meanExponent) : ScalarProfile χ.meanExponent :=
  χ.toScalarProfile_of_separation_and_convolution (by
    intro ψ M X' Y' Z' _ _ _ hM B'
    exact ψ.finiteSeparation_bound hM B') (fun ψ a b => ψ.value_convolution_le a b) ht

theorem meanExponent_le_three_quarters : χ.meanExponent ≤ 3 / 4 :=
  χ.meanExponent_le_three_quarters_of_separation_and_convolution (by
    intro ψ M X' Y' Z' _ _ _ hM B'
    exact ψ.finiteSeparation_bound hM B') (fun ψ a b => ψ.value_convolution_le a b)

theorem exponent_sum_le_nine_quarters : χ.pX + χ.pY + χ.pZ ≤ 9 / 4 :=
  χ.exponent_sum_le_nine_quarters_of_separation_and_convolution (by
    intro ψ M X' Y' Z' _ _ _ hM B'
    exact ψ.finiteSeparation_bound hM B') (fun ψ a b => ψ.value_convolution_le a b)

end Field

end MatrixMultiplication.AuxiliarySeparation.Character

end

end OAI
