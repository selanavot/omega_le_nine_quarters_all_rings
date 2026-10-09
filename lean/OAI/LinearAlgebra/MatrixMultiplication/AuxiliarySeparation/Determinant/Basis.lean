module

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Determinant.Kernel
public import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

public section

@[expose] section

namespace OAI

/-!
# The finite adapted basis for the determinant filtration

The quotient vectors and determinant-kernel vectors of Section 5.1 form a basis
of the actual space of bidegree `(e,1)` forms. The proof works over every commutative ring,
including in the boundary case `e = 0` where the kernel has dimension zero.
-/

noncomputable section

namespace MatrixMultiplication.AuxiliarySeparation.DeterminantBasis

open Polynomial

variable {R : Type*} [CommRing R]

/-- Affine coefficient pairs of forms of bidegree `(e,1)`. -/
abbrev BoundedPair (R : Type*) [CommRing R] (e : ℕ) :=
  degreeLT R (e + 1) × degreeLT R (e + 1)

/-- Forget the degree bounds in the affine representation of binary forms. -/
def forget (e : ℕ) : BoundedPair R e →ₗ[R] DeterminantKernel.FormPair R where
  toFun p := ((p.1 : R[X]), (p.2 : R[X]))
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

theorem forget_injective (e : ℕ) : Function.Injective (forget (R := R) e) := by
  intro p q h
  apply Prod.ext <;> apply Subtype.ext
  · exact congrArg Prod.fst h
  · exact congrArg Prod.snd h

/-- A quotient vector with both coefficient polynomials of degree at most `e`. -/
def quotientVector (e : ℕ) (j : Fin (e + 2)) : BoundedPair R e :=
  if h : (j : ℕ) < e + 1 then
    (⟨X ^ (j : ℕ), mem_degreeLT.mpr ((degree_X_pow_le _).trans_lt (by exact_mod_cast h))⟩, 0)
  else
    (0, ⟨X ^ e, mem_degreeLT.mpr ((degree_X_pow_le _).trans_lt (by exact_mod_cast Nat.lt_succ_self e))⟩)

/-- A bounded kernel vector, obtained by multiplication by `uw-vs`. -/
def kernelVector (e : ℕ) (j : Fin e) : BoundedPair R e :=
  (⟨-(X ^ ((j : ℕ) + 1)), mem_degreeLT.mpr <| by
      rw [degree_neg]
      exact (degree_X_pow_le _).trans_lt (by exact_mod_cast (show (j : ℕ) + 1 < e + 1 by omega))⟩,
   ⟨X ^ (j : ℕ), mem_degreeLT.mpr <|
      (degree_X_pow_le _).trans_lt (by exact_mod_cast (show (j : ℕ) < e + 1 by omega))⟩)

/-- The quotient vectors first, followed by the determinant-kernel vectors. -/
def vector (e : ℕ) : (Fin (e + 2) ⊕ Fin e) → BoundedPair R e :=
  Sum.elim (quotientVector e) (kernelVector e)

@[simp] theorem forget_quotientVector (e : ℕ) (j : Fin (e + 2)) :
    forget e (quotientVector (R := R) e j) = DeterminantKernel.quotientVector e j := by
  unfold quotientVector DeterminantKernel.quotientVector
  split_ifs <;> rfl

@[simp] theorem forget_kernelVector (e : ℕ) (j : Fin e) :
    forget e (kernelVector (R := R) e j) = DeterminantKernel.kernelVector e j := by
  apply Prod.ext
  · change -(X ^ ((j : ℕ) + 1)) = -X * X ^ (j : ℕ)
    rw [pow_succ, mul_comm, neg_mul]
  · rfl

@[simp] theorem forget_vector (e : ℕ) (j : Fin (e + 2) ⊕ Fin e) :
    forget e (vector (R := R) e j) =
      Sum.elim (DeterminantKernel.quotientVector e) (DeterminantKernel.kernelVector e) j := by
  cases j <;> simp [vector]

/-- Linear independence holds over a general commutative coefficient ring. -/
theorem vector_linearIndependent (e : ℕ) : LinearIndependent R (vector (R := R) e) := by
  apply LinearIndependent.of_comp (forget e)
  simpa only [Function.comp_def, forget_vector] using
    DeterminantKernel.adaptedVectors_linearIndependent (R := R) e

/-- The dimension of the original space of forms is twice `e+1`. -/
theorem finrank_boundedPair (K : Type*) [Field K] (e : ℕ) :
    Module.finrank K (BoundedPair K e) = 2 * (e + 1) := by
  have h : Module.finrank K (degreeLT K (e + 1)) = e + 1 := by
    simpa using Module.finrank_eq_card_basis (degreeLT.basis K (e + 1))
  rw [Module.finrank_prod, h]
  omega

/-- The adapted vectors span over an arbitrary commutative ring: each ordinary
monomial pair is either a quotient vector or a quotient-plus-kernel vector. -/
theorem vector_span (e : ℕ) :
    ⊤ ≤ Submodule.span R (Set.range (vector (R := R) e)) := by
  classical
  let b := (degreeLT.basis R (e + 1)).prod (degreeLT.basis R (e + 1))
  rw [← b.span_eq]
  apply Submodule.span_le.mpr
  rintro _ ⟨j, rfl⟩
  have hv (i : Fin (e + 2) ⊕ Fin e) :
      vector (R := R) e i ∈ Submodule.span R (Set.range (vector (R := R) e)) :=
    Submodule.subset_span ⟨i, rfl⟩
  cases j with
  | inl j =>
      have heq : b (Sum.inl j) = vector e (Sum.inl ⟨j.val, by omega⟩) := by
        apply forget_injective e
        simp [b, forget, Module.Basis.prod_apply, degreeLT.basis_val,
          vector, quotientVector, show j.val < e + 1 from j.isLt]
      rw [heq]
      exact hv _
  | inr j =>
      by_cases hj : j.val < e
      · have heq : b (Sum.inr j) =
            vector e (Sum.inl ⟨j.val + 1, by omega⟩) + vector e (Sum.inr ⟨j.val, hj⟩) := by
          apply forget_injective e
          simp [b, forget, Module.Basis.prod_apply, degreeLT.basis_val,
            vector, quotientVector, kernelVector, show j.val + 1 < e + 1 by omega]
        rw [heq]
        exact Submodule.add_mem _ (hv _) (hv _)
      · have hje : j.val = e := by omega
        have heq : b (Sum.inr j) = vector e (Sum.inl ⟨e + 1, by omega⟩) := by
          apply forget_injective e
          simp [b, forget, Module.Basis.prod_apply, degreeLT.basis_val,
            vector, quotientVector, hje]
        rw [heq]
        exact hv _

/-- The same adapted basis exists over every commutative ring. -/
def basis (R : Type*) [CommRing R] (e : ℕ) :
    Module.Basis (Fin (e + 2) ⊕ Fin e) R (BoundedPair R e) :=
  Module.Basis.mk (vector_linearIndependent e) (vector_span e)

@[simp] theorem basis_apply (R : Type*) [CommRing R] (e : ℕ)
    (j : Fin (e + 2) ⊕ Fin e) : basis R e j = vector e j := by
  exact Module.Basis.mk_apply _ _ _

/-- Forgetting degree bounds identifies the finite basis with the explicit
polynomial-pair formulas. -/
@[simp] theorem forget_basis (K : Type*) [CommRing K] (e : ℕ)
    (j : Fin (e + 2) ⊕ Fin e) :
    forget e (basis K e j) =
      Sum.elim (DeterminantKernel.quotientVector e) (DeterminantKernel.kernelVector e) j := by
  rw [basis_apply, forget_vector]

end MatrixMultiplication.AuxiliarySeparation.DeterminantBasis

end

end OAI
