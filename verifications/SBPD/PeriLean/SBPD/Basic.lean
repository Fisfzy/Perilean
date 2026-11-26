import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Tactic

namespace PeriLean
namespace SBPD

abbrev Vec2 := Fin 2 → ℝ
abbrev Mat2 := Matrix (Fin 2) (Fin 2) ℝ

noncomputable def vecNorm (v : Vec2) : ℝ :=
  Real.sqrt (∑ i, v i ^ 2)

def outer (u v : Vec2) : Mat2 :=
  fun i j => u i * v j

structure StateSystem (N : ℕ) where
  referencePosition : Fin N → Vec2
  volume : Fin N → ℝ
  density : Fin N → ℝ
  horizon : ℝ
  horizon_pos : 0 < horizon
  volume_pos : ∀ i, 0 < volume i
  density_pos : ∀ i, 0 < density i
  separated : ∀ ⦃i j⦄, i ≠ j → 0 < vecNorm (referencePosition j - referencePosition i)

def referenceBond {N : ℕ} (system : StateSystem N) (i j : Fin N) : Vec2 :=
  system.referencePosition j - system.referencePosition i

def currentPosition {N : ℕ} (system : StateSystem N)
    (displacement : Fin N → Vec2) (i : Fin N) : Vec2 :=
  system.referencePosition i + displacement i

def relativeDisplacement {N : ℕ} (displacement : Fin N → Vec2)
    (i j : Fin N) : Vec2 :=
  displacement j - displacement i

def deformedBond {N : ℕ} (system : StateSystem N)
    (displacement : Fin N → Vec2) (i j : Fin N) : Vec2 :=
  referenceBond system i j + relativeDisplacement displacement i j

def inHorizon {N : ℕ} (system : StateSystem N) (i j : Fin N) : Prop :=
  i ≠ j ∧ vecNorm (referenceBond system i j) ≤ system.horizon

theorem referenceBond_swap {N : ℕ} (system : StateSystem N) (i j : Fin N) :
    referenceBond system j i = -referenceBond system i j := by
  unfold referenceBond
  ext k
  simp [sub_eq_add_neg, add_comm, add_left_comm, add_assoc]

theorem relativeDisplacement_swap {N : ℕ} (displacement : Fin N → Vec2)
    (i j : Fin N) :
    relativeDisplacement displacement j i = -relativeDisplacement displacement i j := by
  unfold relativeDisplacement
  ext k
  simp [sub_eq_add_neg, add_comm, add_left_comm, add_assoc]

theorem deformedBond_swap {N : ℕ} (system : StateSystem N)
    (displacement : Fin N → Vec2) (i j : Fin N) :
    deformedBond system displacement j i = -deformedBond system displacement i j := by
  unfold deformedBond
  rw [referenceBond_swap, relativeDisplacement_swap]
  ext k
  simp [sub_eq_add_neg, add_comm, add_left_comm, add_assoc]

theorem deformedBond_eq_current_sub_current {N : ℕ}
    (system : StateSystem N) (displacement : Fin N → Vec2) (i j : Fin N) :
    deformedBond system displacement i j =
      currentPosition system displacement j - currentPosition system displacement i := by
  unfold deformedBond currentPosition referenceBond relativeDisplacement
  ext k
  simp [sub_eq_add_neg, add_comm, add_left_comm, add_assoc]

theorem vecNorm_neg (v : Vec2) : vecNorm (-v) = vecNorm v := by
  unfold vecNorm
  congr 1
  apply Finset.sum_congr rfl
  intro i hi
  simp

theorem inHorizon_swap {N : ℕ} (system : StateSystem N) (i j : Fin N) :
    inHorizon system i j ↔ inHorizon system j i := by
  unfold inHorizon
  rw [referenceBond_swap, vecNorm_neg]
  constructor
  · rintro ⟨hij, hlen⟩
    exact ⟨Ne.symm hij, hlen⟩
  · rintro ⟨hij, hlen⟩
    exact ⟨Ne.symm hij, hlen⟩

theorem referenceBond_vecNorm_pos {N : ℕ} (system : StateSystem N)
    {i j : Fin N} (hij : i ≠ j) :
    0 < vecNorm (referenceBond system i j) := by
  simpa [referenceBond] using system.separated hij

def ShapeWeight (N : ℕ) := Fin N → Fin N → ℝ

def shapeTensor {N : ℕ} (system : StateSystem N) (weight : ShapeWeight N)
    (i : Fin N) : Mat2 :=
  ∑ j, (weight i j * system.volume j) •
    outer (referenceBond system i j) (referenceBond system i j)

def deformationNumerator {N : ℕ} (system : StateSystem N)
    (weight : ShapeWeight N) (displacement : Fin N → Vec2) (i : Fin N) : Mat2 :=
  ∑ j, (weight i j * system.volume j) •
    outer (deformedBond system displacement i j) (referenceBond system i j)

structure ShapeTensorCertificate {N : ℕ} (system : StateSystem N)
    (weight : ShapeWeight N) (i : Fin N) where
  invMatrix : Mat2
  left_inverse : invMatrix * shapeTensor system weight i = 1
  right_inverse : shapeTensor system weight i * invMatrix = 1

def deformationGradient {N : ℕ} (system : StateSystem N)
    (weight : ShapeWeight N) (displacement : Fin N → Vec2) (i : Fin N)
    (certificate : ShapeTensorCertificate system weight i) : Mat2 :=
  deformationNumerator system weight displacement i * certificate.invMatrix

theorem deformationGradient_mul_shapeTensor {N : ℕ} (system : StateSystem N)
    (weight : ShapeWeight N) (displacement : Fin N → Vec2) (i : Fin N)
    (certificate : ShapeTensorCertificate system weight i) :
    deformationGradient system weight displacement i certificate * shapeTensor system weight i =
      deformationNumerator system weight displacement i := by
  unfold deformationGradient
  rw [Matrix.mul_assoc, certificate.left_inverse, Matrix.mul_one]

def forceState {N : ℕ} (weight : ShapeWeight N)
    (stress shape : Fin N → Mat2) (positionState : Fin N → Fin N → Vec2)
    (i j : Fin N) : Vec2 :=
  weight i j • (Matrix.mulVec (stress i * shape i) (positionState i j))

def statePairForce {N : ℕ} (state : Fin N → Fin N → Vec2)
    (i j : Fin N) : Vec2 :=
  state i j - state j i

def stateInternalForce {N : ℕ} (system : StateSystem N)
    (state : Fin N → Fin N → Vec2) (i : Fin N) : Vec2 :=
  ∑ j, system.volume j • statePairForce state i j

def totalStateInternalForce {N : ℕ} (system : StateSystem N)
    (state : Fin N → Fin N → Vec2) : Vec2 :=
  ∑ i, system.volume i • stateInternalForce system state i

theorem statePairForce_antisymmetric {N : ℕ} (state : Fin N → Fin N → Vec2)
    (i j : Fin N) :
    statePairForce state j i = -statePairForce state i j := by
  unfold statePairForce
  ext k
  simp [sub_eq_add_neg, add_comm, add_left_comm, add_assoc]

theorem totalStateInternalForce_zero {N : ℕ} (system : StateSystem N)
    (state : Fin N → Fin N → Vec2) :
    totalStateInternalForce system state = 0 := by
  classical
  unfold totalStateInternalForce stateInternalForce
  simp_rw [Finset.smul_sum, smul_smul]
  let pair : Fin N → Fin N → Vec2 := fun i j =>
    (system.volume i * system.volume j) • statePairForce state i j
  change (∑ i, ∑ j, pair i j) = 0
  have hpair : ∀ i j, pair j i = -pair i j := by
    intro i j
    dsimp [pair]
    rw [statePairForce_antisymmetric]
    simp [mul_comm, smul_neg]
  have hsum : (∑ i, ∑ j, pair i j) = -∑ i, ∑ j, pair i j := by
    calc
      (∑ i, ∑ j, pair i j) = ∑ j, ∑ i, pair i j := by
        rw [Finset.sum_comm]
      _ = ∑ j, ∑ i, -pair j i := by
        apply Finset.sum_congr rfl
        intro j hj
        apply Finset.sum_congr rfl
        intro i hi
        rw [hpair]
      _ = -∑ j, ∑ i, pair j i := by
        simp only [Finset.sum_neg_distrib]
      _ = -∑ i, ∑ j, pair i j := by
        rw [Finset.sum_comm]
  have hadd : (∑ i, ∑ j, pair i j) + (∑ i, ∑ j, pair i j) = 0 :=
    (eq_neg_iff_add_eq_zero.mp hsum)
  calc
    (∑ i, ∑ j, pair i j) = (1 / 2 : ℝ) • ((2 : ℝ) • (∑ i, ∑ j, pair i j)) := by
      rw [smul_smul]
      norm_num
    _ = (1 / 2 : ℝ) • ((∑ i, ∑ j, pair i j) + (∑ i, ∑ j, pair i j)) := by
      rw [two_smul]
    _ = 0 := by rw [hadd]; simp

end SBPD
end PeriLean
