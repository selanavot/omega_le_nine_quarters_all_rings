module

/-
Upstream source and modification notice
Modified from OpenAI's matrix-multiplication sources and the all-fields extension
to support the integral/ring proof. Field-only claims remain explicitly scoped.
See UPSTREAM.md for provenance and changes; Apache-2.0 license retained in LICENSE.
-/

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Spectrum.StateObstruction
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Spectrum.MultiplicativeStates
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Spectrum.Obstruction
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Tensor.Characters
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Tensor.PrimitiveClass

public section

@[expose] section

namespace OAI

/-!
# Detecting characters over nontrivial commutative coefficient semirings

This proves Lemma 3.1, including Appendix A. Finite inconsistency would
produce a positive scalar-gain catalyst, ruled out by the exact-rank exponent.
A compact normalized state space on primitive tensor classes yields a
multiplicative state. Additive stabilization extends it to the full tensor
semiring and hence to the concrete coefficient-level character interface.
-/

noncomputable section

namespace MatrixMultiplication.AuxiliarySeparation

variable {K : Type*} [CommSemiring K] [Nontrivial K]

open MatrixMultiplication.Foundation

/-- Lemma 3.1: normalized, additive, multiplicative, restriction-monotone
characters detect every integer strictly below the exact-rank growth value. -/
theorem exists_detecting_character {d k : ℕ} (hd : 2 ≤ d)
    (hk : (k : ℝ) < (d : ℝ) ^ (exactRankExponent K)) :
    ∃ χ : (Character K), (k : ℝ) ≤ χ.value ((matrixMultiplicationTensor (K := K)) d d d) := by
  have hno (D s : TensorSemiring.PrimitiveClass K) (m : ℕ) (hm : 0 < m)
      (hcat : D + (m : TensorSemiring.PrimitiveClass K) +
          TensorSemiring.primitiveMatrixClass d * s ≤
        D + (k : TensorSemiring.PrimitiveClass K) * s) : False := by
    change (D : TensorSemiring.TensorClass K) + (m : TensorSemiring.TensorClass K) +
        TensorSemiring.matrixClass d * (s : TensorSemiring.TensorClass K) ≤
      (D : TensorSemiring.TensorClass K) + (k : TensorSemiring.TensorClass K) *
        (s : TensorSemiring.TensorClass K) at hcat
    by_cases hs : s = 0
    · subst s
      have hbad : (D : TensorSemiring.TensorClass K) + m ≤ (D : TensorSemiring.TensorClass K) := by
        simpa only [ZeroMemClass.coe_zero, mul_zero, add_zero] using hcat
      exact not_tensor_add_positive_nat_le_self (K := K) (D : TensorSemiring.TensorClass K) hm hbad
    · have hs1 : (1 : TensorSemiring.PrimitiveClass K) ≤ s :=
        TensorSemiring.primitive_one_le_of_ne_zero s hs
      have hbound := tensor_catalytic_obstruction_of_scalar_gain_of_one_le
        (K := K) (D := (D : TensorSemiring.TensorClass K)) (s := (s : TensorSemiring.TensorClass K))
        (d := d) (k := k) (m := m) (by omega) hs1 hcat
      exact (not_lt_of_ge hbound) hk
  have hnonempty := normalizedStates_nonempty_of_no_catalyst
    (TensorSemiring.primitiveRank (K := K)) (TensorSemiring.primitiveMatrixClass d) k
    TensorSemiring.primitive_zero_le TensorSemiring.primitive_le_rank
    (fun _ _ _ _ h₁ h₂ => TensorSemiring.primitive_add_mono h₁ h₂) hno
  have hdom (z x : TensorSemiring.PrimitiveClass K) :
      z * x ≤ (TensorSemiring.primitiveRank x : TensorSemiring.PrimitiveClass K) * z := by
    calc
      z * x ≤ z * (TensorSemiring.primitiveRank x : TensorSemiring.PrimitiveClass K) :=
        TensorSemiring.primitive_mul_mono le_rfl (TensorSemiring.primitive_le_rank x)
      _ = (TensorSemiring.primitiveRank x : TensorSemiring.PrimitiveClass K) * z := mul_comm _ _
  obtain ⟨φ, hφ, _, hdetect⟩ := exists_monotone_semiringHom_of_normalizedStates
    (TensorSemiring.primitiveRank (K := K)) (TensorSemiring.primitiveMatrixClass d) (k : ℝ)
    (fun z hz => TensorSemiring.primitive_one_le_of_ne_zero z hz)
    (fun _ _ _ h => TensorSemiring.primitive_mul_mono le_rfl h) hdom hnonempty
  let ψ := TensorSemiring.extendPrimitiveCharacter φ
  have hψ : Monotone ψ := TensorSemiring.extendPrimitiveCharacter_monotone φ hφ
  refine ⟨Character.ofTensorClassHom ψ hψ, ?_⟩
  change (k : ℝ) ≤ ψ (TensorSemiring.matrixClass d)
  simpa only [ψ, TensorSemiring.extendPrimitiveCharacter_matrix] using hdetect

end MatrixMultiplication.AuxiliarySeparation

end

end OAI
