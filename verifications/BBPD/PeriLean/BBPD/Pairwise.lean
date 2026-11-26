import PeriLean.BBPD.Basic

namespace PeriLean
namespace BBPD

structure PairForceLaw (ι : Type*) (d : ℕ) where
  force : ι → ι → Vec d
  antisymmetric : ∀ i j, force i j = -force j i

def IsCentral {ι : Type*} {d : ℕ}
    (position : ι → Vec d) (force : ι → ι → Vec d) : Prop :=
  ∀ i j, ∃ a : ℝ, force i j = a • (position j - position i)

def weightedPairForce {N d : ℕ} (system : ParticleSystem N d)
    (law : PairForceLaw (Fin N) d) (i j : Fin N) : Vec d :=
  (system.volume i * system.volume j) • law.force i j

def internalForce {N d : ℕ} (system : ParticleSystem N d)
    (law : PairForceLaw (Fin N) d) (i : Fin N) : Vec d :=
  ∑ j, system.volume j • law.force i j

def totalInternalForce {N d : ℕ} (system : ParticleSystem N d)
    (law : PairForceLaw (Fin N) d) : Vec d :=
  ∑ i, system.volume i • internalForce system law i

theorem weightedPairForce_antisymmetric {N d : ℕ}
    (system : ParticleSystem N d) (law : PairForceLaw (Fin N) d)
    (i j : Fin N) :
    weightedPairForce system law i j = -weightedPairForce system law j i := by
  unfold weightedPairForce
  rw [law.antisymmetric]
  simp [mul_comm, smul_neg]

theorem totalInternalForce_eq_sum_pair {N d : ℕ}
    (system : ParticleSystem N d) (law : PairForceLaw (Fin N) d) :
    totalInternalForce system law =
      ∑ i, ∑ j, weightedPairForce system law i j := by
  unfold totalInternalForce internalForce weightedPairForce
  simp_rw [Finset.smul_sum, smul_smul]

theorem totalInternalForce_zero {N d : ℕ}
    (system : ParticleSystem N d) (law : PairForceLaw (Fin N) d) :
    totalInternalForce system law = 0 := by
  classical
  rw [totalInternalForce_eq_sum_pair]
  let pair : Fin N → Fin N → Vec d := weightedPairForce system law
  have hpair : ∀ i j, pair j i = -pair i j := by
    intro i j
    simpa [pair] using weightedPairForce_antisymmetric system law j i
  have hsum : (∑ i, ∑ j, pair i j) = -∑ i, ∑ j, pair i j := by
    calc
      (∑ i, ∑ j, pair i j) = ∑ j, ∑ i, pair i j := by
        rw [Finset.sum_comm]
      _ = ∑ j, ∑ i, -pair j i := by
        apply Finset.sum_congr rfl
        intro j hj
        apply Finset.sum_congr rfl
        intro i hi
        rw [hpair]
      _ = -∑ j, ∑ i, pair j i := by
        simp only [Finset.sum_neg_distrib]
      _ = -∑ i, ∑ j, pair i j := by
        rw [Finset.sum_comm]
  have hadd : (∑ i, ∑ j, pair i j) + (∑ i, ∑ j, pair i j) = 0 :=
    (eq_neg_iff_add_eq_zero.mp hsum)
  calc
    (∑ i, ∑ j, pair i j) = (1 / 2 : ℝ) • ((2 : ℝ) • (∑ i, ∑ j, pair i j)) := by
      rw [smul_smul]
      norm_num
    _ = (1 / 2 : ℝ) • ((∑ i, ∑ j, pair i j) + (∑ i, ∑ j, pair i j)) := by
      rw [two_smul]
    _ = 0 := by rw [hadd]; simp

end BBPD
end PeriLean
