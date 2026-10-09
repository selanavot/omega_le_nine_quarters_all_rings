module

public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.SeparationPolynomial
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.RestrictionDescent
public import OAI.LinearAlgebra.MatrixMultiplication.AuxiliarySeparation.Integral.CharacterTransport

public section

@[expose] section

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

noncomputable section
open Foundation
open scoped BigOperators

abbrev ExtractionIndex (Lx Ly n : ℕ) := Fin (Lx * n + 1) × Fin (Ly * n + 1)

def descentSource {X Y Z ι : Type} [DecidableEq ι]
    (T : Tensor ℤ X Y Z) (Lx Ly n : ℕ) :
    Tensor ℤ ((ι × ι) × (ExtractionIndex Lx Ly n × (Fin n → X)))
      ((ι × ι) × (ExtractionIndex Lx Ly n × (Fin n → Y)))
      ((ι × ι) × (ExtractionIndex Lx Ly n × (Fin n → Z))) :=
  Tensor.directSum (fun _ : ι × ι =>
    Tensor.directSum (fun _ : ExtractionIndex Lx Ly n => Tensor.power T n))

theorem scalar_power_restriction_descend
    {E ι X Y Z U V W : Type} [CommRing E]
    [Fintype ι] [DecidableEq ι]
    [Fintype X] [Fintype Y] [Fintype Z]
    (basis : Module.Basis ι ℤ E) (π : E →ₗ[ℤ] ℤ) (hπ : π 1 = 1)
    (T : Tensor ℤ X Y Z) (S : Tensor ℤ U V W) (d : ℤ)
    {k Lx Ly Lz : ℕ}
    (D : Tensor.PolynomialRestrictionDegeneration
      (fun x y z => algebraMap ℤ E (T x y z))
      (fun x y z => algebraMap ℤ E (d * S x y z)) k Lx Ly Lz) (n : ℕ) :
    ∃ (A : (Fin n → U) → ((ι × ι) × (ExtractionIndex Lx Ly n × (Fin n → X))) → ℤ)
      (B : (Fin n → V) → ((ι × ι) × (ExtractionIndex Lx Ly n × (Fin n → Y))) → ℤ)
      (C : (Fin n → W) → ((ι × ι) × (ExtractionIndex Lx Ly n × (Fin n → Z))) → ℤ),
      Tensor.restrict A B C (descentSource (ι := ι) T Lx Ly n) =
        fun x y z => d ^ n * Tensor.power S n x y z := by
  classical
  let Tn := Tensor.directSum (fun _ : ExtractionIndex Lx Ly n => Tensor.power T n)
  let Sn := fun x y z => d ^ n * Tensor.power S n x y z
  let A := fun x (q : ExtractionIndex Lx Ly n × (Fin n → X)) =>
    ((D.power n).leftMap x q.2).coeff q.1.1
  let B := fun y (q : ExtractionIndex Lx Ly n × (Fin n → Y)) =>
    ((D.power n).middleMap y q.2).coeff q.1.2
  let C := fun z (q : ExtractionIndex Lx Ly n × (Fin n → Z)) =>
    shiftedCoeff ((D.power n).rightMap z q.2) (k * n) (q.1.1.val + q.1.2.val)
  have hsource : (fun x y z => algebraMap ℤ E (Tn x y z)) =
      Tensor.directSum (fun _ : ExtractionIndex Lx Ly n =>
        Tensor.power (fun x y z => algebraMap ℤ E (T x y z)) n) := by
    funext x y z
    simp only [Tn, Tensor.directSum, Tensor.power]
    split_ifs <;> simp [map_prod]
  have htarget : Tensor.power (fun x y z => algebraMap ℤ E (d * S x y z)) n =
      fun x y z => algebraMap ℤ E (Sn x y z) := by
    funext x y z
    simp [Tensor.power, Sn, map_mul, map_pow, map_prod, Finset.prod_mul_distrib]
  have heq : Tensor.restrict A B C (fun x y z => algebraMap ℤ E (Tn x y z)) =
      fun x y z => algebraMap ℤ E (Sn x y z) := by
    rw [hsource, ← htarget]
    exact (D.power n).extract.symm
  have hd := descend_restriction_basis (R := ℤ) (E := E) (ι := ι)
    basis π hπ Sn Tn A B C heq
  exact ⟨_, _, _, hd.symm⟩

theorem value_descentSource {ι X Y Z : Type} [Fintype ι] [DecidableEq ι]
    [Fintype X] [Fintype Y] [Fintype Z]
    (χ : Character ℤ) (T : Tensor ℤ X Y Z) (Lx Ly n : ℕ) :
    χ.value (descentSource (ι := ι) T Lx Ly n) =
      (Fintype.card ι : ℝ) ^ 2 * ((n : ℝ) * Lx + 1) * (n * Ly + 1) * χ.value T ^ n := by
  simp only [descentSource, χ.map_directSum, χ.value_power, Finset.sum_const,
    Finset.card_univ, Fintype.card_prod, Fintype.card_fin, nsmul_eq_mul,
    Nat.cast_mul, Nat.cast_add, Nat.cast_one]
  ring

end
end OAI.MatrixMultiplication.AuxiliarySeparation.Integral
