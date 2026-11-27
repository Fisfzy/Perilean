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

def aliveSub {N : ℕ} (later earlier : Fin N → Fin N → Bool) : Prop :=
  ∀ i j, later i j = true → earlier i j = true

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

theorem activeVolume_mono {N d : ℕ} (system : ParticleSystem N d)
    {earlier later : Fin N → Fin N → Bool} (hsub : aliveSub later earlier)
    (i : Fin N) :
    activeVolume system later i ≤ activeVolume system earlier i := by
  classical
  unfold aliveSub at hsub
  unfold activeVolume
  apply Finset.sum_le_sum
  intro j hj
  by_cases hb : isBond system i j
  · by_cases hl : later i j = true
    · have he : earlier i j = true := hsub i j hl
      simp [hb, hl, he]
    · by_cases he : earlier i j = true
      · simp [hb, hl, he]
        exact (system.volume_pos j).le
      · simp [hb, hl, he]
  · simp [hb]

theorem localDamage_mono {N d : ℕ} (system : ParticleSystem N d)
    {earlier later : Fin N → Fin N → Bool} (hsub : aliveSub later earlier)
    (i : Fin N) (hpositive : 0 < neighborVolume system i) :
    localDamage system earlier i ≤ localDamage system later i := by
  classical
  unfold localDamage
  simp only [ne_of_gt hpositive, ↓reduceIte]
  have hvol : activeVolume system later i ≤ activeVolume system earlier i :=
    activeVolume_mono system hsub i
  have hdiv : activeVolume system later i / neighborVolume system i ≤
      activeVolume system earlier i / neighborVolume system i := by
    exact div_le_div_of_nonneg_right hvol (le_of_lt hpositive)
  linarith

end BBPD
end PeriLean
