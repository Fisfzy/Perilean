import PeriLean.BBPD.PMB

namespace PeriLean
namespace BBPD

/-!
先在单键层面陈述刚体运动性质。这样几何定理不依赖具体粒子索引，
并且平移抵消与正交线性映射保持范数这两点都显式可见。
-/

noncomputable def bondStretch (referenceBond relativeDisplacement : Vec d) : ℝ :=
  (‖referenceBond + relativeDisplacement‖ - ‖referenceBond‖) /
    ‖referenceBond‖

noncomputable def bondForce (micromodulus : ℝ)
    (referenceBond relativeDisplacement : Vec d) : Vec d :=
  (micromodulus * bondStretch referenceBond relativeDisplacement) •
    unitOrZero (referenceBond + relativeDisplacement)

noncomputable def bondPotential (micromodulus : ℝ)
    (referenceBond relativeDisplacement : Vec d) : ℝ :=
  (1 / 2 : ℝ) * micromodulus * ‖referenceBond‖ *
    (bondStretch referenceBond relativeDisplacement) ^ 2

theorem stretch_eq_bondStretch {N d : ℕ} (system : ParticleSystem N d)
    (displacement : Fin N → Vec d) (i j : Fin N) :
    stretch system displacement i j =
      bondStretch (referenceBond system i j)
        (relativeDisplacement displacement i j) := by
  rfl

theorem pmbForce_eq_bondForce_on_bond {N d : ℕ}
    (system : ParticleSystem N d) (micromodulus criticalStretch : ℝ)
    (alive : Fin N → Fin N → Bool)
    (displacement : Fin N → Vec d) {i j : Fin N}
    (hbond : isBond system i j) (halive : alive i j = true) :
    pmbForce system micromodulus criticalStretch alive displacement i j =
      bondForce micromodulus (referenceBond system i j)
        (relativeDisplacement displacement i j) := by
  exact pmbForce_formula_on_bond system micromodulus criticalStretch alive
    displacement hbond halive

theorem bondStretch_isometry {d : ℕ}
    (Q : Vec d ≃ₗᵢ[ℝ] Vec d) (referenceBond relativeDisplacement : Vec d) :
    bondStretch (Q referenceBond) (Q relativeDisplacement) =
      bondStretch referenceBond relativeDisplacement := by
  unfold bondStretch
  rw [← Q.map_add, Q.norm_map, Q.norm_map]

theorem unitOrZero_isometry {d : ℕ}
    (Q : Vec d ≃ₗᵢ[ℝ] Vec d) (v : Vec d) :
    unitOrZero (Q v) = Q (unitOrZero v) := by
  by_cases h : ‖v‖ = 0
  · have hQ : ‖Q v‖ = 0 := by simp [Q.norm_map, h]
    simp [unitOrZero, h, hQ, Q.map_zero]
  · have hQ : ‖Q v‖ ≠ 0 := by simpa [Q.norm_map] using h
    simp [unitOrZero, h, hQ, Q.map_smul, Q.norm_map]

theorem bondForce_objective {d : ℕ}
    (Q : Vec d ≃ₗᵢ[ℝ] Vec d) (micromodulus : ℝ)
    (referenceBond relativeDisplacement : Vec d) :
    bondForce micromodulus (Q referenceBond) (Q relativeDisplacement) =
      Q (bondForce micromodulus referenceBond relativeDisplacement) := by
  unfold bondForce
  rw [← Q.map_add, unitOrZero_isometry, bondStretch_isometry, Q.map_smul]

theorem bondPotential_objective {d : ℕ}
    (Q : Vec d ≃ₗᵢ[ℝ] Vec d) (micromodulus : ℝ)
    (referenceBond relativeDisplacement : Vec d) :
    bondPotential micromodulus (Q referenceBond) (Q relativeDisplacement) =
      bondPotential micromodulus referenceBond relativeDisplacement := by
  simp [bondPotential, bondStretch_isometry, Q.norm_map]

end BBPD
end PeriLean
