module

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.ResidueBasis
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.MonicQuotient
public import Mathlib.FieldTheory.PrimitiveElement
public import Mathlib.FieldTheory.Finite.GaloisField
public import Mathlib.Algebra.Polynomial.Lifts

public section

@[expose] section

/-! Monic integral lifts of finite-field power bases. The integral algebra need
not be a domain or a field. Its reduction has a full basis, which is what the
norm-specialization argument requires. -/

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

noncomputable section
open scoped BigOperators

/-- Lift a finite-field power basis to a monic integer polynomial quotient.
All basis vectors specialize to the prescribed finite-field basis. -/
theorem exists_integral_powerBasis_lift (p : ℕ) [Fact p.Prime]
    (K : Type*) [Field K] [Algebra (ZMod p) K]
    (pb : PowerBasis (ZMod p) K) :
    ∃ f : Polynomial ℤ, ∃ hf : f.Monic,
      ∃ b : Module.Basis (Fin pb.dim) ℤ (AdjoinRoot f),
      ∃ φ : AdjoinRoot f →+* K,
        f.natDegree = pb.dim ∧
        (∀ r : ℤ, φ (algebraMap ℤ (AdjoinRoot f) r) =
          algebraMap (ZMod p) K (r : ZMod p)) ∧
        (∀ i, φ (b i) = pb.basis i) := by
  let ψ : ℤ →+* ZMod p := Int.castRingHom (ZMod p)
  obtain ⟨f, hmap, hdeg, hf⟩ := Polynomial.lifts_and_natDegree_eq_and_monic
    (Polynomial.mem_lifts_of_surjective
      (show Function.Surjective ψ from ZMod.intCast_surjective) (minpoly (ZMod p) pb.gen))
    (minpoly.monic pb.isIntegral_gen)
  have hd : f.natDegree = pb.dim := hdeg.trans pb.natDegree_minpoly
  have hc : (algebraMap (ZMod p) K).comp ψ = Int.castRingHom K := by
    ext r
    simp [ψ]
  have hroot : f.eval₂ (Int.castRingHom K) pb.gen = 0 := by
    rw [← hc, ← Polynomial.eval₂_map, hmap]
    exact minpoly.aeval (ZMod p) pb.gen
  let b := (AdjoinRoot.powerBasisAux' hf).reindex (finCongr hd)
  let φ := AdjoinRoot.lift (Int.castRingHom K) pb.gen hroot
  refine ⟨f, hf, b, φ, hd, ?_, ?_⟩
  · intro r
    simp only [map_intCast]
  · intro i
    dsimp [b]
    rw [Module.Basis.reindex_apply]
    change φ ((AdjoinRoot.powerBasis' hf).basis ((finCongr hd).symm i)) = pb.basis i
    rw [(AdjoinRoot.powerBasis' hf).basis_eq_pow, pb.basis_eq_pow, map_pow]
    simp only [AdjoinRoot.powerBasis'_gen, φ, AdjoinRoot.lift_root]
    rfl

/-- For each prime, convolution has a clearing integer not divisible by that
prime. Tensor powers are descended through one fixed finite free algebra. -/
theorem exists_prime_clearing_convolution (p : ℕ) [Fact p.Prime] (a b : ℕ) :
    ∃ D : ℤ, ∃ d : ℕ, (D : ZMod p) ≠ 0 ∧ 0 < d ∧ ∀ k : ℕ,
      Foundation.Tensor.RankAtMost
        (fun x y z => D ^ k * Foundation.Tensor.power
          (fun (i : Fin a) (j : Fin b) (l : Fin (a + b - 1)) =>
            (if i.val + j.val = l.val then 1 else 0 : ℤ)) k x y z)
        ((a + b - 1) ^ k * d * d) := by
  classical
  let h := a + b - 1
  let K := GaloisField p (h + 1)
  letI : Fintype K := Fintype.ofFinite K
  let pb : PowerBasis (ZMod p) K := Field.powerBasisOfFiniteOfSeparable (ZMod p) K
  have hcard : h ≤ Fintype.card K := by
    have hc : Fintype.card K = p ^ (h + 1) := by
      simpa only [Nat.card_eq_fintype_card] using
        (GaloisField.card p (h + 1) (show h + 1 ≠ 0 by omega))
    rw [hc]
    exact (Nat.le_succ h).trans (Nat.lt_pow_self (Fact.out : Nat.Prime p).one_lt).le
  obtain ⟨nodes⟩ : Nonempty (Fin h ↪ K) :=
    Function.Embedding.nonempty_of_card_le (by simpa only [Fintype.card_fin] using hcard)
  obtain ⟨f, hf, basis, φ, hdeg, hφ, hb⟩ := exists_integral_powerBasis_lift p K pb
  have hsurj := surjective_of_basis_specialize basis pb.basis
    (Int.castRingHom (ZMod p)) φ (show Function.Surjective (Int.castRingHom (ZMod p)) from
      ZMod.intCast_surjective) hφ hb
  choose v hv using fun i : Fin h => hsurj (nodes i)
  let delta : AdjoinRoot f := (Matrix.vandermonde v).det
  let D : ℤ := (Algebra.leftMulMatrix basis delta).det
  have hdelta : φ delta ≠ 0 := by
    have hmat : (Matrix.vandermonde v).map φ = Matrix.vandermonde (fun i => nodes i) := by
      ext i j
      simp only [Matrix.map_apply, Matrix.vandermonde, Matrix.of_apply, map_pow, hv]
    dsimp [delta]
    rw [RingHom.map_det, hmat]
    exact Matrix.det_vandermonde_ne_zero_iff.mpr nodes.injective
  have hD : (D : ZMod p) ≠ 0 := norm_specialize_ne_zero basis pb.basis
    (Int.castRingHom (ZMod p)) φ hφ hb delta hdelta
  let T : Foundation.Tensor ℤ (Fin a) (Fin b) (Fin h) :=
    fun i j l => if i.val + j.val = l.val then 1 else 0
  have hr : Foundation.Tensor.RankAtMost
      (fun i j l => algebraMap ℤ (AdjoinRoot f) (D * T i j l)) h := by
    simpa only [T, map_mul, apply_ite, map_one, map_zero] using
      rankAtMost_norm_convolution basis a b v
  have hfpos : 0 < f.natDegree := by rw [hdeg]; exact pb.dim_pos
  refine ⟨D, pb.dim, hD, pb.dim_pos, ?_⟩
  intro k
  have hk := hr.descend_finite_basis_powers basis (monicQuotientProjection hf)
    (monicQuotientProjection_one hf hfpos) k
  simpa only [Foundation.Tensor.power, Finset.prod_mul_distrib, Finset.prod_const,
    Finset.card_univ, Fintype.card_fin] using hk

end
end OAI.MatrixMultiplication.AuxiliarySeparation.Integral
