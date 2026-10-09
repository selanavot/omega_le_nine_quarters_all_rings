module

/-
Copyright (c) 2026. Released under Apache-2.0 as described in LICENSE.
Developed for the integral extension of OpenAI's matrix-multiplication proof.
-/

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Tensor.Primitive
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Tensor.Scalar

public section

@[expose] section

namespace OAI.MatrixMultiplication.AuxiliarySeparation.TensorSemiring

/-!
# Primitive tensor classes

Only the zero tensor and classes admitting the unit by restriction are used
in spectral detection. The underlying order and rank remain ordinary exact
restriction and exact coefficient rank over the given coefficient semiring.
-/

noncomputable section

variable {K : Type*} [CommSemiring K] [Nontrivial K]

/-- The tensor subsemiring on which all nonzero objects dominate the unit. -/
abbrev PrimitiveClass (K : Type*) [CommSemiring K] [Nontrivial K] :=
  UnitDominating.subsemiring (zero_le (K := K))
    (fun _ _ _ _ ha hb => add_mono ha hb) (fun _ _ _ _ ha hb => mul_mono ha hb)

/-- Matrix multiplication is primitive, including its zero-dimensional boundary. -/
def primitiveMatrixClass (n : ℕ) : PrimitiveClass K := by
  refine ⟨matrixClass n, ?_⟩
  by_cases hn : n = 0
  · subst n
    left
    apply (classOf_eq_zero_iff _).mpr
    funext x y z
    exact Fin.elim0 x.1
  · right
    let i : Fin n := ⟨0, Nat.pos_of_ne_zero hn⟩
    apply one_le_classOf_of_coefficient_one
    refine ⟨(i, i), (i, i), (i, i), ?_⟩
    simp [matrixClass, matrixMultiplicationTensor]

@[simp] theorem coe_primitiveMatrixClass (n : ℕ) :
    (primitiveMatrixClass (K := K) n : TensorClass K) = matrixClass n := rfl

/-- Rank is unchanged on passing to the primitive subsemiring. -/
def primitiveRank (T : PrimitiveClass K) : ℕ := rank (T : TensorClass K)

@[simp] theorem primitiveRank_matrix (n : ℕ) :
    primitiveRank (primitiveMatrixClass (K := K) n) = exactMatrixRank K n :=
  rank_matrixClass n

theorem primitive_zero_le (T : PrimitiveClass K) : 0 ≤ T :=
  zero_le (T : TensorClass K)

theorem primitive_le_rank (T : PrimitiveClass K) :
    T ≤ (primitiveRank T : PrimitiveClass K) := le_rank (T : TensorClass K)

theorem primitive_one_le_of_ne_zero (T : PrimitiveClass K) (hT : T ≠ 0) :
    1 ≤ T :=
  UnitDominating.one_le_of_ne_zero _ _ _ T hT

theorem primitive_add_mono {A B C D : PrimitiveClass K}
    (hAB : A ≤ B) (hCD : C ≤ D) : A + C ≤ B + D :=
  add_mono hAB hCD

theorem primitive_mul_mono {A B C D : PrimitiveClass K}
    (hAB : A ≤ B) (hCD : C ≤ D) : A * C ≤ B * D :=
  mul_mono hAB hCD

/-- Every character on primitive classes extends to a total tensor character. -/
def extendPrimitiveCharacter (φ : PrimitiveClass K →+* ℝ) : TensorClass K →+* ℝ :=
  UnitDominating.extend φ

theorem extendPrimitiveCharacter_monotone (φ : PrimitiveClass K →+* ℝ)
    (hφ : Monotone φ) : Monotone (extendPrimitiveCharacter φ) :=
  UnitDominating.extend_monotone φ hφ

@[simp] theorem extendPrimitiveCharacter_matrix (φ : PrimitiveClass K →+* ℝ)
    (n : ℕ) : extendPrimitiveCharacter φ (matrixClass n) = φ (primitiveMatrixClass n) :=
  UnitDominating.extend_coe φ (primitiveMatrixClass n)

/-- A negative control: the nonzero scalar tensor `2` over integers does not
admit the unit by restriction. Thus primitive membership cannot be replaced
by mere nonzeroness in the integral spectral construction. -/
theorem integer_scalar_two_not_unit_dominating :
    ¬ (1 : TensorClass ℤ) ≤ classOf (fun (_ _ _ : PUnit.{1}) => (2 : ℤ)) := by
  intro h
  obtain ⟨A, B, C, heq⟩ := (classOf_le_iff _ _).mp h
  have hv := congrArg (fun T => T PUnit.unit PUnit.unit PUnit.unit) heq
  have hone : (1 : ℤ) =
      A PUnit.unit PUnit.unit * B PUnit.unit PUnit.unit * C PUnit.unit PUnit.unit * 2 := by
    simpa [MatrixMultiplication.Foundation.Tensor.restrict] using hv
  have hdiv : (2 : ℤ) ∣ 1 := by
    refine ⟨A PUnit.unit PUnit.unit * B PUnit.unit PUnit.unit * C PUnit.unit PUnit.unit, ?_⟩
    rw [hone]
    ring
  norm_num at hdiv

end

end OAI.MatrixMultiplication.AuxiliarySeparation.TensorSemiring
