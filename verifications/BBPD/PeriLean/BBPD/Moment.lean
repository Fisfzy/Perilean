import Mathlib.LinearAlgebra.CrossProduct
import PeriLean.BBPD.Pairwise
import PeriLean.BBPD.PMB

namespace PeriLean
namespace BBPD

open scoped Matrix

abbrev Vec3 := Fin 3 → ℝ

def pairMoment {ι : Type*} (position : ι → Vec3)
    (force : ι → ι → Vec3) (i j : ι) : Vec3 :=
  (position i - position j) ⨯₃ force i j

def pairTorque {ι : Type*} (position : ι → Vec3)
    (force : ι → ι → Vec3) (i j : ι) : Vec3 :=
  position i ⨯₃ force i j + position j ⨯₃ force j i

def totalPairTorque {N : ℕ} (position : Fin N → Vec3)
    (force : Fin N → Fin N → Vec3) : Vec3 :=
  ∑ i, ∑ j, pairTorque position force i j

def weightedTotalPairTorque {N : ℕ} (volume : Fin N → ℝ)
    (position : Fin N → Vec3) (force : Fin N → Fin N → Vec3) : Vec3 :=
  ∑ i, ∑ j, (volume i * volume j) • pairTorque position force i j

theorem pairTorque_eq_pairMoment_of_antisymmetric {ι : Type*}
    (position : ι → Vec3) (force : ι → ι → Vec3)
    (hanti : ∀ i j, force i j = -force j i) (i j : ι) :
    pairTorque position force i j = pairMoment position force i j := by
  unfold pairTorque pairMoment
  have hji : force j i = -force i j := by
    simpa using hanti j i
  rw [hji]
  simp [sub_eq_add_neg]

theorem pairMoment_zero_of_central {ι : Type*}
    (position : ι → Vec3) (force : ι → ι → Vec3)
    (hcentral : ∀ i j, ∃ a : ℝ, force i j = a • (position j - position i))
    (i j : ι) :
    pairMoment position force i j = 0 := by
  rcases hcentral i j with ⟨a, hforce⟩
  unfold pairMoment
  rw [hforce]
  have hbond : position j - position i = -(position i - position j) := by
    abel
  rw [hbond]
  simp [sub_eq_add_neg]
  rw [← smul_add, cross_anticomm']
  simp

theorem pairTorque_zero_of_central_and_antisymmetric {ι : Type*}
    (position : ι → Vec3) (force : ι → ι → Vec3)
    (hanti : ∀ i j, force i j = -force j i)
    (hcentral : ∀ i j, ∃ a : ℝ, force i j = a • (position j - position i))
    (i j : ι) :
    pairTorque position force i j = 0 := by
  rw [pairTorque_eq_pairMoment_of_antisymmetric position force hanti]
  exact pairMoment_zero_of_central position force hcentral i j

theorem totalPairTorque_zero {N : ℕ} (position : Fin N → Vec3)
    (force : Fin N → Fin N → Vec3)
    (hanti : ∀ i j, force i j = -force j i)
    (hcentral : ∀ i j, ∃ a : ℝ, force i j = a • (position j - position i)) :
    totalPairTorque position force = 0 := by
  classical
  unfold totalPairTorque
  simp_rw [pairTorque_zero_of_central_and_antisymmetric position force hanti hcentral]
  simp

theorem weightedTotalPairTorque_zero {N : ℕ} (volume : Fin N → ℝ)
    (position : Fin N → Vec3) (force : Fin N → Fin N → Vec3)
    (hanti : ∀ i j, force i j = -force j i)
    (hcentral : ∀ i j, ∃ a : ℝ, force i j = a • (position j - position i)) :
    weightedTotalPairTorque volume position force = 0 := by
  classical
  unfold weightedTotalPairTorque
  simp_rw [pairTorque_zero_of_central_and_antisymmetric position force hanti hcentral]
  simp

theorem pmbPairTorque_zero {N : ℕ}
    (system : ParticleSystem N 3) (micromodulus criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec 3)
    (halive : ∀ i j, alive i j = alive j i) (i j : Fin N) :
    pairTorque (fun k => WithLp.ofLp (currentPosition system displacement k))
      (fun k l => WithLp.ofLp (pmbForce system micromodulus criticalStretch alive displacement k l)) i j = 0 := by
  apply pairTorque_zero_of_central_and_antisymmetric
  · intro a b
    rw [pmbForce_antisymmetric system micromodulus criticalStretch alive displacement halive]
    rfl
  · intro a b
    rcases pmbForce_central system micromodulus criticalStretch alive displacement a b with ⟨c, hc⟩
    refine ⟨c, ?_⟩
    rw [hc]
    rfl

theorem pmbWeightedTotalPairTorque_zero {N : ℕ}
    (system : ParticleSystem N 3) (micromodulus criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec 3)
    (halive : ∀ i j, alive i j = alive j i) :
    weightedTotalPairTorque system.volume
      (fun k => WithLp.ofLp (currentPosition system displacement k))
      (fun k l => WithLp.ofLp (pmbForce system micromodulus criticalStretch alive displacement k l)) = 0 := by
  apply weightedTotalPairTorque_zero
  · intro a b
    rw [pmbForce_antisymmetric system micromodulus criticalStretch alive displacement halive]
    rfl
  · intro a b
    rcases pmbForce_central system micromodulus criticalStretch alive displacement a b with ⟨c, hc⟩
    refine ⟨c, ?_⟩
    rw [hc]
    rfl

end BBPD
end PeriLean
