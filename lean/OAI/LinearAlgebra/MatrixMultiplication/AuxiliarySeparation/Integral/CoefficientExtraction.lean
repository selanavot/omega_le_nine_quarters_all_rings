module

public import OAI.LinearAlgebra.MatrixMultiplication.Polynomial.ComplexPolynomialDegenerationComposition
public import Mathlib.Algebra.Polynomial.Degree.Support
public import Mathlib.Algebra.Polynomial.Degree.Operations
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.Restriction

public section

@[expose] section

/-!
# Coefficient extraction without interpolation

Only the first two local-map degrees control the number of copies. The guard
in `shiftedCoeff` is essential: natural subtraction alone would incorrectly
reuse the constant coefficient when the shift exceeds the requested degree.
-/

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

noncomputable section
open Foundation
open scoped BigOperators Polynomial

variable {R : Type*} [CommSemiring R]

/-- The coefficient left after a monomial shift, including the negative-index case. -/
def shiftedCoeff (p : R[X]) (h shift : ℕ) : R :=
  if shift ≤ h then p.coeff (h - shift) else 0

/-- This formula requires no units or interpolation nodes. -/
theorem coeff_monomial_mul_full (p : R[X]) (r : R) (shift h : ℕ) :
    ((Polynomial.monomial shift r) * p).coeff h = r * shiftedCoeff p h shift := by
  rw [← Polynomial.C_mul_X_pow_eq_monomial, mul_assoc, Polynomial.coeff_C_mul,
    Polynomial.coeff_X_pow_mul']
  rfl

/-- Expanding just the first two factors gives a quadratic-size extraction. -/
theorem coeff_mul_mul_bounded (p q t : R[X]) (a b h : ℕ)
    (hp : p.natDegree ≤ a) (hq : q.natDegree ≤ b) :
    (p * q * t).coeff h =
      ∑ i : Fin (a + 1), ∑ j : Fin (b + 1),
        p.coeff i * q.coeff j * shiftedCoeff t h (i.val + j.val) := by
  have ep : p = ∑ i : Fin (a + 1), Polynomial.monomial i.val (p.coeff i) := by
    calc
      p = ∑ i ∈ Finset.range (a + 1), Polynomial.monomial i (p.coeff i) :=
        p.as_sum_range' (a + 1) (Nat.lt_succ_of_le hp)
      _ = _ := (Fin.sum_univ_eq_sum_range (fun i => Polynomial.monomial i (p.coeff i)) (a + 1)).symm
  have eq : q = ∑ j : Fin (b + 1), Polynomial.monomial j.val (q.coeff j) := by
    calc
      q = ∑ j ∈ Finset.range (b + 1), Polynomial.monomial j (q.coeff j) :=
        q.as_sum_range' (b + 1) (Nat.lt_succ_of_le hq)
      _ = _ := (Fin.sum_univ_eq_sum_range (fun j => Polynomial.monomial j (q.coeff j)) (b + 1)).symm
  conv_lhs => rw [ep, eq]
  simp only [Finset.sum_mul, Finset.mul_sum, Polynomial.finsetSum_coeff,
    Polynomial.monomial_mul_monomial, coeff_monomial_mul_full]
  exact Finset.sum_comm

/-- Coefficient extraction preserves the source tensor: the resulting tensor
is a restriction of `(a+1)(b+1)` copies of that source. -/
theorem restrict_coefficient {U V W X Y Z : Type*}
    [Fintype U] [Fintype V] [Fintype W]
    (T : Tensor R U V W)
    (A : X → U → R[X]) (B : Y → V → R[X]) (C : Z → W → R[X])
    (a b h : ℕ) (hA : ∀ x u, (A x u).natDegree ≤ a)
    (hB : ∀ y v, (B y v).natDegree ≤ b) :
    (fun x y z => (Tensor.restrict A B C
      (fun u v w => Polynomial.C (T u v w)) x y z).coeff h) =
    Tensor.restrict
      (fun x (q : (Fin (a + 1) × Fin (b + 1)) × U) => (A x q.2).coeff q.1.1)
      (fun y (q : (Fin (a + 1) × Fin (b + 1)) × V) => (B y q.2).coeff q.1.2)
      (fun z (q : (Fin (a + 1) × Fin (b + 1)) × W) =>
        shiftedCoeff (C z q.2) h (q.1.1.val + q.1.2.val))
      (Tensor.directSum (fun _ : Fin (a + 1) × Fin (b + 1) => T)) := by
  rw [restrict_directSum (fun _ : Fin (a + 1) × Fin (b + 1) => T)
    (fun q x u => (A x u).coeff q.1)
    (fun q y v => (B y v).coeff q.2)
    (fun q z w => shiftedCoeff (C z w) h (q.1.val + q.2.val))]
  funext x y z
  simp only [Tensor.restrict, Polynomial.finsetSum_coeff,
    Polynomial.coeff_mul_C]
  simp_rw [coeff_mul_mul_bounded _ _ _ a b h (hA x _) (hB y _)]
  simp only [Finset.sum_mul]
  simpa only [Fintype.sum_prod_type] using sum_comm_three (fun (q : Fin (a + 1) × Fin (b + 1)) (u : U) (v : V) (w : W) =>
    (A x u).coeff q.1 * (B y v).coeff q.2 *
      shiftedCoeff (C z w) h (q.1.val + q.2.val) * T u v w)

/-- The analogous rank bound for explicitly given polynomial rank-one terms. -/
theorem rankAtMost_coefficient {X Y Z : Type*} (r a b h : ℕ)
    (A : Fin r → X → R[X]) (B : Fin r → Y → R[X]) (C : Fin r → Z → R[X])
    (hA : ∀ q x, (A q x).natDegree ≤ a) (hB : ∀ q y, (B q y).natDegree ≤ b) :
    Tensor.RankAtMost (fun x y z =>
      (∑ q, Tensor.rankOne (A q) (B q) (C q) x y z).coeff h)
      (r * (a + 1) * (b + 1)) := by
  let aa : Fin r × (Fin (a + 1) × Fin (b + 1)) → X → R :=
    fun q x => (A q.1 x).coeff q.2.1
  let bb : Fin r × (Fin (a + 1) × Fin (b + 1)) → Y → R :=
    fun q y => (B q.1 y).coeff q.2.2
  let cc : Fin r × (Fin (a + 1) × Fin (b + 1)) → Z → R :=
    fun q z => shiftedCoeff (C q.1 z) h (q.2.1.val + q.2.2.val)
  have heq : (fun x y z =>
      (∑ q, Tensor.rankOne (A q) (B q) (C q) x y z).coeff h) =
      fun x y z => ∑ q, Tensor.rankOne (aa q) (bb q) (cc q) x y z := by
    funext x y z
    simp only [Polynomial.finsetSum_coeff, Fintype.sum_prod_type, Tensor.rankOne]
    apply Finset.sum_congr rfl
    intro q hq
    exact coeff_mul_mul_bounded _ _ _ a b h (hA q x) (hB q y)
  rw [heq]
  simpa only [Fintype.card_prod, Fintype.card_fin, Nat.mul_assoc] using
    Tensor.rankAtMost_sum_rankOne aa bb cc

end
end OAI.MatrixMultiplication.AuxiliarySeparation.Integral

namespace OAI.MatrixMultiplication.Foundation.Tensor.PolynomialRestrictionDegeneration

noncomputable section
open scoped BigOperators
open OAI.MatrixMultiplication.AuxiliarySeparation.Integral

variable {R X Y Z X' Y' Z' : Type*} [CommRing R]
variable [Fintype X] [Fintype Y] [Fintype Z]
variable {T : Tensor R X Y Z} {U : Tensor R X' Y' Z'}
variable {k Lx Ly Lz : ℕ}

/-- Powers of a polynomial restriction over a ring retain linear local-degree
bounds. This is the same degeneration structure as the original field proof. -/
def power (L : PolynomialRestrictionDegeneration T U k Lx Ly Lz) (n : ℕ) :
    PolynomialRestrictionDegeneration (Tensor.power T n) (Tensor.power U n)
      (k * n) (Lx * n) (Ly * n) (Lz * n) := by
  let N : Tensor (Polynomial R) X' Y' Z' := fun x y z =>
    Classical.choose (Polynomial.X_pow_dvd_iff.mpr (L.vanishes x y z))
  have hN (x : X') (y : Y') (z : Z') :
      L.basePolynomial x y z = Polynomial.X ^ k * N x y z :=
    Classical.choose_spec (Polynomial.X_pow_dvd_iff.mpr (L.vanishes x y z))
  have hN0 (x : X') (y : Y') (z : Z') : (N x y z).coeff 0 = U x y z := by
    have h := L.leading x y z
    change (L.basePolynomial x y z).coeff k = U x y z at h
    rw [hN] at h
    simpa only [Polynomial.coeff_X_pow_mul', le_refl, ite_true, Nat.sub_self] using h
  have hbase : Tensor.restrict
      (fun x u => ∏ i : Fin n, L.leftMap (x i) (u i))
      (fun y v => ∏ i : Fin n, L.middleMap (y i) (v i))
      (fun z w => ∏ i : Fin n, L.rightMap (z i) (w i))
      (fun u v w => Polynomial.C (Tensor.power T n u v w)) =
      Tensor.power L.basePolynomial n := by
    have hC : (fun u v w => Polynomial.C (Tensor.power T n u v w)) =
        Tensor.power (fun u v w => Polynomial.C (T u v w)) n := by
      funext u v w
      simp only [Tensor.power, map_prod]
    rw [hC, restrict_power]
    rfl
  have hprod (x : Fin n → X') (y : Fin n → Y') (z : Fin n → Z') :
      Tensor.power L.basePolynomial n x y z =
        Polynomial.X ^ (k * n) * Tensor.power N n x y z := by
    simp [Tensor.power, hN, Finset.prod_mul_distrib, ← pow_mul]
  refine {
    leftMap := fun x u => ∏ i : Fin n, L.leftMap (x i) (u i)
    middleMap := fun y v => ∏ i : Fin n, L.middleMap (y i) (v i)
    rightMap := fun z w => ∏ i : Fin n, L.rightMap (z i) (w i)
    left_degree := ?_
    middle_degree := ?_
    right_degree := ?_
    vanishes := ?_
    leading := ?_ }
  · intro x u
    apply Polynomial.degree_le_of_natDegree_le
    calc
      _ ≤ ∑ i : Fin n, (L.leftMap (x i) (u i)).natDegree :=
        Polynomial.natDegree_prod_le _ _
      _ ≤ ∑ _i : Fin n, Lx := Finset.sum_le_sum (fun i _ =>
        Polynomial.natDegree_le_of_degree_le (L.left_degree (x i) (u i)))
      _ = Lx * n := by simp [Nat.mul_comm]
  · intro y v
    apply Polynomial.degree_le_of_natDegree_le
    calc
      _ ≤ ∑ i : Fin n, (L.middleMap (y i) (v i)).natDegree :=
        Polynomial.natDegree_prod_le _ _
      _ ≤ ∑ _i : Fin n, Ly := Finset.sum_le_sum (fun i _ =>
        Polynomial.natDegree_le_of_degree_le (L.middle_degree (y i) (v i)))
      _ = Ly * n := by simp [Nat.mul_comm]
  · intro z w
    apply Polynomial.degree_le_of_natDegree_le
    calc
      _ ≤ ∑ i : Fin n, (L.rightMap (z i) (w i)).natDegree :=
        Polynomial.natDegree_prod_le _ _
      _ ≤ ∑ _i : Fin n, Lz := Finset.sum_le_sum (fun i _ =>
        Polynomial.natDegree_le_of_degree_le (L.right_degree (z i) (w i)))
      _ = Lz * n := by simp [Nat.mul_comm]
  · intro x y z j hj
    rw [hbase, hprod, Polynomial.coeff_X_pow_mul']
    simp only [Nat.not_le_of_lt hj, ite_false]
  · intro x y z
    rw [hbase, hprod, Polynomial.coeff_X_pow_mul']
    simp only [le_refl, ite_true, Nat.sub_self, Tensor.power,
      Polynomial.coeff_zero_prod, hN0]

/-- An exact restriction from `(Lx+1)(Ly+1)` source copies, obtained by taking
one coefficient rather than evaluating at field points. -/
theorem extract (L : PolynomialRestrictionDegeneration T U k Lx Ly Lz) :
    U = Tensor.restrict
      (fun x (q : (Fin (Lx + 1) × Fin (Ly + 1)) × X) => (L.leftMap x q.2).coeff q.1.1)
      (fun y (q : (Fin (Lx + 1) × Fin (Ly + 1)) × Y) => (L.middleMap y q.2).coeff q.1.2)
      (fun z (q : (Fin (Lx + 1) × Fin (Ly + 1)) × Z) =>
        shiftedCoeff (L.rightMap z q.2) k (q.1.1.val + q.1.2.val))
      (Tensor.directSum (fun _ : Fin (Lx + 1) × Fin (Ly + 1) => T)) := by
  have h := restrict_coefficient T L.leftMap L.middleMap L.rightMap Lx Ly k
    (fun x u => Polynomial.natDegree_le_of_degree_le (L.left_degree x u))
    (fun y v => Polynomial.natDegree_le_of_degree_le (L.middle_degree y v))
  simpa only [L.leading] using h

end
end OAI.MatrixMultiplication.Foundation.Tensor.PolynomialRestrictionDegeneration
