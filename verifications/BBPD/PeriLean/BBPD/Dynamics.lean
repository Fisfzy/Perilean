import PeriLean.BBPD.Pairwise

namespace PeriLean
namespace BBPD

def totalExternalForce {N d : ℕ} (system : ParticleSystem N d)
    (bodyForce : Fin N → Vec d) : Vec d :=
  ∑ i, system.volume i • bodyForce i

def satisfiesDiscreteEquation {N d : ℕ} (system : ParticleSystem N d)
    (law : PairForceLaw (Fin N) d) (bodyForce acceleration : Fin N → Vec d) : Prop :=
  ∀ i, system.density i • acceleration i =
    internalForce system law i + bodyForce i

def totalInertialForce {N d : ℕ} (system : ParticleSystem N d)
    (acceleration : Fin N → Vec d) : Vec d :=
  ∑ i, system.volume i • (system.density i • acceleration i)

theorem discrete_linear_momentum_balance {N d : ℕ}
    (system : ParticleSystem N d) (law : PairForceLaw (Fin N) d)
    (bodyForce acceleration : Fin N → Vec d)
    (heom : satisfiesDiscreteEquation system law bodyForce acceleration) :
    totalInertialForce system acceleration = totalExternalForce system bodyForce := by
  unfold totalInertialForce totalExternalForce
  calc
    (∑ i, system.volume i • (system.density i • acceleration i)) =
        ∑ i, system.volume i • (internalForce system law i + bodyForce i) := by
      apply Finset.sum_congr rfl
      intro i hi
      rw [heom i]
    _ = (∑ i, system.volume i • internalForce system law i) +
        (∑ i, system.volume i • bodyForce i) := by
      simp_rw [smul_add, Finset.sum_add_distrib]
    _ = ∑ i, system.volume i • bodyForce i := by
      have hzero := totalInternalForce_zero system law
      change totalInternalForce system law +
        (∑ i, system.volume i • bodyForce i) = _
      rw [hzero]
      simp

theorem discrete_internal_force_balance {N d : ℕ}
    (system : ParticleSystem N d) (law : PairForceLaw (Fin N) d) :
    ∑ i, system.volume i • internalForce system law i = 0 := by
  exact totalInternalForce_zero system law

def angularAdmissible {ι : Type*} {d : ℕ}
    (position : ι → Vec d) (force : ι → ι → Vec d) : Prop :=
  ∀ i j, ∃ a : ℝ, force i j = a • (position j - position i)

theorem angularAdmissible_eq_isCentral {ι : Type*} {d : ℕ}
    (position : ι → Vec d) (force : ι → ι → Vec d) :
    angularAdmissible position force ↔ IsCentral position force := by
  rfl

end BBPD
end PeriLean
