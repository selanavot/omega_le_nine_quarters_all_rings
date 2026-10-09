module

public import OAI.LinearAlgebra.MatrixMultiplication.Tensor.ComplexTensor

public section

@[expose] section

/-!
# Division-free assembly of coefficient restrictions

The direct-sum labels are retained on all three source legs.  These identities
are over commutative semirings and do not use spectral characters or fields.
-/

namespace OAI.MatrixMultiplication.AuxiliarySeparation.Integral

open Foundation
open scoped BigOperators

variable {R X Y Z U V W ι : Type*} [CommSemiring R]

/-- Move one finite summation past the three source coordinates. -/
theorem sum_comm_three [Fintype U] [Fintype V] [Fintype W] [Fintype ι]
    (f : ι → U → V → W → R) :
    (∑ u, ∑ v, ∑ w, ∑ i, f i u v w) = ∑ i, ∑ u, ∑ v, ∑ w, f i u v w := by
  calc
    _ = ∑ u, ∑ v, ∑ i, ∑ w, f i u v w := by
      apply Finset.sum_congr rfl
      intro u hu
      apply Finset.sum_congr rfl
      intro v hv
      exact Finset.sum_comm
    _ = ∑ u, ∑ i, ∑ v, ∑ w, f i u v w := by
      apply Finset.sum_congr rfl
      intro u hu
      exact Finset.sum_comm
    _ = _ := Finset.sum_comm

/-- Concatenating the three local maps adds the restricted tensors. -/
theorem restrict_directSum [Fintype U] [Fintype V] [Fintype W]
    [Fintype ι] [DecidableEq ι]
    (T : ι → Tensor R U V W)
    (A : ι → X → U → R) (B : ι → Y → V → R) (C : ι → Z → W → R) :
    Tensor.restrict (fun x q => A q.1 x q.2)
      (fun y q => B q.1 y q.2) (fun z q => C q.1 z q.2)
      (Tensor.directSum T) = fun x y z => ∑ i, Tensor.restrict (A i) (B i) (C i) (T i) x y z := by
  funext x y z
  simp [Tensor.restrict, Tensor.directSum, Fintype.sum_prod_type, ite_and]

/-- An arbitrary finite collection of explicit restrictions may be added with
scalar coefficients by scaling just the third local map. -/
theorem restrict_directSum_weighted [Fintype U] [Fintype V] [Fintype W]
    [Fintype ι] [DecidableEq ι]
    (T : ι → Tensor R U V W) (u : ι → R)
    (A : ι → X → U → R) (B : ι → Y → V → R) (C : ι → Z → W → R) :
    Tensor.restrict (fun x q => A q.1 x q.2)
      (fun y q => B q.1 y q.2) (fun z q => u q.1 * C q.1 z q.2)
      (Tensor.directSum T) =
      fun x y z => ∑ i, u i * Tensor.restrict (A i) (B i) (C i) (T i) x y z := by
  rw [restrict_directSum T A B (fun i z w => u i * C i z w)]
  funext x y z
  apply Finset.sum_congr rfl
  intro i hi
  simp only [Tensor.restrict, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro p hp
  apply Finset.sum_congr rfl
  intro q hq
  apply Finset.sum_congr rfl
  intro r hr
  ring

/-- Tensor powers of the local maps restrict tensor powers of the source. -/
theorem restrict_power [Fintype U] [Fintype V] [Fintype W]
    (T : Tensor R U V W) (A : X → U → R) (B : Y → V → R)
    (C : Z → W → R) (k : ℕ) :
    Tensor.restrict (fun x u => ∏ i : Fin k, A (x i) (u i))
      (fun y v => ∏ i : Fin k, B (y i) (v i))
      (fun z w => ∏ i : Fin k, C (z i) (w i)) (Tensor.power T k) =
      Tensor.power (Tensor.restrict A B C T) k := by
  funext x y z
  simp only [Tensor.restrict, Tensor.power, Fintype.prod_sum,
    Finset.prod_mul_distrib]

end OAI.MatrixMultiplication.AuxiliarySeparation.Integral
