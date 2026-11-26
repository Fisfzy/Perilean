import PeriLean.SBPD.Basic

namespace PeriLean
namespace SBPD

def totalExternalForce {N : ℕ} (system : StateSystem N)
    (bodyForce : Fin N → Vec2) : Vec2 :=
  ∑ i, system.volume i • bodyForce i

def satisfiesDiscreteStateEquation {N : ℕ} (system : StateSystem N)
    (state : Fin N → Fin N → Vec2)
    (bodyForce acceleration : Fin N → Vec2) : Prop :=
  ∀ i, system.density i • acceleration i =
    stateInternalForce system state i + bodyForce i

def totalInertialForce {N : ℕ} (system : StateSystem N)
    (acceleration : Fin N → Vec2) : Vec2 :=
  ∑ i, system.volume i • (system.density i • acceleration i)

theorem discrete_linear_momentum_balance {N : ℕ}
    (system : StateSystem N) (state : Fin N → Fin N → Vec2)
    (bodyForce acceleration : Fin N → Vec2)
    (heom : satisfiesDiscreteStateEquation system state bodyForce acceleration) :
    totalInertialForce system acceleration = totalExternalForce system bodyForce := by
  unfold totalInertialForce totalExternalForce
  calc
    (∑ i, system.volume i • (system.density i • acceleration i)) =
        ∑ i, system.volume i • (stateInternalForce system state i + bodyForce i) := by
      apply Finset.sum_congr rfl
      intro i hi
      rw [heom i]
    _ = (∑ i, system.volume i • stateInternalForce system state i) +
        (∑ i, system.volume i • bodyForce i) := by
      simp_rw [smul_add, Finset.sum_add_distrib]
    _ = ∑ i, system.volume i • bodyForce i := by
      change totalStateInternalForce system state +
        (∑ i, system.volume i • bodyForce i) = _
      rw [totalStateInternalForce_zero system state]
      simp

theorem discrete_internal_force_balance {N : ℕ}
    (system : StateSystem N) (state : Fin N → Fin N → Vec2) :
    ∑ i, system.volume i • stateInternalForce system state i = 0 := by
  exact totalStateInternalForce_zero system state

end SBPD
end PeriLean
