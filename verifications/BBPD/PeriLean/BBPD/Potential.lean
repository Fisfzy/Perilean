import PeriLean.BBPD.PMB

namespace PeriLean
namespace BBPD

noncomputable def pmbBondPotential {N d : ℕ} (system : ParticleSystem N d)
    (micromodulus : ℝ) (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) (i j : Fin N) : ℝ :=
  if alive i j then
    (1 / 2 : ℝ) * micromodulus * ‖referenceBond system i j‖ *
      (stretch system displacement i j)^2
  else 0

theorem pmbBondPotential_zero_if_failed {N d : ℕ}
    (system : ParticleSystem N d) (micromodulus : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) {i j : Fin N}
    (hfailed : ¬ alive i j) :
    pmbBondPotential system micromodulus alive displacement i j = 0 := by
  simp [pmbBondPotential, hfailed]

theorem pmbBondPotential_nonneg {N d : ℕ}
    (system : ParticleSystem N d) (micromodulus : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) (hc : 0 ≤ micromodulus)
    (i j : Fin N) :
    0 ≤ pmbBondPotential system micromodulus alive displacement i j := by
  by_cases h : alive i j
  · simp only [pmbBondPotential, h, ↓reduceIte]
    positivity
  · simp [pmbBondPotential, h]

theorem pmbBondPotential_symmetric {N d : ℕ}
    (system : ParticleSystem N d) (micromodulus : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d)
    (halive : ∀ i j, alive i j = alive j i) (i j : Fin N) :
    pmbBondPotential system micromodulus alive displacement i j =
      pmbBondPotential system micromodulus alive displacement j i := by
  rw [pmbBondPotential, pmbBondPotential]
  rw [halive i j, stretch_swap, referenceBond_swap]
  simp

theorem pmbForce_norm {N d : ℕ}
    (system : ParticleSystem N d) (micromodulus criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) {i j : Fin N}
    (halive : alive i j = true)
    (hcurrent : ‖deformedBond system displacement i j‖ ≠ 0) :
    ‖pmbForce system micromodulus criticalStretch alive displacement i j‖ =
      ‖micromodulus * stretch system displacement i j‖ := by
  simp only [pmbForce, halive, ↓reduceIte, norm_smul]
  have hunit : ‖unitOrZero (deformedBond system displacement i j)‖ = 1 := by
    rw [unitOrZero]
    simp only [dif_neg hcurrent, norm_smul, norm_inv]
    rw [Real.norm_of_nonneg (norm_nonneg _)]
    exact inv_mul_cancel₀ hcurrent
  rw [hunit, mul_one]

end BBPD
end PeriLean
