import PeriLean.SBPD.Constitutive

namespace PeriLean
namespace SBPD

noncomputable def pmb3DMicromodulus (bulkModulus horizon : ℝ) : ℝ :=
  18 * bulkModulus / (Real.pi * horizon ^ 4)

noncomputable def pmbFractureEnergy (micromodulus criticalStretch horizon : ℝ) : ℝ :=
  Real.pi * micromodulus * criticalStretch ^ 2 * horizon ^ 5 / 10

noncomputable def pmbCriticalStretch (fractureEnergy micromodulus horizon : ℝ) : ℝ :=
  Real.sqrt (10 * fractureEnergy / (Real.pi * micromodulus * horizon ^ 5))

noncomputable def fiberCriticalStretch (tensileStrength longitudinalModulus : ℝ) : ℝ :=
  tensileStrength / longitudinalModulus

noncomputable def matrixCriticalStretch (tensileStrength transverseModulus : ℝ) : ℝ :=
  tensileStrength / transverseModulus

noncomputable def interfaceStiffness (throughThicknessModulus interfaceHorizon : ℝ) : ℝ :=
  throughThicknessModulus / interfaceHorizon

noncomputable def bkCriticalEnergy (GIc GIIc GII GT eta : ℝ) : ℝ :=
  GIc + (GIIc - GIc) * (GII / GT) ^ eta

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

theorem pmbFractureEnergy_of_bulkModulus {K s0 delta : ℝ}
    (hK : 0 < K) (hd : 0 < delta) :
    pmbFractureEnergy (pmb3DMicromodulus K delta) s0 delta =
      (9 / 5 : ℝ) * K * s0 ^ 2 * delta := by
  unfold pmbFractureEnergy pmb3DMicromodulus
  field_simp [ne_of_gt hK, ne_of_gt hd, ne_of_gt Real.pi_pos]
  ring

theorem pmbCriticalStretch_of_bulkModulus {G K delta : ℝ}
    (hG : 0 ≤ G) (hK : 0 < K) (hd : 0 < delta) :
    pmbCriticalStretch G (pmb3DMicromodulus K delta) delta =
      Real.sqrt (5 * G / (9 * K * delta)) := by
  unfold pmbCriticalStretch pmb3DMicromodulus
  congr 1
  field_simp [ne_of_gt hK, ne_of_gt hd, ne_of_gt Real.pi_pos]
  ring

theorem pmbFractureEnergy_nonneg {c s0 delta : ℝ}
    (hc : 0 ≤ c) (hs : 0 ≤ s0) (hd : 0 ≤ delta) :
    0 ≤ pmbFractureEnergy c s0 delta := by
  unfold pmbFractureEnergy
  positivity

theorem fiberCriticalStretch_formula {Xt E1 : ℝ} :
    fiberCriticalStretch Xt E1 = Xt / E1 := by
  rfl

theorem fiberCriticalStretch_recovery {Xt E1 : ℝ} (hE : E1 ≠ 0) :
    E1 * fiberCriticalStretch Xt E1 = Xt := by
  unfold fiberCriticalStretch
  field_simp

theorem matrixCriticalStretch_recovery {Yt E2 : ℝ} (hE : E2 ≠ 0) :
    E2 * matrixCriticalStretch Yt E2 = Yt := by
  unfold matrixCriticalStretch
  field_simp

theorem interfaceStiffness_recovery {E3 deltaI : ℝ} (hdelta : deltaI ≠ 0) :
    deltaI * interfaceStiffness E3 deltaI = E3 := by
  unfold interfaceStiffness
  field_simp

theorem bkCriticalEnergy_formula (GIc GIIc GII GT eta : ℝ) :
    bkCriticalEnergy GIc GIIc GII GT eta =
      GIc + (GIIc - GIc) * (GII / GT) ^ eta := by
  rfl

theorem bkCriticalEnergy_pure_mode_I {GIc GIIc GT eta : ℝ}
    (heta : 0 < eta) :
    bkCriticalEnergy GIc GIIc 0 GT eta = GIc := by
  unfold bkCriticalEnergy
  rw [zero_div, Real.zero_rpow (ne_of_gt heta)]
  ring

theorem bkCriticalEnergy_pure_mode_II {GIc GIIc GT eta : ℝ}
    (hGT : GT ≠ 0) :
    bkCriticalEnergy GIc GIIc GT GT eta = GIIc := by
  unfold bkCriticalEnergy
  have hratio : GT / GT = (1 : ℝ) := by
    field_simp
  rw [hratio, Real.one_rpow]
  ring

end SBPD
end PeriLean
