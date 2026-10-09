module

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Character.Existence
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.CharacterTransport

public section

/-! Specification and axiom audit for the completed integral spectral layer.
This does not claim the final 9/4 profile bound. -/

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

/-- An explicit integer specialization rules out a hidden field hypothesis. -/
theorem integer_detecting_character {d k : ℕ} (hd : 2 ≤ d)
    (hk : (k : ℝ) < (d : ℝ) ^ exactRankExponent ℤ) :
    ∃ χ : Character ℤ,
      (k : ℝ) ≤ χ.value (matrixMultiplicationTensor (K := ℤ) d d d) :=
  exists_detecting_character hd hk

#print axioms integer_detecting_character
#print axioms UnitDominating.extend
#print axioms TensorSemiring.integer_scalar_two_not_unit_dominating
#print axioms Character.value_polynomialRestrictionDegeneration_le_ring
#print axioms Character.value_le_add_of_coprime_scaled_restrictions

end OAI.MatrixMultiplication.AuxiliarySeparation.Integral
