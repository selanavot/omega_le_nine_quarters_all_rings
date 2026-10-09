module

/-
Copyright (c) 2026. Released under Apache-2.0 as described in LICENSE.
Developed for the integral extension of OpenAI's matrix-multiplication proof.
-/

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.CoefficientExtraction
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Tensor.CharacterBounds
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Tensor.BinaryCharacter
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.CoprimePatch
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

namespace Integral

open MatrixMultiplication.Foundation
open scoped BigOperators

variable {R X Y Z U V W U' V' W' : Type*} [CommSemiring R]
variable [Fintype U] [Fintype V] [Fintype W]
variable [Fintype U'] [Fintype V'] [Fintype W']

/-- Different source-coordinate types may be combined by coproducts. -/
theorem restrict_sumTensor
    (T : Tensor R U V W) (S : Tensor R U' V' W')
    (A : X → U → R) (B : Y → V → R) (C : Z → W → R)
    (A' : X → U' → R) (B' : Y → V' → R) (C' : Z → W' → R) :
    Tensor.restrict (fun x => Sum.elim (A x) (A' x))
      (fun y => Sum.elim (B y) (B' y)) (fun z => Sum.elim (C z) (C' z))
      (sumTensor T S) =
      fun x y z => Tensor.restrict A B C T x y z + Tensor.restrict A' B' C' S x y z := by
  funext x y z
  simp [Tensor.restrict, sumTensor, Fintype.sum_sum_type]

/-- Scale one local map, rather than scalar-multiplying a character value. -/
theorem restrict_scale_right (T : Tensor R U V W)
    (A : X → U → R) (B : Y → V → R) (C : Z → W → R) (u : R) :
    Tensor.restrict A B (fun z w => u * C z w) T =
      fun x y z => u * Tensor.restrict A B C T x y z := by
  funext x y z
  simp only [Tensor.restrict, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro p hp
  apply Finset.sum_congr rfl
  intro q hq
  apply Finset.sum_congr rfl
  intro r hr
  ring

/-- Bezout patching with different source spaces. The scalar multipliers are
removed in the exact coefficient identity before applying any character. -/
theorem restriction_patch_binary
    (T : Tensor R X Y Z) (S : Tensor R U V W) (S' : Tensor R U' V' W')
    (d e u v : R) (huv : u * d + v * e = 1)
    (A : X → U → R) (B : Y → V → R) (C : Z → W → R)
    (A' : X → U' → R) (B' : Y → V' → R) (C' : Z → W' → R)
    (h : Tensor.restrict A B C S = fun x y z => d * T x y z)
    (h' : Tensor.restrict A' B' C' S' = fun x y z => e * T x y z) :
    Tensor.restrict (fun x => Sum.elim (A x) (A' x))
      (fun y => Sum.elim (B y) (B' y))
      (fun z => Sum.elim (fun w => u * C z w) (fun w => v * C' z w))
      (sumTensor S S') = T := by
  rw [restrict_sumTensor, restrict_scale_right, restrict_scale_right, h, h']
  funext x y z
  change u * (d * T x y z) + v * (e * T x y z) = T x y z
  calc
    _ = (u * d + v * e) * T x y z := by ring
    _ = _ := by rw [huv, one_mul]

end Integral

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
  simpa only [χ.value_power, mul_pow, mul_assoc] using h n

/-- A pair of coprime scalar powers is cancelled before applying monotonicity.
The two exact restrictions may have unrelated finite coordinate spaces. -/
theorem value_le_add_of_coprime_scaled_restrictions
    {U₁ V₁ W₁ U₂ V₂ W₂ : Type}
    [Fintype U₁] [Fintype V₁] [Fintype W₁]
    [Fintype U₂] [Fintype V₂] [Fintype W₂]
    (T : Tensor K X Y Z) (S₁ : Tensor K U₁ V₁ W₁) (S₂ : Tensor K U₂ V₂ W₂)
    {d e : K} (hde : IsCoprime d e) (n : ℕ)
    (h₁ : ∃ (A : X → U₁ → K) (B : Y → V₁ → K) (C : Z → W₁ → K),
      Tensor.restrict A B C S₁ = fun x y z => d ^ n * T x y z)
    (h₂ : ∃ (A : X → U₂ → K) (B : Y → V₂ → K) (C : Z → W₂ → K),
      Tensor.restrict A B C S₂ = fun x y z => e ^ n * T x y z) :
    χ.value T ≤ χ.value S₁ + χ.value S₂ := by
  obtain ⟨u, v, huv⟩ := hde.pow (m := n) (n := n)
  obtain ⟨A, B, C, h₁⟩ := h₁
  obtain ⟨A', B', C', h₂⟩ := h₂
  have heq := Integral.restriction_patch_binary T S₁ S₂ (d ^ n) (e ^ n) u v huv
    A B C A' B' C' h₁ h₂
  have h := χ.monotone (sumTensor S₁ S₂)
    (fun x => Sum.elim (A x) (A' x)) (fun y => Sum.elim (B y) (B' y))
    (fun z => Sum.elim (fun w => u * C z w) (fun w => v * C' z w))
  simpa only [heq, χ.value_sumTensor] using h

end Character
end OAI.MatrixMultiplication.AuxiliarySeparation
