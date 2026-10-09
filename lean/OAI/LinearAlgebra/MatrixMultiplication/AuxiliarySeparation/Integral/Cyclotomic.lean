module

public import Mathlib.RingTheory.Polynomial.Cyclotomic.Roots
public import Mathlib.Algebra.CharP.Algebra
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.MonicQuotient

public section

@[expose] section

/-! Integral cyclotomic coefficients: a fixed finite free algebra containing
a primitive root as a unit, without inverting its order. -/

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

noncomputable section

abbrev CyclotomicAlgebra (L : ℕ) := AdjoinRoot (Polynomial.cyclotomic L ℤ)

instance cyclotomicAlgebra_isDomain (L : ℕ) [NeZero L] :
    IsDomain (CyclotomicAlgebra L) :=
  AdjoinRoot.isDomain_of_prime (Polynomial.cyclotomic.irreducible (NeZero.pos L)).prime

theorem cyclotomic_natDegree_pos (L : ℕ) [NeZero L] :
    0 < (Polynomial.cyclotomic L ℤ).natDegree := by
  rw [Polynomial.natDegree_cyclotomic]
  exact Nat.totient_pos.mpr (NeZero.pos L)

instance cyclotomicAlgebra_charZero (L : ℕ) [NeZero L] :
    CharZero (CyclotomicAlgebra L) := by
  apply charZero_of_injective_algebraMap (R := ℤ)
  exact AdjoinRoot.of.injective_of_monic_of_degree_pos
    (Polynomial.cyclotomic.monic L ℤ)
    (Polynomial.natDegree_pos_iff_degree_pos.mp (cyclotomic_natDegree_pos L))

theorem cyclotomic_root_primitive (L : ℕ) [NeZero L] :
    IsPrimitiveRoot (AdjoinRoot.root (Polynomial.cyclotomic L ℤ)) L := by
  apply (Polynomial.isRoot_cyclotomic_iff_charZero (NeZero.pos L)).mp
  rw [← Polynomial.map_cyclotomic_int L (CyclotomicAlgebra L)]
  exact AdjoinRoot.isRoot_root _

def cyclotomicUnit (L : ℕ) [NeZero L] : (CyclotomicAlgebra L)ˣ :=
  ((cyclotomic_root_primitive L).isUnit (NeZero.ne L)).unit

theorem cyclotomicUnit_primitive (L : ℕ) [NeZero L] :
    IsPrimitiveRoot (cyclotomicUnit L) L :=
  (cyclotomic_root_primitive L).isUnit_unit (NeZero.ne L)

def cyclotomicBasis (L : ℕ) :
    Module.Basis (Fin (Polynomial.cyclotomic L ℤ).natDegree) ℤ (CyclotomicAlgebra L) :=
  AdjoinRoot.powerBasisAux' (Polynomial.cyclotomic.monic L ℤ)

def cyclotomicProjection (L : ℕ) : CyclotomicAlgebra L →ₗ[ℤ] ℤ :=
  monicQuotientProjection (Polynomial.cyclotomic.monic L ℤ)

theorem cyclotomicProjection_one (L : ℕ) [NeZero L] :
    cyclotomicProjection L 1 = 1 :=
  monicQuotientProjection_one (Polynomial.cyclotomic.monic L ℤ)
    (cyclotomic_natDegree_pos L)

end
end OAI.MatrixMultiplication.AuxiliarySeparation.Integral
