import PeriLean.SBPD.Composite

namespace PeriLean
namespace SBPD

noncomputable def neighborVolume {N : ℕ} (system : StateSystem N)
    (i : Fin N) : ℝ := by
  classical
  exact ∑ j, if inHorizon system i j then system.volume j else 0

noncomputable def activeVolume {N : ℕ} (system : StateSystem N)
    (alive : Fin N → Fin N → Bool) (i : Fin N) : ℝ := by
  classical
  exact ∑ j, if inHorizon system i j ∧ alive i j then system.volume j else 0

noncomputable def localDamage {N : ℕ} (system : StateSystem N)
    (alive : Fin N → Fin N → Bool) (i : Fin N) : ℝ := by
  classical
  exact if neighborVolume system i = 0 then 0 else
    1 - activeVolume system alive i / neighborVolume system i

def updateAlive {N : ℕ} (alive failed : Fin N → Fin N → Bool)
    (i j : Fin N) : Bool :=
  if alive i j then
    if failed i j then false else true
  else false

theorem activeVolume_nonneg {N : ℕ} (system : StateSystem N)
    (alive : Fin N → Fin N → Bool) (i : Fin N) :
    0 ≤ activeVolume system alive i := by
  classical
  unfold activeVolume
  apply Finset.sum_nonneg
  intro j hj
  by_cases hb : inHorizon system i j
  · by_cases ha : alive i j = true
    · simp [hb, ha]
      exact (system.volume_pos j).le
    · simp [hb, ha]
  · simp [hb]

theorem neighborVolume_nonneg {N : ℕ} (system : StateSystem N) (i : Fin N) :
    0 ≤ neighborVolume system i := by
  classical
  unfold neighborVolume
  apply Finset.sum_nonneg
  intro j hj
  by_cases hb : inHorizon system i j
  · simp only [hb, ↓reduceIte]
    exact (system.volume_pos j).le
  · simp [hb]

theorem activeVolume_le_neighborVolume {N : ℕ} (system : StateSystem N)
    (alive : Fin N → Fin N → Bool) (i : Fin N) :
    activeVolume system alive i ≤ neighborVolume system i := by
  classical
  unfold activeVolume neighborVolume
  apply Finset.sum_le_sum
  intro j hj
  by_cases hb : inHorizon system i j
  · by_cases ha : alive i j = true
    · simp [hb, ha]
    · simp [hb, ha]
      exact (system.volume_pos j).le
  · simp [hb]

theorem localDamage_nonneg {N : ℕ} (system : StateSystem N)
    (alive : Fin N → Fin N → Bool) (i : Fin N)
    (hpositive : 0 < neighborVolume system i) :
    0 ≤ localDamage system alive i := by
  classical
  unfold localDamage
  simp only [ne_of_gt hpositive, ↓reduceIte]
  have hle := activeVolume_le_neighborVolume system alive i
  have hdiv : activeVolume system alive i / neighborVolume system i ≤ 1 :=
    (div_le_one hpositive).2 hle
  linarith

theorem localDamage_le_one {N : ℕ} (system : StateSystem N)
    (alive : Fin N → Fin N → Bool) (i : Fin N) :
    localDamage system alive i ≤ 1 := by
  classical
  by_cases hzero : neighborVolume system i = 0
  · simp [localDamage, hzero]
  · unfold localDamage
    simp only [hzero, ↓reduceIte]
    have hnonneg : 0 ≤ activeVolume system alive i :=
      activeVolume_nonneg system alive i
    have hneighbor : 0 ≤ neighborVolume system i :=
      neighborVolume_nonneg system i
    have hdiv : 0 ≤ activeVolume system alive i / neighborVolume system i := by
      exact div_nonneg hnonneg (le_of_lt (lt_of_le_of_ne hneighbor (Ne.symm hzero)))
    linarith

theorem updateAlive_implies_old_alive {N : ℕ}
    (alive failed : Fin N → Fin N → Bool) {i j : Fin N}
    (hnew : updateAlive alive failed i j = true) : alive i j = true := by
  by_contra hold
  simp [updateAlive, hold] at hnew

theorem updateAlive_irreversible {N : ℕ}
    (alive failed : Fin N → Fin N → Bool) (i j : Fin N) :
    updateAlive alive failed i j = true → alive i j = true := by
  intro h
  exact updateAlive_implies_old_alive alive failed h

end SBPD
end PeriLean
