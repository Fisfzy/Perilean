import PeriLean.BBPD.Basic

namespace PeriLean
namespace BBPD

noncomputable def neighborVolume {N d : ℕ} (system : ParticleSystem N d) (i : Fin N) : ℝ := by
  classical
  exact ∑ j, if isBond system i j then system.volume j else 0

noncomputable def activeVolume {N d : ℕ} (system : ParticleSystem N d)
    (alive : Fin N → Fin N → Bool) (i : Fin N) : ℝ := by
  classical
  exact ∑ j, if isBond system i j ∧ alive i j then system.volume j else 0

noncomputable def localDamage {N d : ℕ} (system : ParticleSystem N d)
    (alive : Fin N → Fin N → Bool) (i : Fin N) : ℝ :=
  if neighborVolume system i = 0 then 0 else
    1 - activeVolume system alive i / neighborVolume system i

theorem activeVolume_nonneg {N d : ℕ} (system : ParticleSystem N d)
    (alive : Fin N → Fin N → Bool) (i : Fin N) :
    0 ≤ activeVolume system alive i := by
  classical
  unfold activeVolume
  apply Finset.sum_nonneg
  intro j hj
  by_cases hb : isBond system i j <;> by_cases ha : alive i j = true <;>
    simp [hb, ha]
  exact (system.volume_pos j).le

theorem neighborVolume_nonneg {N d : ℕ} (system : ParticleSystem N d) (i : Fin N) :
    0 ≤ neighborVolume system i := by
  classical
  unfold neighborVolume
  apply Finset.sum_nonneg
  intro j hj
  by_cases hb : isBond system i j
  · simp [hb]
    exact (system.volume_pos j).le
  · simp [hb]

theorem activeVolume_le_neighborVolume {N d : ℕ} (system : ParticleSystem N d)
    (alive : Fin N → Fin N → Bool) (i : Fin N) :
    activeVolume system alive i ≤ neighborVolume system i := by
  classical
  unfold activeVolume neighborVolume
  apply Finset.sum_le_sum
  intro j hj
  by_cases hb : isBond system i j <;> by_cases ha : alive i j = true <;>
    simp [hb, ha]
  · exact (system.volume_pos j).le

theorem localDamage_eq_zero_if_no_neighbors {N d : ℕ}
    (system : ParticleSystem N d) (alive : Fin N → Fin N → Bool) (i : Fin N)
    (hzero : neighborVolume system i = 0) :
    localDamage system alive i = 0 := by
  classical
  simp [localDamage, hzero]

theorem localDamage_nonneg {N d : ℕ} (system : ParticleSystem N d)
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

theorem localDamage_le_one {N d : ℕ} (system : ParticleSystem N d)
    (alive : Fin N → Fin N → Bool) (i : Fin N) :
    localDamage system alive i ≤ 1 := by
  classical
  by_cases hzero : neighborVolume system i = 0
  · simp [localDamage, hzero]
  · unfold localDamage
    simp only [hzero, ↓reduceIte]
    have hnonneg : 0 ≤ activeVolume system alive i :=
      activeVolume_nonneg system alive i
    have hneighbor : 0 ≤ neighborVolume system i := neighborVolume_nonneg system i
    have hdiv : 0 ≤ activeVolume system alive i / neighborVolume system i := by
      exact div_nonneg hnonneg hneighbor
    linarith

end BBPD
end PeriLean
