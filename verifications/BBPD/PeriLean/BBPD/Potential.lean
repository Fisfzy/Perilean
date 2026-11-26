import PeriLean.BBPD.PMB

namespace PeriLean
namespace BBPD

noncomputable def pmbBondPotential {N d : ℕ} (system : ParticleSystem N d)
    (micromodulus : ℝ) (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) (i j : Fin N) : ℝ := by
  classical
  exact if isBond system i j then
    if alive i j then
      (1 / 2 : ℝ) * micromodulus * ‖referenceBond system i j‖ *
        (stretch system displacement i j)^2
    else 0
  else 0

theorem pmbBondPotential_zero_if_failed {N d : ℕ}
    (system : ParticleSystem N d) (micromodulus : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) {i j : Fin N}
    (hfailed : ¬ alive i j) :
    pmbBondPotential system micromodulus alive displacement i j = 0 := by
  classical
  simp [pmbBondPotential, hfailed]

theorem pmbBondPotential_nonneg {N d : ℕ}
    (system : ParticleSystem N d) (micromodulus : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) (hc : 0 ≤ micromodulus)
    (i j : Fin N) :
    0 ≤ pmbBondPotential system micromodulus alive displacement i j := by
  classical
  by_cases hb : isBond system i j
  · by_cases h : alive i j
    · simp only [pmbBondPotential, hb, h, ↓reduceIte]
      positivity
    · simp [pmbBondPotential, hb, h]
  · simp [pmbBondPotential, hb]

theorem pmbBondPotential_symmetric {N d : ℕ}
    (system : ParticleSystem N d) (micromodulus : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d)
    (halive : ∀ i j, alive i j = alive j i) (i j : Fin N) :
    pmbBondPotential system micromodulus alive displacement i j =
      pmbBondPotential system micromodulus alive displacement j i := by
  classical
  by_cases hb : isBond system i j
  · have hbj : isBond system j i := (isBond_swap_iff system i j).1 hb
    simp only [pmbBondPotential, hb, hbj, ↓reduceIte]
    rw [halive i j, stretch_swap, referenceBond_swap]
    simp
  · have hbj : ¬ isBond system j i := by
      intro hji
      exact hb ((isBond_swap_iff system i j).2 hji)
    simp [pmbBondPotential, hb, hbj]

theorem pmbForce_norm {N d : ℕ}
    (system : ParticleSystem N d) (micromodulus criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) {i j : Fin N}
    (hbond : isBond system i j)
    (halive : alive i j = true)
    (hcurrent : ‖deformedBond system displacement i j‖ ≠ 0) :
    ‖pmbForce system micromodulus criticalStretch alive displacement i j‖ =
      ‖micromodulus * stretch system displacement i j‖ := by
  classical
  simp only [pmbForce, hbond, halive, ↓reduceIte, norm_smul]
  have hunit : ‖unitOrZero (deformedBond system displacement i j)‖ = 1 := by
    rw [unitOrZero]
    simp only [dif_neg hcurrent, norm_smul, norm_inv]
    rw [Real.norm_of_nonneg (norm_nonneg _)]
    exact inv_mul_cancel₀ hcurrent
  rw [hunit, mul_one]

end BBPD
end PeriLean
