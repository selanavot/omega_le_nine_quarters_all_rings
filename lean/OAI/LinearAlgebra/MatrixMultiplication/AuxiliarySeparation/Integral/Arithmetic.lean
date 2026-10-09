module

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Arithmetic.RankExponent
public import OAI.LinearAlgebra.MatrixMultiplication.Arithmetic.Growth
public import OAI.LinearAlgebra.MatrixMultiplication.Arithmetic.Exponent

public section

@[expose] section

/-!
# Integer rank schemes give arithmetic algorithms over every ring

This bridge uses exact integer coefficient identities, rather than transferring
functional correctness from a finite coefficient field. Integer constants are
central in every associative unital ring, so the original recursive arithmetic
programs apply without commuting the two input values.

No numerical upper bound on the integer rank exponent is assumed here.
-/

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

universe u

/-- The exact integer rank exponent is an admissible arithmetic exponent over
every associative unital ring. This operation-count statement includes the
zero ring; nontriviality is needed only for the infimum lower bound below. -/
theorem exactRankExponent_int_admissible (R : Type u) [Ring R] :
    Arithmetic.AdmissibleExponent R (exactRankExponent ℤ) := by
  apply Arithmetic.admissibleExponent_of_int_rank_bounds
    (exactRankExponent_lower (K := ℤ))
  intro ε hε
  obtain ⟨n, r, hn, hrank, hr⟩ :=
    exists_rankAtMost_of_exponent_slack (K := ℤ) hε
  exact ⟨n, r, hn, hrank, hr⟩

/-- The unchanged arithmetic exponent over a nontrivial ring is bounded by
the exact integer coefficient rank exponent. -/
theorem omega_le_exactRankExponent_int (R : Type u) [Ring R] [Nontrivial R] :
    Arithmetic.omega R ≤ exactRankExponent ℤ :=
  Arithmetic.omega_le_of_admissibleExponent (exactRankExponent_int_admissible R)

/-- Explicit quantifier order for the arithmetic algorithms supplied by the
integer rank exponent, with one constant for all matrix sizes. -/
theorem matrix_multiplication_cost_le_exactRankExponent_int
    (R : Type u) [Ring R] (ε : ℝ) (hε : 0 < ε) :
    ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, 1 ≤ n →
      ∃ P : Arithmetic.MatrixAlgorithm R n n n,
        P.Correct ∧ (P.cost : ℝ) ≤ C * (n : ℝ) ^ (exactRankExponent ℤ + ε) :=
  exactRankExponent_int_admissible R ε hε

end OAI.MatrixMultiplication.AuxiliarySeparation.Integral
