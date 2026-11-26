import PeriLean.BBPD.Potential

namespace PeriLean
namespace BBPD

noncomputable def pmb3DMicromodulus (bulkModulus horizon : ℝ) : ℝ :=
  18 * bulkModulus / (Real.pi * horizon ^ 4)

noncomputable def pmbFractureEnergy (micromodulus criticalStretch horizon : ℝ) : ℝ :=
  Real.pi * micromodulus * criticalStretch ^ 2 * horizon ^ 5 / 10

noncomputable def pmbCriticalStretch (fractureEnergy micromodulus horizon : ℝ) : ℝ :=
  Real.sqrt (10 * fractureEnergy / (Real.pi * micromodulus * horizon ^ 5))

theorem pmbFractureEnergy_nonneg {c s0 delta : ℝ}
    (hc : 0 ≤ c) (hs : 0 ≤ s0) (hd : 0 ≤ delta) :
    0 ≤ pmbFractureEnergy c s0 delta := by
  unfold pmbFractureEnergy
  positivity

theorem pmbCriticalStretch_sq {G c delta : ℝ}
    (hG : 0 ≤ G) (hc : 0 < c) (hd : 0 < delta) :
    pmbCriticalStretch G c delta ^ 2 =
      10 * G / (Real.pi * c * delta ^ 5) := by
  unfold pmbCriticalStretch
  rw [Real.sq_sqrt]
  positivity

theorem pmbFractureEnergy_of_criticalStretch {G c delta : ℝ}
    (hG : 0 ≤ G) (hc : 0 < c) (hd : 0 < delta) :
    pmbFractureEnergy c (pmbCriticalStretch G c delta) delta = G := by
  unfold pmbFractureEnergy
  rw [pmbCriticalStretch_sq hG hc hd]
  field_simp

theorem pmb3DMicromodulus_pos {K delta : ℝ}
    (hK : 0 < K) (hd : 0 < delta) :
    0 < pmb3DMicromodulus K delta := by
  unfold pmb3DMicromodulus
  positivity

theorem pmb3DMicromodulus_formula :
    pmb3DMicromodulus K delta = 18 * K / (Real.pi * delta ^ 4) := by
  rfl

end BBPD
end PeriLean
