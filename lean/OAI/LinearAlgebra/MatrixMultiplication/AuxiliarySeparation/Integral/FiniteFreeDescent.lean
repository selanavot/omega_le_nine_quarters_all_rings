module

public import Mathlib.LinearAlgebra.Basis.Basic
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.Restriction

public section

@[expose] section

/-! Fixed finite free algebra descent. No field hypothesis and no division.
The unit-splitting functional is supplied explicitly: it need not exist for an
arbitrary finite algebra over a ring. -/

namespace OAI.MatrixMultiplication.Foundation.Tensor

noncomputable section
open scoped BigOperators

variable {R E X Y Z : Type*} [CommRing R] [CommRing E] [Algebra R E]

/-- Applying a base-ring linear functional to coefficients increases exact
tensor rank by at most the square of the basis cardinality. -/
theorem RankAtMost.project_finite_basis {ι : Type*} [Fintype ι]
    (basis : Module.Basis ι R E) (π : E →ₗ[R] R)
    {T : Tensor E X Y Z} {r : ℕ} (h : RankAtMost T r) :
    RankAtMost (fun x y z => π (T x y z))
      (r * Fintype.card ι * Fintype.card ι) := by
  classical
  rcases h with ⟨a, b, c, rfl⟩
  let aa : Fin r × (ι × ι) → X → R :=
    fun q x => basis.repr (a q.1 x) q.2.1
  let bb : Fin r × (ι × ι) → Y → R :=
    fun q y => basis.repr (b q.1 y) q.2.2
  let cc : Fin r × (ι × ι) → Z → R :=
    fun q z => π (basis q.2.1 * basis q.2.2 * c q.1 z)
  have hexp (v w t : E) :
      π (v * w * t) = ∑ i, ∑ j,
        basis.repr v i * basis.repr w j * π (basis i * basis j * t) := by
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
  have heq : (fun x y z => π (∑ q, rankOne (a q) (b q) (c q) x y z)) =
      fun x y z => ∑ q, rankOne (aa q) (bb q) (cc q) x y z := by
    funext x y z
    simp only [map_sum, Fintype.sum_prod_type, rankOne]
    apply Finset.sum_congr rfl
    intro q hq
    exact hexp (a q x) (b q y) (c q z)
  rw [heq]
  simpa only [Fintype.card_prod, Fintype.card_fin, Nat.mul_assoc] using
    rankAtMost_sum_rankOne aa bb cc

/-- Exact rank descent with a supplied basis and a functional splitting the unit.
The basis is fixed independently of any tensor-power parameter. -/
theorem RankAtMost.descend_finite_basis {ι : Type*} [Fintype ι]
    (basis : Module.Basis ι R E) (π : E →ₗ[R] R) (hπ : π 1 = 1)
    {T : Tensor R X Y Z} {r : ℕ}
    (h : RankAtMost (fun x y z => algebraMap R E (T x y z)) r) :
    RankAtMost T (r * Fintype.card ι * Fintype.card ι) := by
  have ha (v : R) : π (algebraMap R E v) = v := by
    rw [Algebra.algebraMap_eq_smul_one, map_smul, hπ, smul_eq_mul, mul_one]
  simpa only [ha] using h.project_finite_basis basis π

/-- Power first in one fixed algebra, then descend. The overhead is D² once,
not D^(2k). -/
theorem RankAtMost.descend_finite_basis_powers {ι : Type*} [Fintype ι]
    (basis : Module.Basis ι R E) (π : E →ₗ[R] R) (hπ : π 1 = 1)
    {T : Tensor R X Y Z} {r : ℕ}
    (h : RankAtMost (fun x y z => algebraMap R E (T x y z)) r) (k : ℕ) :
    RankAtMost (Tensor.power T k) (r ^ k * Fintype.card ι * Fintype.card ι) := by
  have hp : RankAtMost
      (fun x y z => algebraMap R E (Tensor.power T k x y z)) (r ^ k) := by
    convert h.power k using 1
    funext x y z
    simp only [Tensor.power, map_prod]
  exact hp.descend_finite_basis basis π hπ

end
end OAI.MatrixMultiplication.Foundation.Tensor

