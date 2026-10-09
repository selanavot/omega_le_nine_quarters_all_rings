module

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.FiniteFreeDescent

public section

@[expose] section

/-! Restriction-level finite-free descent. Kept separate from rank descent so
its larger coefficient-map identities do not delay monic quotient setup. -/

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

noncomputable section
open Foundation
open scoped BigOperators

variable {R E ι X Y Z U V W : Type*}
variable [CommRing R] [CommRing E] [Algebra R E] [Fintype ι]

/-- Expand only the first two extension coefficients in a fixed basis. -/
theorem project_mul_mul (basis : Module.Basis ι R E) (π : E →ₗ[R] R)
    (v w t : E) :
    π (v * w * t) = ∑ i, ∑ j,
      basis.repr v i * basis.repr w j * π (basis i * basis j * t) := by
  classical
  calc
    π (v * w * t) =
        π ((∑ i, basis.repr v i • basis i) *
          (∑ j, basis.repr w j • basis j) * t) := by
      rw [basis.sum_repr, basis.sum_repr]
    _ = _ := by
      simp only [Finset.sum_mul, Finset.mul_sum, map_sum, smul_mul_assoc,
        mul_smul_comm, map_smul, smul_eq_mul]
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro i hi
      apply Finset.sum_congr rfl
      intro j hj
      ring

set_option maxHeartbeats 800000 in
/-- Restriction-level descent: the source itself is retained, repeated D² times.
This is stronger than just bounding the rank of the target. -/
theorem project_restrict_basis [Fintype U] [Fintype V] [Fintype W]
    [DecidableEq ι] (basis : Module.Basis ι R E) (π : E →ₗ[R] R)
    (T : Tensor R U V W)
    (A : X → U → E) (B : Y → V → E) (C : Z → W → E) :
    (fun x y z => π (Tensor.restrict A B C
      (fun u v w => algebraMap R E (T u v w)) x y z)) =
    Tensor.restrict
      (fun x (q : (ι × ι) × U) => basis.repr (A x q.2) q.1.1)
      (fun y (q : (ι × ι) × V) => basis.repr (B y q.2) q.1.2)
      (fun z (q : (ι × ι) × W) => π (basis q.1.1 * basis q.1.2 * C z q.2))
      (Tensor.directSum (fun _ : ι × ι => T)) := by
  have hm (v : E) (r : R) : π (v * algebraMap R E r) = π v * r := by
    rw [mul_comm, ← Algebra.smul_def, map_smul, smul_eq_mul, mul_comm]
  rw [restrict_directSum (fun _ : ι × ι => T)
    (fun q x u => basis.repr (A x u) q.1)
    (fun q y v => basis.repr (B y v) q.2)
    (fun q z w => π (basis q.1 * basis q.2 * C z w))]
  funext x y z
  simp only [Tensor.restrict, map_sum, hm]
  calc
    _ = ∑ u, ∑ v, ∑ w, (∑ q : ι × ι,
        basis.repr (A x u) q.1 * basis.repr (B y v) q.2 *
          π (basis q.1 * basis q.2 * C z w)) * T u v w := by
      apply Finset.sum_congr rfl
      intro u hu
      apply Finset.sum_congr rfl
      intro v hv
      apply Finset.sum_congr rfl
      intro w hw
      rw [project_mul_mul basis π (A x u) (B y v) (C z w), Fintype.sum_prod_type]
    _ = _ := by
      simp only [Finset.sum_mul]
      simpa only [Fintype.sum_prod_type] using sum_comm_three (fun (q : ι × ι) (u : U) (v : V) (w : W) =>
        basis.repr (A x u) q.1 * basis.repr (B y v) q.2 *
          π (basis q.1 * basis q.2 * C z w) * T u v w)

/-- When the functional splits the unit, a restriction defined over the finite
free algebra descends to D² source copies over the base ring. -/
theorem descend_restriction_basis [Fintype U] [Fintype V] [Fintype W]
    [DecidableEq ι] (basis : Module.Basis ι R E) (π : E →ₗ[R] R) (hπ : π 1 = 1)
    (S : Tensor R X Y Z) (T : Tensor R U V W)
    (A : X → U → E) (B : Y → V → E) (C : Z → W → E)
    (h : Tensor.restrict A B C (fun u v w => algebraMap R E (T u v w)) =
      fun x y z => algebraMap R E (S x y z)) :
    S = Tensor.restrict
      (fun x (q : (ι × ι) × U) => basis.repr (A x q.2) q.1.1)
      (fun y (q : (ι × ι) × V) => basis.repr (B y q.2) q.1.2)
      (fun z (q : (ι × ι) × W) => π (basis q.1.1 * basis q.1.2 * C z q.2))
      (Tensor.directSum (fun _ : ι × ι => T)) := by
  have heq := project_restrict_basis basis π T A B C
  rw [h] at heq
  simpa only [Algebra.algebraMap_eq_smul_one, map_smul, hπ, smul_eq_mul, mul_one] using heq

end
end OAI.MatrixMultiplication.AuxiliarySeparation.Integral
