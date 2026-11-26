import PeriLean.BBPD.Pairwise

namespace PeriLean
namespace BBPD

noncomputable def pmbForce {N d : ℕ} (system : ParticleSystem N d)
    (micromodulus criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) (i j : Fin N) : Vec d :=
  if alive i j then
    (micromodulus * stretch system displacement i j) •
      unitOrZero (deformedBond system displacement i j)
  else 0

theorem pmbForce_zero_if_failed {N d : ℕ}
    (system : ParticleSystem N d) (micromodulus criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) {i j : Fin N}
    (hfailed : ¬ alive i j) :
    pmbForce system micromodulus criticalStretch alive displacement i j = 0 := by
  simp [pmbForce, hfailed]

theorem pmbForce_antisymmetric {N d : ℕ}
    (system : ParticleSystem N d) (micromodulus criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d)
    (halive : ∀ i j, alive i j = alive j i) (i j : Fin N) :
    pmbForce system micromodulus criticalStretch alive displacement i j =
      -pmbForce system micromodulus criticalStretch alive displacement j i := by
  by_cases h : alive i j = true
  · have hji : alive j i = true := by
      rw [← halive i j]
      exact h
    simp only [pmbForce, h, hji]
    rw [stretch_swap, deformedBond_swap, unitOrZero_neg]
    simp [smul_neg]
  · have hji : alive j i ≠ true := by
      intro hji
      apply h
      rw [halive i j]
      exact hji
    simp only [pmbForce, h, hji]
    simp

noncomputable def pmbPairForceLaw {N d : ℕ} (system : ParticleSystem N d)
    (micromodulus criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d)
    (halive : ∀ i j, alive i j = alive j i) :
    PairForceLaw (Fin N) d :=
  { force := pmbForce system micromodulus criticalStretch alive displacement
    antisymmetric := pmbForce_antisymmetric system micromodulus criticalStretch
      alive displacement halive }

theorem pmbForce_central {N d : ℕ}
    (system : ParticleSystem N d) (micromodulus criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) :
    IsCentral (currentPosition system displacement)
      (pmbForce system micromodulus criticalStretch alive displacement) := by
  intro i j
  by_cases h : alive i j
  · by_cases hcurr :
        currentPosition system displacement j - currentPosition system displacement i = 0
    · refine ⟨0, ?_⟩
      simp [pmbForce, h, unitOrZero, deformedBond_eq_current_sub_current, hcurr]
    · refine ⟨micromodulus * stretch system displacement i j /
          ‖currentPosition system displacement j - currentPosition system displacement i‖, ?_⟩
      simp only [pmbForce, h, ↓reduceIte]
      rw [deformedBond_eq_current_sub_current]
      have hnorm :
          ‖currentPosition system displacement j - currentPosition system displacement i‖ ≠ 0 := by
        intro hz
        apply hcurr
        exact norm_eq_zero.mp hz
      simp [unitOrZero, hnorm, smul_smul]
      field_simp
  · refine ⟨0, ?_⟩
    simp [pmbForce, h]

noncomputable def pmbUpdateAlive {N d : ℕ} (system : ParticleSystem N d)
    (criticalStretch : ℝ) (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) (i j : Fin N) : Bool :=
  if alive i j then decide (stretch system displacement i j ≤ criticalStretch) else false

theorem pmbUpdateAlive_implies_old_alive {N d : ℕ}
    (system : ParticleSystem N d) (criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) {i j : Fin N}
    (hnew : pmbUpdateAlive system criticalStretch alive displacement i j = true) :
    alive i j = true := by
  by_contra hold
  simp [pmbUpdateAlive, hold] at hnew

theorem pmbUpdateAlive_is_irreversible {N d : ℕ}
    (system : ParticleSystem N d) (criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) (i j : Fin N) :
    pmbUpdateAlive system criticalStretch alive displacement i j = true →
      alive i j = true := by
  intro h
  exact pmbUpdateAlive_implies_old_alive system criticalStretch alive displacement h

end BBPD
end PeriLean
