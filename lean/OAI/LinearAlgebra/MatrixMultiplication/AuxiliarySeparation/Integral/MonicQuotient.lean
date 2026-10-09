module

public import Mathlib.RingTheory.AdjoinRoot
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.FiniteFreeDescent

public section

@[expose] section

/-! The explicit unit-splitting functional needed for finite-free descent exists
for every positive-degree monic polynomial quotient. No field or irreducibility
hypothesis is used. -/

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

noncomputable section
open Foundation

variable {R : Type*} [CommRing R] {f : Polynomial R}

/-- Constant coefficient of the unique remainder modulo a monic polynomial. -/
def monicQuotientProjection (hf : f.Monic) : AdjoinRoot f →ₗ[R] R :=
  (Polynomial.lcoeff R 0).comp (AdjoinRoot.modByMonicHom hf)

/-- The constant coefficient projection sends the quotient unit to one. -/
theorem monicQuotientProjection_one [Nontrivial R] (hf : f.Monic)
    (hdeg : 0 < f.natDegree) : monicQuotientProjection hf 1 = 1 := by
  have hmod : (1 : Polynomial R) %ₘ f = 1 :=
    (Polynomial.modByMonic_eq_self_iff hf).mpr (by
      simpa only [Polynomial.degree_one] using
        Polynomial.natDegree_pos_iff_degree_pos.mp hdeg)
  change (AdjoinRoot.modByMonicHom hf (1 : AdjoinRoot f)).coeff 0 = 1
  rw [← map_one (AdjoinRoot.mk f), AdjoinRoot.modByMonicHom_mk, hmod]
  exact Polynomial.coeff_one_zero

/-- Exact rank descent from a monic quotient, with its explicit polynomial basis. -/
theorem rankAtMost_descend_monicQuotient [Nontrivial R]
    {X Y Z : Type*} (hf : f.Monic) (hdeg : 0 < f.natDegree)
    {T : Tensor R X Y Z} {r : ℕ}
    (h : Tensor.RankAtMost (fun x y z => algebraMap R (AdjoinRoot f) (T x y z)) r) :
    Tensor.RankAtMost T (r * f.natDegree * f.natDegree) := by
  simpa only [Fintype.card_fin] using h.descend_finite_basis
    (AdjoinRoot.powerBasisAux' hf) (monicQuotientProjection hf)
    (monicQuotientProjection_one hf hdeg)

end
end OAI.MatrixMultiplication.AuxiliarySeparation.Integral
