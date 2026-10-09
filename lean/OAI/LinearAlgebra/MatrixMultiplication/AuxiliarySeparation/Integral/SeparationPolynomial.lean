module

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.SeparationWeights

public section

@[expose] section

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

noncomputable section
open Foundation
open scoped BigOperators

variable {E : Type*} [CommRing E] [IsDomain E]
variable {M L : ℕ} {X Y Z : Type*}

def leftPolynomialMap (ζ : Eˣ) : (X × Fin M) → (Fin L × X) → Polynomial E := by
  classical
  exact fun x r => if r.2 = x.1 then
    Polynomial.monomial (leftDegree (sectorNumber x.2))
      (↑(ζ ^ ((r.1.val : ℤ) * (2 * sectorNumber x.2))) : E) else 0

def middlePolynomialMap (ζ : Eˣ) :
    ((Fin M × Y) × Fin M) → (Fin L × (Fin M × Y)) → Polynomial E := by
  classical
  exact fun y r => if r.2 = y.1 then
    Polynomial.monomial (middleDegree M (sectorNumber y.1.1) (sectorNumber y.2))
      (↑(ζ ^ ((r.1.val : ℤ) * (sectorNumber y.2 - sectorNumber y.1.1))) : E) else 0

def rightPolynomialMap (ζ : Eˣ) :
    ((Fin M × Z) × Fin M) → (Fin L × (Fin M × Z)) → Polynomial E := by
  classical
  exact fun z r => if r.2 = z.1 then
    Polynomial.monomial (rightDegree M (sectorNumber z.1.1) (sectorNumber z.2))
      (↑(ζ ^ ((r.1.val : ℤ) * (-sectorNumber z.2 - sectorNumber z.1.1))) : E) else 0

def integralSeparationPolynomial (ζ : Eˣ) (L : ℕ) (B : Fin M → Tensor E X Y Z) :
    Tensor (Polynomial E) (X × Fin M) ((Fin M × Y) × Fin M) ((Fin M × Z) × Fin M) :=
  fun x y z => if y.1.1 = z.1.1 then
    weightedBranch ζ M L (sectorNumber x.2) (sectorNumber y.1.1)
      (sectorNumber y.2) (sectorNumber z.2) (B y.1.1 x.1 y.1.2 z.1.2) else 0

theorem integralSeparationPolynomial_restrict [Fintype X] [Fintype Y] [Fintype Z]
    (ζ : Eˣ) (L : ℕ) (B : Fin M → Tensor E X Y Z) :
    Tensor.restrict (leftPolynomialMap ζ) (middlePolynomialMap ζ) (rightPolynomialMap ζ)
      (fun x y z => Polynomial.C (Tensor.directSum (fun _ : Fin L => sharedFirstTensor B) x y z)) =
        integralSeparationPolynomial ζ L B := by
  classical
  have hC : (fun x y z => Polynomial.C
      (Tensor.directSum (fun _ : Fin L => sharedFirstTensor B) x y z)) =
      Tensor.directSum (fun _ : Fin L => fun x y z => Polynomial.C (sharedFirstTensor B x y z)) := by
    funext x y z
    simp only [Tensor.directSum]
    split_ifs <;> simp
  rw [hC]
  funext x y z
  unfold leftPolynomialMap middlePolynomialMap rightPolynomialMap
  rw [restrict_constantCopies_delta (R := Fin L)
    (fun x y z => Polynomial.C (sharedFirstTensor B x y z)) Prod.fst Prod.fst Prod.fst
    (fun x r => Polynomial.monomial (leftDegree (sectorNumber x.2))
      (↑(ζ ^ ((r.val : ℤ) * (2 * sectorNumber x.2))) : E))
    (fun y r => Polynomial.monomial (middleDegree M (sectorNumber y.1.1) (sectorNumber y.2))
      (↑(ζ ^ ((r.val : ℤ) * (sectorNumber y.2 - sectorNumber y.1.1))) : E))
    (fun z r => Polynomial.monomial (rightDegree M (sectorNumber z.1.1) (sectorNumber z.2))
      (↑(ζ ^ ((r.val : ℤ) * (-sectorNumber z.2 - sectorNumber z.1.1))) : E)) x y z]
  by_cases hyz : y.1.1 = z.1.1
  · simp only [sharedFirstTensor, integralSeparationPolynomial, hyz, ↓reduceIte]
    rw [← hyz]
    have hterm (r : Fin L) :
        Polynomial.monomial (leftDegree (sectorNumber x.2))
          (↑(ζ ^ ((r.val : ℤ) * (2 * sectorNumber x.2))) : E) *
        Polynomial.monomial (middleDegree M (sectorNumber y.1.1) (sectorNumber y.2))
          (↑(ζ ^ ((r.val : ℤ) * (sectorNumber y.2 - sectorNumber y.1.1))) : E) *
        Polynomial.monomial (rightDegree M (sectorNumber y.1.1) (sectorNumber z.2))
          (↑(ζ ^ ((r.val : ℤ) * (-sectorNumber z.2 - sectorNumber y.1.1))) : E) =
        Polynomial.monomial
          (leftDegree (sectorNumber x.2) + middleDegree M (sectorNumber y.1.1) (sectorNumber y.2) +
            rightDegree M (sectorNumber y.1.1) (sectorNumber z.2))
          (↑(ζ ^ ((r.val : ℤ) * phase (sectorNumber x.2) (sectorNumber y.1.1)
            (sectorNumber y.2) (sectorNumber z.2))) : E) := by
      rw [Polynomial.monomial_mul_monomial, Polynomial.monomial_mul_monomial]
      congr 1
      rw [← Units.val_mul, ← Units.val_mul, ← zpow_add, ← zpow_add]
      congr 2
      unfold phase
      ring
    simp_rw [hterm]
    rw [← map_sum, Polynomial.monomial_mul_C]
    unfold weightedBranch
    rw [Fin.sum_univ_eq_sum_range (fun r : ℕ =>
      (↑(ζ ^ ((r : ℤ) * phase (sectorNumber x.2) (sectorNumber y.1.1)
        (sectorNumber y.2) (sectorNumber z.2))) : E))]
  · simp [sharedFirstTensor, integralSeparationPolynomial, hyz]

def mapDegreeBound {A B : Type*} [Fintype A] [Fintype B]
    (P : A → B → Polynomial E) : ℕ :=
  Finset.univ.sup (fun q : A × B => (P q.1 q.2).natDegree)

theorem degree_le_mapDegreeBound {A B : Type*} [Fintype A] [Fintype B]
    (P : A → B → Polynomial E) (a : A) (b : B) :
    (P a b).degree ≤ mapDegreeBound P := by
  apply Polynomial.degree_le_of_natDegree_le
  exact Finset.le_sup (f := fun q : A × B => (P q.1 q.2).natDegree) (Finset.mem_univ (a, b))

/-- An explicit polynomial degeneration to L times the separated tensor.
No inverse of L occurs in any local map. -/
def integralSeparationDegeneration [Fintype X] [Fintype Y] [Fintype Z]
    {ζ : Eˣ} (hM : 0 < M) (hL : 5 * M ≤ L) (hζ : IsPrimitiveRoot ζ L)
    (B : Fin M → Tensor E X Y Z) :
    Tensor.PolynomialRestrictionDegeneration
      (Tensor.directSum (fun _ : Fin L => sharedFirstTensor B))
      (fun x y z => (L : E) * separationTarget B x y z) (2 * M ^ 2)
      (mapDegreeBound (leftPolynomialMap ζ : (X × Fin M) → (Fin L × X) → Polynomial E))
      (mapDegreeBound (middlePolynomialMap ζ :
        ((Fin M × Y) × Fin M) → (Fin L × (Fin M × Y)) → Polynomial E))
      (mapDegreeBound (rightPolynomialMap ζ :
        ((Fin M × Z) × Fin M) → (Fin L × (Fin M × Z)) → Polynomial E)) where
  leftMap := leftPolynomialMap ζ
  middleMap := middlePolynomialMap ζ
  rightMap := rightPolynomialMap ζ
  left_degree := degree_le_mapDegreeBound _
  middle_degree := degree_le_mapDegreeBound _
  right_degree := degree_le_mapDegreeBound _
  vanishes := by
    intro x y z j hj
    rw [integralSeparationPolynomial_restrict]
    unfold integralSeparationPolynomial
    split_ifs
    · exact weightedBranch_vanishes hM hL hζ (sectorNumber_bounds _) (sectorNumber_bounds _)
        (sectorNumber_bounds _) (sectorNumber_bounds _) hj _
    · simp
  leading := by
    intro x y z
    rw [integralSeparationPolynomial_restrict]
    by_cases hyz : y.1.1 = z.1.1
    · simp only [integralSeparationPolynomial, hyz, ↓reduceIte]
      rw [weightedBranch_leading hM hL hζ (sectorNumber_bounds _) (sectorNumber_bounds _)
        (sectorNumber_bounds _) (sectorNumber_bounds _)]
      simp only [sectorNumber_injective.eq_iff, separationTarget, hyz, true_and, mul_ite, mul_zero]
    · simp [integralSeparationPolynomial, separationTarget, hyz]

end
end OAI.MatrixMultiplication.AuxiliarySeparation.Integral
