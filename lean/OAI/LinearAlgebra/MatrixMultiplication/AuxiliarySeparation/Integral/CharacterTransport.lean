module

/-
Copyright (c) 2026. Released under Apache-2.0 as described in LICENSE.
Developed for the integral extension of OpenAI's matrix-multiplication proof.
-/

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.CoefficientExtraction
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Tensor.CharacterBounds
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Growth.PolynomialOverhead

public section

@[expose] section

namespace OAI.MatrixMultiplication.AuxiliarySeparation

open Filter
open scoped Topology

/-- An eventual quadratic prefactor does not change an exponential growth rate. -/
theorem le_of_eventually_pow_le_quadratic_mul_pow {a b A B C : ℝ}
    (ha : 0 ≤ a)
    (h : ∀ᶠ n : ℕ in atTop, b ^ n ≤ ((n : ℝ) ^ 2 * A + n * B + C) * a ^ n) :
    b ≤ a := by
  by_contra hba
  have hab : a < b := lt_of_not_ge hba
  have hb : 0 < b := lt_of_le_of_lt ha hab
  have hr₀ : 0 ≤ a / b := div_nonneg ha hb.le
  have hr₁ : a / b < 1 := (div_lt_one hb).2 hab
  have hquadratic := (tendsto_pow_const_mul_const_pow_of_lt_one 2 hr₀ hr₁).mul_const A
  have hlinear := (tendsto_self_mul_const_pow_of_lt_one hr₀ hr₁).mul_const B
  have hconstant := (tendsto_pow_atTop_nhds_zero_of_lt_one hr₀ hr₁).const_mul C
  have hlim : Tendsto (fun n : ℕ =>
      ((n : ℝ) ^ 2 * A + n * B + C) * (a / b) ^ n) atTop (𝓝 0) := by
    convert (hquadratic.add hlinear).add hconstant using 1 <;> try simp
    funext n
    ring
  have hbound : ∀ᶠ n : ℕ in atTop,
      1 ≤ ((n : ℝ) ^ 2 * A + n * B + C) * (a / b) ^ n := by
    filter_upwards [h] with n hn
    have hdiv := (div_le_div_iff_of_pos_right (pow_pos hb n)).2 hn
    simpa only [div_self (pow_ne_zero n hb.ne'), mul_div_assoc, div_pow] using hdiv
  have hfalse : (1 : ℝ) ≤ 0 := ge_of_tendsto hlim hbound
  linarith

/-- The product of the two local degree bounds is a harmless overhead. -/
theorem le_of_pow_le_const_product_linear_mul_pow {a b A B C : ℝ}
    (ha : 0 ≤ a)
    (h : ∀ n : ℕ, b ^ n ≤ C * ((n : ℝ) * A + 1) * (n * B + 1) * a ^ n) :
    b ≤ a := by
  apply le_of_eventually_pow_le_quadratic_mul_pow
    (A := C * A * B) (B := C * (A + B)) (C := C) ha
  apply Eventually.of_forall
  intro n
  convert h n using 1 <;> ring

namespace Character

open MatrixMultiplication.Foundation
open scoped BigOperators

variable {K : Type*} [CommRing K]
variable (χ : Character K)
variable {X Y Z X' Y' Z' : Type}
variable [Fintype X] [Fintype Y] [Fintype Z]
variable [Fintype X'] [Fintype Y'] [Fintype Z']

/-- Division-free polynomial coefficient extraction proves character
monotonicity over every commutative ring. No infinitude or field assumption
and no continuity of the character are needed. -/
theorem value_polynomialRestrictionDegeneration_le_ring
    {T : Tensor K X Y Z} {U : Tensor K X' Y' Z'} {k Lx Ly Lz : ℕ}
    (L : Tensor.PolynomialRestrictionDegeneration T U k Lx Ly Lz) :
    χ.value U ≤ χ.value T := by
  apply le_of_pow_le_const_product_linear_mul_pow
    (A := (Lx : ℝ)) (B := (Ly : ℝ)) (C := 1) (χ.nonneg T)
  intro n
  have h := χ.monotone
    (Tensor.directSum (fun _ : Fin (Lx * n + 1) × Fin (Ly * n + 1) => Tensor.power T n))
    (fun x (q : (Fin (Lx * n + 1) × Fin (Ly * n + 1)) × (Fin n → X)) =>
      ((L.power n).leftMap x q.2).coeff q.1.1)
    (fun y (q : (Fin (Lx * n + 1) × Fin (Ly * n + 1)) × (Fin n → Y)) =>
      ((L.power n).middleMap y q.2).coeff q.1.2)
    (fun z (q : (Fin (Lx * n + 1) × Fin (Ly * n + 1)) × (Fin n → Z)) =>
      Integral.shiftedCoeff ((L.power n).rightMap z q.2) (k * n)
        (q.1.1.val + q.1.2.val))
  rw [← (L.power n).extract, χ.value_power, χ.map_directSum] at h
  simp only [χ.value_power, Finset.sum_const, Finset.card_univ, Fintype.card_prod,
    Fintype.card_fin, nsmul_eq_mul, Nat.cast_mul, Nat.cast_add, Nat.cast_one] at h
  convert h using 1 <;> ring

/-- A fixed constant and two local polynomial degree bounds disappear in a
power comparison. The exponential source-copy factor `L^n` remains as `L`. -/
theorem value_le_mul_of_power_comparisons
    (T : Tensor K X Y Z) (U : Tensor K X' Y' Z') (A B C L : ℝ) (hL : 0 ≤ L)
    (h : ∀ n : ℕ, χ.value (Tensor.power U n) ≤
      C * ((n : ℝ) * A + 1) * (n * B + 1) * L ^ n * χ.value (Tensor.power T n)) :
    χ.value U ≤ L * χ.value T := by
  apply le_of_pow_le_const_product_linear_mul_pow
    (A := A) (B := B) (C := C) (mul_nonneg hL (χ.nonneg T))
  intro n
  have hn := h n
  rw [χ.value_power, χ.value_power, mul_pow]
  simpa only [χ.value_power, mul_assoc] using hn

end Character
end OAI.MatrixMultiplication.AuxiliarySeparation
