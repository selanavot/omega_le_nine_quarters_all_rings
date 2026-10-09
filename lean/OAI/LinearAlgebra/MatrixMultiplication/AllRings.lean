module

/-
Copyright (c) 2026. Released under Apache-2.0 as described in LICENSE.
Integral extension of OpenAI's matrix-multiplication proof and its all-fields
extension. See UPSTREAM.md for provenance and attribution.
-/

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Character.Existence
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Arithmetic.CharacterRounding
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Polynomial.Inequalities
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.FiniteSeparation
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.ConvolutionCharacter
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.Arithmetic

public section

@[expose] section

/-!
# Matrix multiplication over every nontrivial ring

Exact integer coefficient schemes give the bound `9/4` over every associative
unital ring, including noncommutative rings. The arithmetic exponent uses the
same program semantics, gate costs, positive slack, and infimum as the prior
all-fields theorem. Nontriviality makes its infimum bounded below.

The direct operation-count theorem also includes the zero ring. Its exponent
is `9/4 + ε` for every positive `ε`; it does not assert an exact `O(n^(9/4))`
operation bound or a uniform circuit-generation algorithm.
-/

namespace OAI.MatrixMultiplication

universe u

namespace AuxiliarySeparation.Integral

/-- The exact integer coefficient rank exponent is at most `9/4`.
Both finite separation and convolution bounds are supplied by proved integral
constructions, with no field or algebraic-closure hypothesis. -/
theorem exactRankExponent_int_le_nine_quarters :
    exactRankExponent ℤ ≤ (9 : ℝ) / 4 := by
  apply exactRankExponent_le_nine_quarters_of_characters
  · intro d hd k hk
    exact exists_detecting_character hd hk
  · intro χ d hd
    rw [χ.value_matrixMultiplication (by omega)]
    apply Real.rpow_le_rpow_of_exponent_le
      (by exact_mod_cast (show 1 ≤ d by omega))
    apply χ.exponent_sum_le_nine_quarters_of_separation_and_convolution
    · intro ψ M X Y Z _ _ _ hM B
      exact finiteSeparation_bound_int ψ hM B
    · intro ψ a b
      exact ψ.value_convolution_le_int a b

end AuxiliarySeparation.Integral

/-- The square matrix multiplication exponent over every nontrivial
associative unital ring is at most `9/4`. -/
theorem omega_le_nine_quarters_all_rings (R : Type u) [Ring R] [Nontrivial R] :
    Arithmetic.omega R ≤ (9 : ℝ) / 4 :=
  (AuxiliarySeparation.Integral.omega_le_exactRankExponent_int R).trans
    AuxiliarySeparation.Integral.exactRankExponent_int_le_nine_quarters

/-- Every ring admits the positive-slack arithmetic bound at exponent `9/4`.
This statement also includes the zero ring. -/
theorem admissibleExponent_nine_quarters_all_rings (R : Type u) [Ring R] :
    Arithmetic.AdmissibleExponent R ((9 : ℝ) / 4) := by
  intro ε hε
  obtain ⟨C, hC, hbound⟩ :=
    AuxiliarySeparation.Integral.exactRankExponent_int_admissible R ε hε
  refine ⟨C, hC, ?_⟩
  intro n hn
  obtain ⟨P, hP, hcost⟩ := hbound n hn
  refine ⟨P, hP, hcost.trans ?_⟩
  apply mul_le_mul_of_nonneg_left _ hC.le
  apply Real.rpow_le_rpow_of_exponent_le (by exact_mod_cast hn)
  exact add_le_add
    AuxiliarySeparation.Integral.exactRankExponent_int_le_nine_quarters (le_refl ε)

/-- For each positive slack there is one constant valid for every matrix size,
and division-free arithmetic programs with the original gate-count model. -/
theorem matrix_multiplication_cost_le_nine_quarters_all_rings
    (R : Type u) [Ring R] (ε : ℝ) (hε : 0 < ε) :
    ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, 1 ≤ n →
      ∃ P : Arithmetic.MatrixAlgorithm R n n n,
        P.Correct ∧ (P.cost : ℝ) ≤ C * (n : ℝ) ^ ((9 : ℝ) / 4 + ε) :=
  admissibleExponent_nine_quarters_all_rings R ε hε

end OAI.MatrixMultiplication
