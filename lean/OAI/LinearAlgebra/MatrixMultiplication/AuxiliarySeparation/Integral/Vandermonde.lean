module

public import Mathlib.LinearAlgebra.Vandermonde
public import Mathlib.LinearAlgebra.Matrix.Adjugate
public import Mathlib.LinearAlgebra.Matrix.ToLin
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.FiniteFreeDescent

public section

@[expose] section

/-!
# Integral interpolation using adjugates

A Vandermonde adjugate supplies an exact scheme for its determinant times
convolution, even when that determinant is not a unit. A second adjugate,
of multiplication by that determinant in a finite free algebra, replaces the
algebra-valued multiplier with its base-ring norm. No localization is used.
-/

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

noncomputable section
open Foundation
open scoped BigOperators Matrix

variable {R : Type*} [CommRing R]

/-- Adjugate interpolation is a coefficient identity over every commutative ring. -/
theorem vandermonde_adjugate_coefficient {h : ℕ} (v : Fin h → R) (m k : Fin h) :
    (Matrix.vandermonde v).det * (if m = k then 1 else 0) =
      ∑ r, v r ^ m.val * (Matrix.vandermonde v).adjugate k r := by
  have heq := congrFun (congrFun (Matrix.adjugate_mul (Matrix.vandermonde v)) k) m
  simpa [Matrix.mul_apply, Matrix.vandermonde, Matrix.one_apply,
    mul_comm, eq_comm] using heq.symm

/-- A length `a+b-1` rank scheme for the Vandermonde determinant times ordinary
polynomial convolution. Nodes may coincide; no invertibility is asserted. -/
theorem rankAtMost_vandermonde_convolution (a b : ℕ)
    (v : Fin (a + b - 1) → R) :
    Tensor.RankAtMost
      (fun (i : Fin a) (j : Fin b) (k : Fin (a + b - 1)) =>
        (Matrix.vandermonde v).det * (if i.val + j.val = k.val then 1 else 0))
      (a + b - 1) := by
  refine ⟨(fun r i => v r ^ i.val), (fun r j => v r ^ j.val),
    (fun r k => (Matrix.vandermonde v).adjugate k r), ?_⟩
  funext i j k
  let m : Fin (a + b - 1) := ⟨i.val + j.val, by
    have hi := i.isLt
    have hj := j.isLt
    omega⟩
  simpa only [Tensor.rankOne, ← pow_add, Fin.ext_iff] using
    vandermonde_adjugate_coefficient v m k

/-- The adjugate of multiplication by `delta`, applied to the coordinate vector
of 1. This is an element of the original algebra, with no denominator. -/
def normCofactor {E ι : Type*} [CommRing E] [Algebra R E]
    [Fintype ι] [DecidableEq ι] (basis : Module.Basis ι R E) (delta : E) : E :=
  basis.equivFun.symm ((Algebra.leftMulMatrix basis delta).adjugate *ᵥ basis.repr 1)

/-- `delta` divides its multiplication-matrix determinant inside the algebra.
This holds for every finite free commutative algebra, including zero divisors. -/
theorem mul_normCofactor {E ι : Type*} [CommRing E] [Algebra R E]
    [Fintype ι] [DecidableEq ι] (basis : Module.Basis ι R E) (delta : E) :
    delta * normCofactor basis delta =
      algebraMap R E (Algebra.leftMulMatrix basis delta).det := by
  apply basis.equivFun.injective
  simp only [Module.Basis.equivFun_apply]
  rw [← Algebra.leftMulMatrix_mulVec_repr]
  have hw : (basis.repr (normCofactor basis delta) : ι → R) =
      (Algebra.leftMulMatrix basis delta).adjugate *ᵥ basis.repr 1 := by
    simpa only [Module.Basis.equivFun_apply, normCofactor] using basis.equivFun.apply_symm_apply
      ((Algebra.leftMulMatrix basis delta).adjugate *ᵥ basis.repr 1)
  rw [hw, Matrix.mulVec_mulVec, Matrix.mul_adjugate,
    Matrix.smul_mulVec, Matrix.one_mulVec]
  rw [Algebra.algebraMap_eq_smul_one, map_smul]
  rfl

/-- The same interpolation scheme after clearing the algebra-valued determinant
by its integral multiplication-matrix determinant. -/
theorem rankAtMost_norm_convolution {E ι : Type*} [CommRing E] [Algebra R E]
    [Fintype ι] [DecidableEq ι] (basis : Module.Basis ι R E)
    (a b : ℕ) (v : Fin (a + b - 1) → E) :
    Tensor.RankAtMost
      (fun (i : Fin a) (j : Fin b) (k : Fin (a + b - 1)) =>
        algebraMap R E (Algebra.leftMulMatrix basis (Matrix.vandermonde v).det).det *
          (if i.val + j.val = k.val then 1 else 0))
      (a + b - 1) := by
  have h := (rankAtMost_vandermonde_convolution a b v).scale
    (normCofactor basis (Matrix.vandermonde v).det)
  convert h using 1
  funext i j k
  rw [← mul_normCofactor basis (Matrix.vandermonde v).det]
  ring

end
end OAI.MatrixMultiplication.AuxiliarySeparation.Integral
