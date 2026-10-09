module

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.FiniteFieldLift
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.CoprimePatch
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Convolution.Basic

public section

@[expose] section

/-! Integral convolution rank at all tensor powers. A finite family of prime-
local clearing schemes is selected once, before the power parameter varies. -/

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

noncomputable section
open Foundation
open scoped BigOperators

/-- There is one constant overhead for all powers of integer convolution.
This is an exact coefficient identity, valid after mapping to any ring. -/
theorem convolution_integer_power_rank (a b : ℕ) :
    ∃ C : ℕ, 0 < C ∧ ∀ k : ℕ,
      Tensor.RankAtMost (Tensor.power (convolution (K := ℤ) a b) k)
        ((a + b - 1) ^ k * C) := by
  classical
  let T := convolution (K := ℤ) a b
  let h := a + b - 1
  let S : Set ℤ := {D | ∃ d : ℕ, 0 < d ∧ ∀ k : ℕ,
    Tensor.RankAtMost (fun x y z => D ^ k * Tensor.power T k x y z) (h ^ k * d * d)}
  have hprime (p : ℕ) (hp : p.Prime) : ∃ D ∈ S, ¬ (p : ℤ) ∣ D := by
    letI : Fact p.Prime := ⟨hp⟩
    obtain ⟨D, d, hD, hd, hscheme⟩ := exists_prime_clearing_convolution p a b
    refine ⟨D, ⟨d, hd, hscheme⟩, ?_⟩
    exact fun hdiv => hD ((ZMod.intCast_zmod_eq_zero_iff_dvd D p).mpr hdiv)
  obtain ⟨t, htS, u, hu⟩ := exists_finite_bezout_of_prime_witness S hprime
  have hschemes (i : t) : ∃ d : ℕ, 0 < d ∧ ∀ k : ℕ,
      Tensor.RankAtMost (fun x y z => (i : ℤ) ^ k * Tensor.power T k x y z)
        (h ^ k * d * d) := htS i.property
  choose d hd hscheme using hschemes
  have htne : t.Nonempty := by
    by_contra hempty
    have htzero : t = ∅ := Finset.not_nonempty_iff_eq_empty.mp hempty
    subst t
    simpa using hu
  obtain ⟨i, hi⟩ := htne
  have hC : 0 < ∑ j : t, d j * d j :=
    Finset.sum_pos' (fun _ _ => Nat.zero_le _) ⟨⟨i, hi⟩, Finset.mem_univ _,
      Nat.mul_pos (hd _) (hd _)⟩
  refine ⟨∑ j : t, d j * d j, hC, ?_⟩
  intro k
  exact rankAtMost_patch_power_family T (fun j : t => (j : ℤ)) u
    (fun j => d j * d j) h hu (fun j k => by simpa only [Nat.mul_assoc] using hscheme j k) k

end
end OAI.MatrixMultiplication.AuxiliarySeparation.Integral
