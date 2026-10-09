module

public import OAI.LinearAlgebra.MatrixMultiplication.AllRings

public section

@[expose] section

/-! Proofs for a separately compiled frozen challenge. Never import Challenge here.
The sixth statement uses literal integer coefficient identities, not project
rank definitions or equality restricted to a finite set of field inputs. -/

namespace ComparatorChecks

open scoped BigOperators
universe u
open OAI.MatrixMultiplication

theorem omega_bound (R : Type u) [Ring R] :
    Arithmetic.omega R ≤ (9 : ℝ) / 4 :=
  omega_le_nine_quarters_all_rings R

theorem admissible_bddBelow (R : Type u) [Ring R] [Nontrivial R] :
    BddBelow {τ : ℝ | Arithmetic.AdmissibleExponent R τ} :=
  Arithmetic.admissibleExponent_bddBelow R

theorem admissible_nonempty (R : Type u) [Ring R] :
    Set.Nonempty {τ : ℝ | Arithmetic.AdmissibleExponent R τ} :=
  Arithmetic.admissibleExponent_nonempty (F := R)

theorem omega_lower (R : Type u) [Ring R] [Nontrivial R] :
    (2 : ℝ) ≤ Arithmetic.omega R :=
  Arithmetic.omega_two_le (F := R)

theorem epsilon_cost (R : Type u) [Ring R] (ε : ℝ) (hε : 0 < ε) :
    ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, 1 ≤ n →
      ∃ P : Arithmetic.MatrixAlgorithm R n n n,
        P.Correct ∧ (P.cost : ℝ) ≤
          C * (n : ℝ) ^ ((9 : ℝ) / 4 + ε) :=
  matrix_multiplication_cost_le_nine_quarters_all_rings R ε hε

theorem exact_coefficients (ε : ℝ) (hε : 0 < ε) :
    ∃ n r : ℕ, 2 ≤ n ∧ (r : ℝ) ≤ (n : ℝ) ^ ((9 : ℝ) / 4 + ε) ∧
      ∃ (a : Fin r → (Fin n × Fin n) → ℤ)
        (b : Fin r → (Fin n × Fin n) → ℤ)
        (c : Fin r → (Fin n × Fin n) → ℤ),
        ∀ x y z : Fin n × Fin n,
          (if x.2 = y.1 ∧ y.2 = z.1 ∧ z.2 = x.1 then 1 else 0 : ℤ) =
            ∑ i, a i x * b i y * c i z :=
  by
    obtain ⟨n, r, hn, hRank, hr⟩ :=
      AuxiliarySeparation.exists_rankAtMost_of_exponent_slack (K := ℤ) hε
    have hBound : (r : ℝ) ≤ (n : ℝ) ^ ((9 : ℝ) / 4 + ε) := by
      apply hr.trans
      apply Real.rpow_le_rpow_of_exponent_le
      · exact_mod_cast (show 1 ≤ n by omega)
      · linarith [AuxiliarySeparation.Integral.exactRankExponent_int_le_nine_quarters]
    obtain ⟨a, b, c, h⟩ := hRank
    refine ⟨n, r, hn, hBound, a, b, c, ?_⟩
    intro x y z
    exact congrFun (congrFun (congrFun h x) y) z

end ComparatorChecks
