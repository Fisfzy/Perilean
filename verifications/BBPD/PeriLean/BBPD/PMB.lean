import PeriLean.BBPD.Pairwise

namespace PeriLean
namespace BBPD

noncomputable def pmbForce {N d : ℕ} (system : ParticleSystem N d)
    (micromodulus criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) (i j : Fin N) : Vec d := by
  classical
  exact if isBond system i j then
    if alive i j then
      (micromodulus * stretch system displacement i j) •
        unitOrZero (deformedBond system displacement i j)
    else 0
  else 0

theorem pmbForce_zero_if_failed {N d : ℕ}
    (system : ParticleSystem N d) (micromodulus criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) {i j : Fin N}
    (hfailed : ¬ alive i j) :
    pmbForce system micromodulus criticalStretch alive displacement i j = 0 := by
  classical
  simp [pmbForce, hfailed]

theorem pmbForce_zero_if_not_bond {N d : ℕ}
    (system : ParticleSystem N d) (micromodulus criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) {i j : Fin N}
    (hnotbond : ¬ isBond system i j) :
    pmbForce system micromodulus criticalStretch alive displacement i j = 0 := by
  classical
  simp [pmbForce, hnotbond]

theorem pmbForce_antisymmetric {N d : ℕ}
    (system : ParticleSystem N d) (micromodulus criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d)
    (halive : ∀ i j, alive i j = alive j i) (i j : Fin N) :
    pmbForce system micromodulus criticalStretch alive displacement i j =
      -pmbForce system micromodulus criticalStretch alive displacement j i := by
  classical
  by_cases hb : isBond system i j
  · have hbj : isBond system j i := (isBond_swap_iff system i j).1 hb
    by_cases h : alive i j = true
    · have hji : alive j i = true := by
        rw [← halive i j]
        exact h
      simp only [pmbForce, hb, hbj, h, hji, ↓reduceIte]
      rw [stretch_swap, deformedBond_swap, unitOrZero_neg]
      simp [smul_neg]
    · have hji : alive j i ≠ true := by
        intro hji
        apply h
        rw [halive i j]
        exact hji
      simp [pmbForce, hb, hbj, h, hji]
  · have hbj : ¬ isBond system j i := by
      intro hji
      exact hb ((isBond_swap_iff system i j).2 hji)
    simp [pmbForce, hb, hbj]

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
  classical
  intro i j
  by_cases hb : isBond system i j
  · by_cases h : alive i j = true
    · by_cases hcurr :
          currentPosition system displacement j - currentPosition system displacement i = 0
      · refine ⟨0, ?_⟩
        simp [pmbForce, hb, h, unitOrZero, deformedBond_eq_current_sub_current, hcurr]
      · refine ⟨micromodulus * stretch system displacement i j /
            ‖currentPosition system displacement j - currentPosition system displacement i‖, ?_⟩
        simp only [pmbForce, hb, h, ↓reduceIte]
        rw [deformedBond_eq_current_sub_current]
        have hnorm :
            ‖currentPosition system displacement j - currentPosition system displacement i‖ ≠ 0 := by
          intro hz
          apply hcurr
          exact norm_eq_zero.mp hz
        simp [unitOrZero, hnorm, smul_smul]
        field_simp
    · refine ⟨0, ?_⟩
      simp [pmbForce, hb, h]
  · refine ⟨0, ?_⟩
    simp [pmbForce, hb]

noncomputable def pmbUpdateAlive {N d : ℕ} (system : ParticleSystem N d)
    (criticalStretch : ℝ) (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) (i j : Fin N) : Bool := by
  classical
  exact if isBond system i j then
    if alive i j then decide (stretch system displacement i j ≤ criticalStretch) else false
  else false

theorem pmbUpdateAlive_implies_old_alive {N d : ℕ}
    (system : ParticleSystem N d) (criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) {i j : Fin N}
    (hnew : pmbUpdateAlive system criticalStretch alive displacement i j = true) :
    alive i j = true := by
  classical
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
