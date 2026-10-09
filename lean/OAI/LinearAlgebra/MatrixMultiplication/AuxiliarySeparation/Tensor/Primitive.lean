module

/-
Copyright (c) 2026. Released under Apache-2.0 as described in LICENSE.
Developed for the integral extension of OpenAI's matrix-multiplication proof.
-/

public import Mathlib.Algebra.Ring.Subsemiring.Basic
public import Mathlib.Basic.Real.Basic
public import Mathlib.Tactic.Linarith
public import Mathlib.Tactic.Ring

public section

@[expose] section

namespace OAI.MatrixMultiplication.AuxiliarySeparation.UnitDominating

/-!
# The zero-or-unit-dominating subsemiring

The restriction semiring over integers need not have `1 ≤ x` for every
nonzero `x`. Its zero-or-unit-dominating part does. A real-valued character
on that part extends to the full semiring by `χ(x + 1) - 1`; no faithfulness
of the extended character on arbitrary nonzero elements is asserted.
-/

variable {S : Type*} [CommSemiring S] [Preorder S]
variable (hzero : ∀ x : S, 0 ≤ x)
variable (hadd : ∀ {a b c d : S}, a ≤ b → c ≤ d → a + c ≤ b + d)
variable (hmul : ∀ {a b c d : S}, a ≤ b → c ≤ d → a * c ≤ b * d)

/-- Elements that are zero or admit the unit below them in the order. -/
def subsemiring : Subsemiring S where
  carrier := {x | x = 0 ∨ 1 ≤ x}
  zero_mem' := Or.inl rfl
  one_mem' := Or.inr le_rfl
  add_mem' := by
    intro a b ha hb
    rcases ha with rfl | ha
    · simpa only [zero_add] using hb
    · exact Or.inr (ha.trans (by simpa only [add_zero] using hadd le_rfl (hzero b)))
  mul_mem' := by
    intro a b ha hb
    rcases ha with rfl | ha
    · exact Or.inl (zero_mul b)
    rcases hb with rfl | hb
    · exact Or.inl (mul_zero a)
    exact Or.inr (by simpa only [one_mul] using hmul ha hb)

/-- Adding one always places an element in the unit-dominating part. -/
def stabilize (x : S) : subsemiring hzero hadd hmul :=
  ⟨x + 1, Or.inr (by simpa only [zero_add] using hadd (hzero x) (le_refl 1))⟩

@[simp] theorem coe_stabilize (x : S) :
    (stabilize hzero hadd hmul x : S) = x + 1 := rfl

/-- Every nonzero element of this subsemiring dominates its unit. -/
theorem one_le_of_ne_zero (x : subsemiring hzero hadd hmul) (hx : x ≠ 0) :
    1 ≤ x := by
  rcases x.property with hz | hu
  · exact False.elim (hx (Subtype.ext hz))
  · exact hu

variable {hzero hadd hmul}

@[simp] theorem stabilize_zero :
    stabilize hzero hadd hmul 0 = 1 := by
  apply Subtype.ext
  simp only [coe_stabilize, zero_add, OneMemClass.coe_one]

theorem stabilize_one :
    stabilize hzero hadd hmul 1 = 1 + 1 := by
  apply Subtype.ext
  rfl

theorem stabilize_add (x y : S) :
    stabilize hzero hadd hmul (x + y) + 1 =
      stabilize hzero hadd hmul x + stabilize hzero hadd hmul y := by
  apply Subtype.ext
  change (x + y + 1) + 1 = (x + 1) + (y + 1)
  ring

theorem stabilize_mul (x y : S) :
    stabilize hzero hadd hmul (x * y) +
        stabilize hzero hadd hmul x + stabilize hzero hadd hmul y =
      stabilize hzero hadd hmul x * stabilize hzero hadd hmul y + 1 + 1 := by
  apply Subtype.ext
  change (x * y + 1) + (x + 1) + (y + 1) = (x + 1) * (y + 1) + 1 + 1
  ring

/-- Extend a character by additive stabilization. -/
def extend (φ : subsemiring hzero hadd hmul →+* ℝ) : S →+* ℝ where
  toFun x := φ (stabilize hzero hadd hmul x) - 1
  map_zero' := by simp only [stabilize_zero, map_one, sub_self]
  map_one' := by rw [stabilize_one, map_add, map_one]; ring
  map_add' x y := by
    have h := congrArg φ (stabilize_add (hzero := hzero) (hadd := hadd) (hmul := hmul) x y)
    simp only [map_add, map_one] at h
    linarith
  map_mul' x y := by
    have h := congrArg φ (stabilize_mul (hzero := hzero) (hadd := hadd) (hmul := hmul) x y)
    simp only [map_add, map_one, map_mul] at h
    nlinarith

@[simp] theorem extend_apply (φ : subsemiring hzero hadd hmul →+* ℝ) (x : S) :
    extend φ x = φ (stabilize hzero hadd hmul x) - 1 := rfl

/-- Stabilization agrees with the original character on its domain. -/
@[simp] theorem extend_coe (φ : subsemiring hzero hadd hmul →+* ℝ)
    (x : subsemiring hzero hadd hmul) : extend φ (x : S) = φ x := by
  have h : stabilize hzero hadd hmul (x : S) = x + 1 := by
    apply Subtype.ext
    rfl
  rw [extend_apply, h, map_add, map_one]
  ring

/-- The extension preserves restriction monotonicity. -/
theorem extend_monotone (φ : subsemiring hzero hadd hmul →+* ℝ)
    (hφ : Monotone φ) : Monotone (extend φ) := by
  intro x y hxy
  apply sub_le_sub_right (hφ ?_) 1
  exact hadd hxy le_rfl

/-- Its values are nonnegative, even on elements not dominating the unit. -/
theorem extend_nonneg (φ : subsemiring hzero hadd hmul →+* ℝ)
    (hφ : Monotone φ) (x : S) : 0 ≤ extend φ x := by
  have hx : (1 : subsemiring hzero hadd hmul) ≤ stabilize hzero hadd hmul x := by
    change (1 : S) ≤ x + 1
    simpa only [zero_add] using hadd (hzero x) (le_refl 1)
  have h := hφ hx
  rw [map_one] at h
  exact sub_nonneg.mpr h

end OAI.MatrixMultiplication.AuxiliarySeparation.UnitDominating
