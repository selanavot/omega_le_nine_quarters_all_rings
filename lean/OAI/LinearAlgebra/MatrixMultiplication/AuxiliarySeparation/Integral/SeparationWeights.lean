module

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.UnnormalizedFourier
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Separation.Basic
public import OAI.LinearAlgebra.MatrixMultiplication.Polynomial.ComplexPolynomialDegenerationComposition

public section

@[expose] section

/-! Polynomial (rather than Laurent polynomial) local weights for integral
separation. Adding M² to each of the last two weights moves the selected
coefficient from degree zero to degree 2M² without changing the target. -/

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

open scoped BigOperators

def leftDegree (g : ℤ) : ℕ := (firstWeight g).toNat
def middleDegree (M : ℕ) (h u : ℤ) : ℕ := ((M : ℤ) ^ 2 + secondWeight h u).toNat
def rightDegree (M : ℕ) (h v : ℤ) : ℕ := ((M : ℤ) ^ 2 + thirdWeight h v).toNat

theorem leftDegree_cast (g : ℤ) : (leftDegree g : ℤ) = firstWeight g :=
  Int.toNat_of_nonneg (sq_nonneg g)

theorem middleDegree_cast {M : ℕ} {h u : ℤ}
    (hh : 1 ≤ h ∧ h ≤ M) (hu : 1 ≤ u ∧ u ≤ M) :
    (middleDegree M h u : ℤ) = (M : ℤ) ^ 2 + secondWeight h u := by
  apply Int.toNat_of_nonneg
  have hs : h ^ 2 ≤ (M : ℤ) ^ 2 := sq_le_sq₀ (by omega) (by omega) |>.mpr hh.2
  have hprod : 0 ≤ h * u := mul_nonneg (by omega) (by omega)
  dsimp [secondWeight]
  nlinarith

theorem rightDegree_cast {M : ℕ} {h v : ℤ}
    (hh : 1 ≤ h ∧ h ≤ M) (hv : 1 ≤ v ∧ v ≤ M) :
    (rightDegree M h v : ℤ) = (M : ℤ) ^ 2 + thirdWeight h v := by
  apply Int.toNat_of_nonneg
  have hprod : h * v ≤ (M : ℤ) * M :=
    mul_le_mul hh.2 hv.2 (by omega) (by omega)
  dsimp [thirdWeight]
  nlinarith

theorem degree_sum_cast {M : ℕ} {g h u v : ℤ}
    (hh : 1 ≤ h ∧ h ≤ M) (hu : 1 ≤ u ∧ u ≤ M) (hv : 1 ≤ v ∧ v ≤ M) :
    ((leftDegree g + middleDegree M h u + rightDegree M h v : ℕ) : ℤ) =
      2 * (M : ℤ) ^ 2 + totalWeight g h u v := by
  push_cast
  rw [leftDegree_cast, middleDegree_cast hh hu, rightDegree_cast hh hv]
  unfold totalWeight
  ring

theorem degree_sum_ge_of_phase_zero {M : ℕ} {g h u v : ℤ}
    (hh : 1 ≤ h ∧ h ≤ M) (hu : 1 ≤ u ∧ u ≤ M) (hv : 1 ≤ v ∧ v ≤ M)
    (hp : phase g h u v = 0) :
    2 * M ^ 2 ≤ leftDegree g + middleDegree M h u + rightDegree M h v := by
  have hc := degree_sum_cast hh hu hv (g := g)
  have hw := totalWeight_nonneg_of_phase_eq_zero hp
  exact_mod_cast (show 2 * (M : ℤ) ^ 2 ≤
    ((leftDegree g + middleDegree M h u + rightDegree M h v : ℕ) : ℤ) by omega)

theorem degree_sum_eq_iff_of_phase_zero {M : ℕ} {g h u v : ℤ}
    (hh : 1 ≤ h ∧ h ≤ M) (hu : 1 ≤ u ∧ u ≤ M) (hv : 1 ≤ v ∧ v ≤ M)
    (hp : phase g h u v = 0) :
    leftDegree g + middleDegree M h u + rightDegree M h v = 2 * M ^ 2 ↔
      g = h ∧ u = v := by
  have hc := degree_sum_cast hh hu hv (g := g)
  have hzero : leftDegree g + middleDegree M h u + rightDegree M h v = 2 * M ^ 2 ↔
      totalWeight g h u v = 0 := by
    have hcast : ((2 * M ^ 2 : ℕ) : ℤ) = 2 * (M : ℤ) ^ 2 := by norm_cast
    omega
  exact hzero.trans (totalWeight_eq_zero_iff_of_phase_eq_zero hp)

variable {E : Type*} [CommRing E] [IsDomain E]

/-- The Fourier sum of one weighted branch, with no division. -/
noncomputable def weightedBranch (ζ : Eˣ) (M L : ℕ) (g h u v : ℤ) (c : E) :
    Polynomial E :=
  Polynomial.monomial (leftDegree g + middleDegree M h u + rightDegree M h v)
    ((∑ r ∈ Finset.range L, (↑(ζ ^ ((r : ℤ) * phase g h u v)) : E)) * c)

theorem weightedBranch_eq {ζ : Eˣ} {M L : ℕ} {g h u v : ℤ}
    (hM : 0 < M) (hL : 5 * M ≤ L) (hζ : IsPrimitiveRoot ζ L)
    (hg : 1 ≤ g ∧ g ≤ M) (hh : 1 ≤ h ∧ h ≤ M)
    (hu : 1 ≤ u ∧ u ≤ M) (hv : 1 ≤ v ∧ v ≤ M) (c : E) :
    weightedBranch ζ M L g h u v c =
      if phase g h u v = 0 then
        Polynomial.monomial (leftDegree g + middleDegree M h u + rightDegree M h v)
          ((L : E) * c) else 0 := by
  classical
  have he : |phase g h u v| < (L : ℤ) := by
    have hp := fourierPhase_abs_lt (by omega : (1 : ℤ) ≤ M) hh hg hu hv
    have hL' : (5 : ℤ) * M ≤ L := by exact_mod_cast hL
    exact hp.trans_le hL'
  unfold weightedBranch
  rw [sum_unit_zpow_primitive_root_of_abs_lt hζ he]
  split_ifs <;> simp

theorem weightedBranch_vanishes {ζ : Eˣ} {M L j : ℕ} {g h u v : ℤ}
    (hM : 0 < M) (hL : 5 * M ≤ L) (hζ : IsPrimitiveRoot ζ L)
    (hg : 1 ≤ g ∧ g ≤ M) (hh : 1 ≤ h ∧ h ≤ M)
    (hu : 1 ≤ u ∧ u ≤ M) (hv : 1 ≤ v ∧ v ≤ M)
    (hj : j < 2 * M ^ 2) (c : E) :
    (weightedBranch ζ M L g h u v c).coeff j = 0 := by
  rw [weightedBranch_eq hM hL hζ hg hh hu hv]
  split_ifs with hp
  · exact Polynomial.coeff_monomial_of_ne _
      (by have := degree_sum_ge_of_phase_zero hh hu hv hp; omega)
  · simp

theorem weightedBranch_leading {ζ : Eˣ} {M L : ℕ} {g h u v : ℤ}
    (hM : 0 < M) (hL : 5 * M ≤ L) (hζ : IsPrimitiveRoot ζ L)
    (hg : 1 ≤ g ∧ g ≤ M) (hh : 1 ≤ h ∧ h ≤ M)
    (hu : 1 ≤ u ∧ u ≤ M) (hv : 1 ≤ v ∧ v ≤ M) (c : E) :
    (weightedBranch ζ M L g h u v c).coeff (2 * M ^ 2) =
      if g = h ∧ u = v then (L : E) * c else 0 := by
  classical
  rw [weightedBranch_eq hM hL hζ hg hh hu hv]
  by_cases hp : phase g h u v = 0
  · simp only [hp, ↓reduceIte, Polynomial.coeff_monomial,
      degree_sum_eq_iff_of_phase_zero hh hu hv hp]
  · have hn : ¬ (g = h ∧ u = v) := by
      rintro ⟨rfl, rfl⟩
      exact hp (by simp [phase])
    simp [hp, hn]

end OAI.MatrixMultiplication.AuxiliarySeparation.Integral
