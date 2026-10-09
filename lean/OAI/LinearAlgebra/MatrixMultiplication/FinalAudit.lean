module

public import OAI.LinearAlgebra.MatrixMultiplication.AllRings

public section

/-!
# Final statement and axiom audit

These declarations check the intended hypotheses and quantifier order directly.
The `#print axioms` commands record the transitive logical dependencies. They
are not a replacement for the separate fresh-kernel replay or Comparator audit.
-/

namespace OAI.MatrixMultiplication.FinalAudit

universe u

/-- The advertised statement requires only an arbitrary nontrivial ring. -/
theorem ring_statement (R : Type u) [Ring R] [Nontrivial R] :
    Arithmetic.omega R ≤ (9 : ℝ) / 4 :=
  omega_le_nine_quarters_all_rings R

/-- The admissible-exponent set really is bounded below for the same ring. -/
theorem infimum_bounded_below (R : Type u) [Ring R] [Nontrivial R] :
    BddBelow {τ : ℝ | Arithmetic.AdmissibleExponent R τ} :=
  Arithmetic.admissibleExponent_bddBelow R

/-- The original operation model gives the usual lower bound. -/
theorem ring_lower_bound (R : Type u) [Ring R] [Nontrivial R] :
    2 ≤ Arithmetic.omega R :=
  Arithmetic.omega_two_le

/-- Spell out the cost quantifiers independently of the exponent infimum. -/
theorem direct_cost_statement (R : Type u) [Ring R] (ε : ℝ) (hε : 0 < ε) :
    ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, 1 ≤ n →
      ∃ P : Arithmetic.MatrixAlgorithm R n n n,
        (∀ A B : Matrix (Fin n) (Fin n) R, P.eval A B = A * B) ∧
        (P.cost : ℝ) ≤ C * (n : ℝ) ^ ((9 : ℝ) / 4 + ε) :=
  matrix_multiplication_cost_le_nine_quarters_all_rings R ε hε

-- A concrete noncommutative coefficient ring checks that no commutativity
-- instance is being inferred through an unintended hidden hypothesis.
example : Arithmetic.omega (Matrix (Fin 2) (Fin 2) ℤ) ≤ (9 : ℝ) / 4 :=
  omega_le_nine_quarters_all_rings _

#print omega_le_nine_quarters_all_rings
#print Arithmetic.AdmissibleExponent
#print Arithmetic.omega
#print Arithmetic.MatrixAlgorithm.Correct
#print Arithmetic.Gate.cost
#print axioms ring_statement
#print axioms infimum_bounded_below
#print axioms ring_lower_bound
#print axioms direct_cost_statement
#print axioms AuxiliarySeparation.Integral.exactRankExponent_int_le_nine_quarters
#print axioms AuxiliarySeparation.Integral.omega_le_exactRankExponent_int

end OAI.MatrixMultiplication.FinalAudit
