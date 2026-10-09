module

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.Vandermonde
public import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

public section

@[expose] section

/-! Specializing a finite free algebra together with its basis commutes with
multiplication matrices and their determinants. This isolates the exact input
needed to prove that an interpolation-clearing norm is prime to a chosen prime. -/

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

noncomputable section
open scoped BigOperators

variable {R S E K ι : Type*}
variable [CommRing R] [CommRing S] [CommRing E] [CommRing K]
variable [Algebra R E] [Algebra S K] [Fintype ι] [DecidableEq ι]

/-- Coordinates specialize coefficientwise when the basis vectors specialize. -/
theorem repr_specialize (b : Module.Basis ι R E) (c : Module.Basis ι S K)
    (ψ : R →+* S) (φ : E →+* K)
    (hφ : ∀ r, φ (algebraMap R E r) = algebraMap S K (ψ r))
    (hb : ∀ i, φ (b i) = c i) (x : E) (i : ι) :
    c.repr (φ x) i = ψ (b.repr x i) := by
  have he : φ x = c.equivFun.symm (fun j => ψ (b.repr x j)) := by
    rw [Module.Basis.equivFun_symm_apply]
    conv_lhs => rw [← b.sum_repr x, map_sum]
    apply Finset.sum_congr rfl
    intro j hj
    simp only [Algebra.smul_def, map_mul, hφ, hb]
  have hc := congrArg (fun y => c.equivFun y i) he
  simpa only [Module.Basis.equivFun_apply, LinearEquiv.apply_symm_apply] using hc

/-- Surjectivity of the coefficient map and specialization of a whole basis
imply surjectivity on the finite free algebra. -/
theorem surjective_of_basis_specialize (b : Module.Basis ι R E) (c : Module.Basis ι S K)
    (ψ : R →+* S) (φ : E →+* K) (hψ : Function.Surjective ψ)
    (hφ : ∀ r, φ (algebraMap R E r) = algebraMap S K (ψ r))
    (hb : ∀ i, φ (b i) = c i) : Function.Surjective φ := by
  intro y
  choose a ha using fun i => hψ (c.repr y i)
  refine ⟨∑ i, a i • b i, ?_⟩
  rw [map_sum]
  calc
    _ = ∑ i, c.repr y i • c i := by
      apply Finset.sum_congr rfl
      intro i hi
      simp only [Algebra.smul_def, map_mul, hφ, hb, ha]
    _ = y := c.sum_repr y

/-- The multiplication matrix specializes to the multiplication matrix of the
specialized element. -/
theorem leftMulMatrix_specialize (b : Module.Basis ι R E) (c : Module.Basis ι S K)
    (ψ : R →+* S) (φ : E →+* K)
    (hφ : ∀ r, φ (algebraMap R E r) = algebraMap S K (ψ r))
    (hb : ∀ i, φ (b i) = c i) (x : E) :
    (Algebra.leftMulMatrix b x).map ψ = Algebra.leftMulMatrix c (φ x) := by
  ext i j
  simp only [Matrix.map_apply, Algebra.leftMulMatrix_eq_repr_mul]
  rw [← repr_specialize b c ψ φ hφ hb, map_mul, hb]

/-- Consequently the base-ring determinant specializes to the residue norm. -/
theorem norm_specialize (b : Module.Basis ι R E) (c : Module.Basis ι S K)
    (ψ : R →+* S) (φ : E →+* K)
    (hφ : ∀ r, φ (algebraMap R E r) = algebraMap S K (ψ r))
    (hb : ∀ i, φ (b i) = c i) (x : E) :
    ψ (Algebra.leftMulMatrix b x).det = (Algebra.leftMulMatrix c (φ x)).det := by
  rw [RingHom.map_det]
  change ((Algebra.leftMulMatrix b x).map ψ).det = _
  rw [leftMulMatrix_specialize b c ψ φ hφ hb]

/-- A basis-preserving specialization to a field detects a nonzero norm.
For R=Z and S=ZMod p, this says the integer norm is not divisible by p. -/
theorem norm_specialize_ne_zero {R S E K ι : Type*}
    [CommRing R] [Field S] [CommRing E] [Field K]
    [Algebra R E] [Algebra S K] [Fintype ι] [DecidableEq ι]
    (b : Module.Basis ι R E) (c : Module.Basis ι S K)
    (ψ : R →+* S) (φ : E →+* K)
    (hφ : ∀ r, φ (algebraMap R E r) = algebraMap S K (ψ r))
    (hb : ∀ i, φ (b i) = c i) (x : E) (hx : φ x ≠ 0) :
    ψ (Algebra.leftMulMatrix b x).det ≠ 0 := by
  rw [norm_specialize b c ψ φ hφ hb]
  have hu : IsUnit (Algebra.leftMulMatrix c (φ x)) :=
    (isUnit_iff_ne_zero.mpr hx).map (Algebra.leftMulMatrix c).toMonoidHom
  exact ((Matrix.isUnit_iff_isUnit_det _).mp hu).ne_zero

end
end OAI.MatrixMultiplication.AuxiliarySeparation.Integral
