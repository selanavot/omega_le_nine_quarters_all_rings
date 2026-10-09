module

public import OAI.LinearAlgebra.MatrixMultiplication.Model

public section

@[expose] section

/-!
# Zero-cost multiplication over a trivial ring

A single constant-zero register supplies every output, with no counted
arithmetic gates. Therefore every real exponent is admissible over a
subsingleton ring. The existing real-valued infimum is zero in this case by
Mathlib's convention `Real.sInf_univ`; the admissible set is not bounded below.
-/

namespace OAI.MatrixMultiplication.Arithmetic

universe u

/-- One zero constant register, shared by every output. Constants and output
wiring have zero cost in the original model. -/
def zeroConstantAlgorithm (R : Type u) [Ring R] (a b c : ℕ) :
    MatrixAlgorithm R a b c where
  registers := 1
  program := .step .nil (.constant 0)
  output := fun _ _ => 0

@[simp] theorem zeroConstantAlgorithm_cost (R : Type u) [Ring R] (a b c : ℕ) :
    (zeroConstantAlgorithm R a b c).cost = 0 := rfl

/-- All input and output matrices over a subsingleton ring are equal. -/
theorem zeroConstantAlgorithm_correct (R : Type u) [Ring R] [Subsingleton R]
    (a b c : ℕ) : (zeroConstantAlgorithm R a b c).Correct := by
  intro A B
  exact Subsingleton.elim _ _

/-- Zero arithmetic cost satisfies the positive-slack bound for every real
exponent, including negative exponents. -/
theorem admissibleExponent_of_subsingleton (R : Type u) [Ring R] [Subsingleton R]
    (τ : ℝ) : AdmissibleExponent R τ := by
  intro ε _hε
  refine ⟨1, zero_lt_one, ?_⟩
  intro n _hn
  refine ⟨zeroConstantAlgorithm R n n n, zeroConstantAlgorithm_correct R n n n, ?_⟩
  simpa only [zeroConstantAlgorithm_cost, Nat.cast_zero, one_mul] using
    Real.rpow_nonneg (Nat.cast_nonneg n) (τ + ε)

theorem admissibleExponent_set_eq_univ_of_subsingleton
    (R : Type u) [Ring R] [Subsingleton R] :
    {τ : ℝ | AdmissibleExponent R τ} = Set.univ :=
  Set.eq_univ_of_forall (admissibleExponent_of_subsingleton R)

/-- Nontriviality cannot be dropped from the bounded-below audit. -/
theorem admissibleExponent_not_bddBelow_of_subsingleton
    (R : Type u) [Ring R] [Subsingleton R] :
    ¬ BddBelow {τ : ℝ | AdmissibleExponent R τ} := by
  rw [admissibleExponent_set_eq_univ_of_subsingleton R]
  exact not_bddBelow_univ

/-- This is Mathlib's real-infimum convention for an unbounded-below set, not
an assertion that the set of all real exponents has a real greatest lower bound. -/
theorem omega_eq_zero_of_subsingleton (R : Type u) [Ring R] [Subsingleton R] :
    omega R = 0 := by
  unfold omega
  rw [admissibleExponent_set_eq_univ_of_subsingleton R]
  exact Real.sInf_univ

end OAI.MatrixMultiplication.Arithmetic
