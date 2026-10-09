module

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.SeparationDescent
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.CoprimePatch
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Character.Dot
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Tensor.CharacterBounds

public section

@[expose] section

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

noncomputable section
open Foundation
open scoped BigOperators

variable {M L : ℕ} {X Y Z : Type} [Fintype X] [Fintype Y] [Fintype Z]

abbrev CyclotomicIndex (L : ℕ) := Fin (Polynomial.cyclotomic L ℤ).natDegree

/-- One period supplies all powers of a scalar multiple, in a single fixed
finite free cyclotomic algebra. The degree bounds are chosen before n. -/
theorem separation_scalar_power_restrictions (hM : 0 < M) (hL : 5 * M ≤ L)
    (B : Fin M → Tensor ℤ X Y Z) :
    ∃ Lx Ly : ℕ, ∀ n : ℕ,
      ∃ (A : (Fin n → X × Fin M) →
          ((CyclotomicIndex L × CyclotomicIndex L) ×
            (ExtractionIndex Lx Ly n × (Fin n → Fin L × X))) → ℤ)
        (C : (Fin n → (Fin M × Y) × Fin M) →
          ((CyclotomicIndex L × CyclotomicIndex L) ×
            (ExtractionIndex Lx Ly n × (Fin n → Fin L × (Fin M × Y)))) → ℤ)
        (D : (Fin n → (Fin M × Z) × Fin M) →
          ((CyclotomicIndex L × CyclotomicIndex L) ×
            (ExtractionIndex Lx Ly n × (Fin n → Fin L × (Fin M × Z)))) → ℤ),
        Tensor.restrict A C D
          (descentSource (ι := CyclotomicIndex L)
            (Tensor.directSum (fun _ : Fin L => sharedFirstTensor B)) Lx Ly n) =
          fun x y z => (L : ℤ) ^ n * Tensor.power (separationTarget B) n x y z := by
  classical
  letI : NeZero L := ⟨by omega⟩
  let E := CyclotomicAlgebra L
  let BE : Fin M → Tensor E X Y Z := fun i x y z => algebraMap ℤ E (B i x y z)
  let ζ := cyclotomicUnit L
  let D := integralSeparationDegeneration hM hL (cyclotomicUnit_primitive L) BE
  let Lx := mapDegreeBound (leftPolynomialMap ζ : (X × Fin M) → (Fin L × X) → Polynomial E)
  let Ly := mapDegreeBound (middlePolynomialMap ζ :
    ((Fin M × Y) × Fin M) → (Fin L × (Fin M × Y)) → Polynomial E)
  let Lz := mapDegreeBound (rightPolynomialMap ζ :
    ((Fin M × Z) × Fin M) → (Fin L × (Fin M × Z)) → Polynomial E)
  have hs : Tensor.directSum (fun _ : Fin L => sharedFirstTensor BE) =
      fun x y z => algebraMap ℤ E (Tensor.directSum (fun _ : Fin L => sharedFirstTensor B) x y z) := by
    funext x y z
    simp only [Tensor.directSum, sharedFirstTensor, BE]
    split_ifs <;> simp
  have ht : (fun x y z => (L : E) * separationTarget BE x y z) =
      fun x y z => algebraMap ℤ E ((L : ℤ) * separationTarget B x y z) := by
    funext x y z
    simp only [separationTarget, BE]
    split_ifs <;> simp
  have D' : Tensor.PolynomialRestrictionDegeneration
      (fun x y z => algebraMap ℤ E (Tensor.directSum (fun _ : Fin L => sharedFirstTensor B) x y z))
      (fun x y z => algebraMap ℤ E ((L : ℤ) * separationTarget B x y z))
      (2 * M ^ 2) Lx Ly Lz := by
    simpa only [hs, ht] using D
  refine ⟨Lx, Ly, fun n => ?_⟩
  exact scalar_power_restriction_descend (cyclotomicBasis L) (cyclotomicProjection L)
    (cyclotomicProjection_one L) _ _ (L : ℤ) D' n

/-- Consecutive periods cancel their scalar powers by Bezout before a
character is evaluated. The constant and quadratic costs disappear in n. -/
theorem value_separationTarget_le_int (χ : Character ℤ) (hM : 0 < M)
    (B : Fin M → Tensor ℤ X Y Z) :
    χ.value (separationTarget B) ≤ 6 * (M : ℝ) * χ.value (sharedFirstTensor B) := by
  classical
  let L := 5 * M
  obtain ⟨Ax, Ay, hA⟩ := separation_scalar_power_restrictions hM (L := L) le_rfl B
  obtain ⟨Bx, By, hB⟩ := separation_scalar_power_restrictions hM (L := L + 1) (by omega) B
  let cA : ℝ := (Fintype.card (CyclotomicIndex L) : ℝ) ^ 2
  let cB : ℝ := (Fintype.card (CyclotomicIndex (L + 1)) : ℝ) ^ 2
  have hbound : χ.value (separationTarget B) ≤ (L + 1 : ℝ) * χ.value (sharedFirstTensor B) := by
    apply χ.value_le_mul_of_power_comparisons
      (sharedFirstTensor B) (separationTarget B) (Ax + Bx) (Ay + By) (cA + cB) (L + 1) (by positivity)
    intro n
    let SA := descentSource (ι := CyclotomicIndex L)
      (Tensor.directSum (fun _ : Fin L => sharedFirstTensor B)) Ax Ay n
    let SB := descentSource (ι := CyclotomicIndex (L + 1))
      (Tensor.directSum (fun _ : Fin (L + 1) => sharedFirstTensor B)) Bx By n
    have hc := χ.value_le_add_of_coprime_scaled_restrictions
      (Tensor.power (separationTarget B) n) SA SB (isCoprime_consecutive (L : ℤ)) n
      (hA n) (by simpa only [Nat.cast_add, Nat.cast_one] using hB n)
    have hv : 0 ≤ χ.value (sharedFirstTensor B) := χ.nonneg _
    have ha : χ.value SA ≤
        cA * ((n : ℝ) * (Ax + Bx) + 1) * (n * (Ay + By) + 1) *
          (L + 1 : ℝ) ^ n * χ.value (sharedFirstTensor B) ^ n := by
      dsimp [SA]
      rw [value_descentSource, χ.value_copies, mul_pow]
      dsimp [cA]
      simp only [mul_assoc]
      gcongr <;> first | positivity | linarith
    have hb : χ.value SB ≤
        cB * ((n : ℝ) * (Ax + Bx) + 1) * (n * (Ay + By) + 1) *
          (L + 1 : ℝ) ^ n * χ.value (sharedFirstTensor B) ^ n := by
      dsimp [SB]
      rw [value_descentSource, χ.value_copies, mul_pow]
      simp only [Nat.cast_add, Nat.cast_one]
      dsimp [cB]
      simp only [mul_assoc]
      gcongr <;> first | positivity | linarith
    have hsum := hc.trans (add_le_add ha hb)
    simp only [χ.value_power] at hsum ⊢
    convert hsum using 1 <;> ring
  have hL : (L + 1 : ℝ) ≤ 6 * (M : ℝ) := by
    dsimp [L]
    norm_num only [Nat.cast_mul, Nat.cast_ofNat]
    have hm : (1 : ℝ) ≤ M := by exact_mod_cast hM
    nlinarith
  exact hbound.trans (mul_le_mul_of_nonneg_right hL (χ.nonneg _))

theorem finiteSeparation_bound_int (χ : Character ℤ) (hM : 0 < M)
    (B : Fin M → Tensor ℤ X Y Z) :
    (∑ i, χ.value (B i)) * (M : ℝ) ^ χ.pX ≤
      6 * (M : ℝ) * χ.value (sharedFirstTensor B) := by
  have h := value_separationTarget_le_int χ hM B
  rw [separationTarget_eq_directSum, χ.value_reindex, χ.map_directSum] at h
  simpa only [χ.map_product, χ.value_cyclic_cyclic_dotPairing hM, Finset.sum_mul] using h

end
end OAI.MatrixMultiplication.AuxiliarySeparation.Integral
