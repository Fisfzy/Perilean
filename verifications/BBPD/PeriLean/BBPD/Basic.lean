import SolidMechanics

namespace PeriLean
namespace BBPD

abbrev Vec (d : ℕ) := EuclideanSpace ℝ (Fin d)

/- A finite reference configuration with positive particle volumes and densities.
   The separation condition prevents zero-length reference bonds between distinct
   particles. -/
structure ParticleSystem (N d : ℕ) where
  referencePosition : Fin N → Vec d
  volume : Fin N → ℝ
  density : Fin N → ℝ
  horizon : ℝ
  horizon_pos : 0 < horizon
  volume_pos : ∀ i, 0 < volume i
  density_pos : ∀ i, 0 < density i
  separated : ∀ ⦃i j⦄, i ≠ j → 0 < ‖referencePosition j - referencePosition i‖

def referenceBond {N d : ℕ} (system : ParticleSystem N d)
    (i j : Fin N) : Vec d :=
  system.referencePosition j - system.referencePosition i

def currentPosition {N d : ℕ} (system : ParticleSystem N d)
    (displacement : Fin N → Vec d) (i : Fin N) : Vec d :=
  system.referencePosition i + displacement i

def relativeDisplacement {N d : ℕ} (displacement : Fin N → Vec d)
    (i j : Fin N) : Vec d :=
  displacement j - displacement i

def deformedBond {N d : ℕ} (system : ParticleSystem N d)
    (displacement : Fin N → Vec d) (i j : Fin N) : Vec d :=
  referenceBond system i j + relativeDisplacement displacement i j

def isBond {N d : ℕ} (system : ParticleSystem N d) (i j : Fin N) : Prop :=
  i ≠ j ∧ ‖referenceBond system i j‖ ≤ system.horizon

noncomputable def stretch {N d : ℕ} (system : ParticleSystem N d)
    (displacement : Fin N → Vec d) (i j : Fin N) : ℝ :=
  (‖deformedBond system displacement i j‖ - ‖referenceBond system i j‖) /
    ‖referenceBond system i j‖

/- A total unit-vector operation. It returns zero at the singular current bond
   configuration, so the formal model does not hide a division-by-zero case. -/
noncomputable def unitOrZero {d : ℕ} (v : Vec d) : Vec d :=
  if h : ‖v‖ = 0 then 0 else (‖v‖)⁻¹ • v

theorem referenceBond_swap {N d : ℕ} (system : ParticleSystem N d)
    (i j : Fin N) :
    referenceBond system j i = -referenceBond system i j := by
  unfold referenceBond
  abel

theorem relativeDisplacement_swap {N d : ℕ} (displacement : Fin N → Vec d)
    (i j : Fin N) :
    relativeDisplacement displacement j i = -relativeDisplacement displacement i j := by
  unfold relativeDisplacement
  abel

theorem deformedBond_swap {N d : ℕ} (system : ParticleSystem N d)
    (displacement : Fin N → Vec d) (i j : Fin N) :
    deformedBond system displacement j i = -deformedBond system displacement i j := by
  unfold deformedBond
  rw [referenceBond_swap, relativeDisplacement_swap]
  abel

theorem isBond_swap_iff {N d : ℕ} (system : ParticleSystem N d)
    (i j : Fin N) :
    isBond system i j ↔ isBond system j i := by
  unfold isBond
  have hnorm : ‖referenceBond system j i‖ = ‖referenceBond system i j‖ := by
    rw [referenceBond_swap]
    simp
  constructor
  · rintro ⟨hij, hlen⟩
    exact ⟨Ne.symm hij, by rw [hnorm]; exact hlen⟩
  · rintro ⟨hij, hlen⟩
    exact ⟨Ne.symm hij, by rw [← hnorm]; exact hlen⟩

theorem referenceBond_ne_zero {N d : ℕ} (system : ParticleSystem N d)
    {i j : Fin N} (hij : i ≠ j) :
    referenceBond system i j ≠ 0 := by
  intro hzero
  have hpos := system.separated hij
  change system.referencePosition j - system.referencePosition i = 0 at hzero
  rw [hzero, norm_zero] at hpos
  linarith

theorem referenceBond_norm_pos {N d : ℕ} (system : ParticleSystem N d)
    {i j : Fin N} (hij : i ≠ j) :
    0 < ‖referenceBond system i j‖ := by
  simpa [referenceBond] using system.separated hij

theorem deformedBond_eq_current_sub_current {N d : ℕ}
    (system : ParticleSystem N d) (displacement : Fin N → Vec d) (i j : Fin N) :
    deformedBond system displacement i j =
      currentPosition system displacement j - currentPosition system displacement i := by
  unfold deformedBond currentPosition referenceBond relativeDisplacement
  abel

theorem stretch_swap {N d : ℕ} (system : ParticleSystem N d)
    (displacement : Fin N → Vec d) (i j : Fin N) :
    stretch system displacement j i = stretch system displacement i j := by
  unfold stretch
  rw [deformedBond_swap, referenceBond_swap]
  simp

theorem unitOrZero_neg {d : ℕ} (v : Vec d) :
    unitOrZero (-v) = -unitOrZero v := by
  by_cases h : ‖v‖ = 0
  · simp [unitOrZero, h]
  · have hneg : ‖-v‖ ≠ 0 := by simpa using h
    simp [unitOrZero, h, hneg, norm_neg, smul_neg]

theorem stretch_zero_displacement {N d : ℕ} (system : ParticleSystem N d)
    (i j : Fin N) (hij : i ≠ j) :
    stretch system (fun _ => 0) i j = 0 := by
  unfold stretch deformedBond relativeDisplacement
  simp [referenceBond, deformedBond]

theorem stretch_lower_bound {N d : ℕ} (system : ParticleSystem N d)
    (displacement : Fin N → Vec d) {i j : Fin N} (hij : i ≠ j) :
    -1 ≤ stretch system displacement i j := by
  unfold stretch
  have hpos := referenceBond_norm_pos system hij
  have hnonneg : 0 ≤ ‖deformedBond system displacement i j‖ := norm_nonneg _
  apply (le_div_iff₀ hpos).2
  linarith

end BBPD
end PeriLean
