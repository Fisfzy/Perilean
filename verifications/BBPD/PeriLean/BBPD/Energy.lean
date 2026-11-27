import PeriLean.BBPD.Pairwise
import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Mul

namespace PeriLean
namespace BBPD

open scoped InnerProductSpace

noncomputable def internalPower {N d : ℕ} (system : ParticleSystem N d)
    (law : PairForceLaw (Fin N) d) (velocity : Fin N → Vec d) : ℝ :=
  ∑ i, system.volume i *
    ⟪internalForce system law i, velocity i⟫_ℝ

noncomputable def pairPower {N d : ℕ} (system : ParticleSystem N d)
    (law : PairForceLaw (Fin N) d) (velocity : Fin N → Vec d) : ℝ :=
  (1 / 2 : ℝ) * ∑ i, ∑ j,
    (system.volume i * system.volume j) *
      ⟪law.force i j, velocity i - velocity j⟫_ℝ

noncomputable def totalPairPotentialAlong {N d : ℕ}
    (system : ParticleSystem N d)
    (potential : Fin N → Fin N → ℝ → ℝ) (t : ℝ) : ℝ :=
  (1 / 2 : ℝ) * ∑ i, ∑ j,
    (system.volume i * system.volume j) * potential i j t

theorem hasDerivAt_totalPairPotentialAlong {N d : ℕ}
    (system : ParticleSystem N d)
    (potential derivative : Fin N → Fin N → ℝ → ℝ)
    (t : ℝ)
    (hpair : ∀ i j, HasDerivAt (potential i j) (derivative i j t) t) :
    HasDerivAt (totalPairPotentialAlong system potential)
      ((1 / 2 : ℝ) * ∑ i, ∑ j,
        (system.volume i * system.volume j) * derivative i j t) t := by
  unfold totalPairPotentialAlong
  have hsum' : HasDerivAt
      (∑ i, fun s : ℝ => ∑ j,
        (system.volume i * system.volume j) * potential i j s)
      (∑ i, ∑ j,
        (system.volume i * system.volume j) * derivative i j t) t := by
    apply HasDerivAt.sum
    intro i hi
    have hinner' : HasDerivAt
        (∑ j, fun s : ℝ =>
          (system.volume i * system.volume j) * potential i j s)
        (∑ j,
          (system.volume i * system.volume j) * derivative i j t) t := by
      apply HasDerivAt.sum
      intro j hj
      simpa [mul_assoc] using
        (hpair i j).const_mul (system.volume i * system.volume j)
    convert hinner' using 1
    funext s
    simp
  have hsum : HasDerivAt
      (fun s : ℝ => ∑ i, ∑ j,
        (system.volume i * system.volume j) * potential i j s)
      (∑ i, ∑ j,
        (system.volume i * system.volume j) * derivative i j t) t := by
    convert hsum' using 1
    funext s
    simp
  simpa [mul_assoc] using hsum.const_mul (1 / 2 : ℝ)

theorem hasDerivAt_mechanicalEnergy_balance {kinetic potential : ℝ → ℝ}
    {t externalPower pairPower : ℝ}
    (hkinetic : HasDerivAt kinetic (externalPower + pairPower) t)
    (hpotential : HasDerivAt potential (-pairPower) t) :
    HasDerivAt (fun s => kinetic s + potential s) externalPower t := by
  convert hkinetic.add hpotential using 1 <;> ring

theorem internalPower_eq_pairPower {N d : ℕ}
    (system : ParticleSystem N d) (law : PairForceLaw (Fin N) d)
    (velocity : Fin N → Vec d) :
    internalPower system law velocity = pairPower system law velocity := by
  classical
  unfold internalPower pairPower internalForce
  simp only [sum_inner]
  simp_rw [real_inner_smul_left]
  let s₁ : ℝ := ∑ i, ∑ j,
    (system.volume i * system.volume j) *
      ⟪law.force i j, velocity i⟫_ℝ
  let s₂ : ℝ := ∑ i, ∑ j,
    (system.volume i * system.volume j) *
      ⟪law.force i j, velocity j⟫_ℝ
  have hs₂ : s₂ = -s₁ := by
    dsimp [s₁, s₂]
    rw [Finset.sum_comm]
    rw [← Finset.sum_neg_distrib]
    simp_rw [← Finset.sum_neg_distrib]
    apply Finset.sum_congr rfl
    intro j hj
    apply Finset.sum_congr rfl
    intro i hi
    rw [law.antisymmetric, inner_neg_left]
    ring
  calc
    (∑ i, system.volume i * ∑ j, system.volume j *
        ⟪law.force i j, velocity i⟫_ℝ) = s₁ := by
      dsimp [s₁]
      simp_rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i hi
      apply Finset.sum_congr rfl
      intro j hj
      ring
    _ = (1 / 2 : ℝ) * (s₁ - s₂) := by
      rw [hs₂]
      ring
    _ = (1 / 2 : ℝ) * ∑ i, ∑ j,
        (system.volume i * system.volume j) *
          ⟪law.force i j, velocity i - velocity j⟫_ℝ := by
      congr 1
      dsimp [s₁, s₂]
      simp only [inner_sub_right]
      rw [← Finset.sum_sub_distrib]
      simp_rw [← Finset.sum_sub_distrib]
      apply Finset.sum_congr rfl
      intro i hi
      apply Finset.sum_congr rfl
      intro j hj
      ring

end BBPD
end PeriLean
