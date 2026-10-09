module

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.Cyclotomic
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Separation.Fourier

public section

@[expose] section

/-! Fourier orthogonality in a domain without division by the period.
Negative exponents are powers of units, so no field structure is required. -/

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

open scoped BigOperators

variable {E : Type*} [CommRing E] [IsDomain E]

theorem sum_pow_root_of_unity (z : E) (L : ℕ) (hz : z ^ L = 1) :
    (∑ r ∈ Finset.range L, z ^ r) = if z = 1 then (L : E) else 0 := by
  classical
  split_ifs with h
  · simp [h]
  · have hsum : (1 - z) * ∑ r ∈ Finset.range L, z ^ r = 0 := by
      rw [mul_neg_geom_sum, hz, sub_self]
    exact (mul_eq_zero.mp hsum).resolve_left (sub_ne_zero.mpr (Ne.symm h))

theorem sum_unit_zpow_primitive_root {ζ : Eˣ} {L : ℕ}
    (hζ : IsPrimitiveRoot ζ L) (e : ℤ) :
    (∑ r ∈ Finset.range L, (↑(ζ ^ ((r : ℤ) * e)) : E)) =
      if (L : ℤ) ∣ e then (L : E) else 0 := by
  classical
  have hpow : (↑(ζ ^ e) : E) ^ L = 1 := by
    have h : (ζ ^ e) ^ L = 1 := by
      rw [← zpow_natCast, ← zpow_mul, mul_comm, zpow_mul, hζ.zpow_eq_one, one_zpow]
    exact_mod_cast h
  have hterm (r : ℕ) : (↑(ζ ^ ((r : ℤ) * e)) : E) = (↑(ζ ^ e) : E) ^ r := by
    have h : ζ ^ ((r : ℤ) * e) = (ζ ^ e) ^ r := by
      rw [← zpow_natCast, ← zpow_mul, mul_comm]
    exact_mod_cast h
  simp_rw [hterm]
  rw [sum_pow_root_of_unity _ _ hpow]
  have hone : (↑(ζ ^ e) : E) = 1 ↔ (L : ℤ) ∣ e := by
    rw [← Units.val_one, Units.val_inj, hζ.zpow_eq_one_iff_dvd]
  simp only [hone]

theorem sum_unit_zpow_primitive_root_of_abs_lt {ζ : Eˣ} {L : ℕ} {e : ℤ}
    (hζ : IsPrimitiveRoot ζ L) (he : |e| < (L : ℤ)) :
    (∑ r ∈ Finset.range L, (↑(ζ ^ ((r : ℤ) * e)) : E)) =
      if e = 0 then (L : E) else 0 := by
  rw [sum_unit_zpow_primitive_root hζ e]
  simp only [int_dvd_iff_eq_zero_of_abs_lt he]

end OAI.MatrixMultiplication.AuxiliarySeparation.Integral
