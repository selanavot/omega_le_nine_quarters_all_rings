module

/-
Copyright (c) 2026. Released under Apache-2.0 as described in LICENSE.
Developed for the integral extension of OpenAI's matrix-multiplication proof.
-/

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.ConvolutionRank
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Growth.NormalizedProfile
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Growth.PolynomialOverhead
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Tensor.CharacterBounds

public section

@[expose] section

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Character

/-!
# Integral convolution character bounds

The exact integer rank of a single convolution tensor need not attain its
field bound. A fixed overhead for all powers is enough to give the same bound
for every tensor character, and hence for the normalized sixfold profile.
-/

variable (χ : Character ℤ)

/-- Finite coprime interpolation families give the sharp integral character
bound, even without a rank-`a+b-1` scheme over integers for the single tensor. -/
theorem value_convolution_le_int (a b : ℕ) :
    χ.value (convolution (K := ℤ) a b) ≤ ((a + b - 1 : ℕ) : ℝ) := by
  obtain ⟨C, _hC, h⟩ := Integral.convolution_integer_power_rank a b
  apply le_of_pow_le_const_mul_pow (C := (C : ℝ)) (Nat.cast_nonneg _)
  intro n
  have hn := χ.value_le_rank (h n)
  simpa only [χ.value_power, Nat.cast_mul, Nat.cast_pow, mul_comm] using hn

/-- The exact real profile bound needed by the unchanged growth argument. -/
theorem symmetrizedProfile_convolution_le_int (a b : ℕ) {t : ℝ} (ht : 0 < t) :
    χ.symmetrizedProfile t (convolution (K := ℤ) a b) ≤
      ((a + b - 1 : ℕ) : ℝ) ^ (1 / t) :=
  χ.symmetrizedProfile_le_of_character_value_bounds ht _
    (fun ψ => ψ.value_convolution_le_int a b)

end OAI.MatrixMultiplication.AuxiliarySeparation.Character
