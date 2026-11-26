import PeriLean.SBPD.Composite

namespace PeriLean
namespace SBPD

abbrev Vec3 := Fin 3 → ℝ
abbrev Mat3 := Matrix (Fin 3) (Fin 3) ℝ

structure LayerSlice where
  stiffness : Mat3
  zBottom : ℝ
  zTop : ℝ
  thickness_pos : 0 < zTop - zBottom

def extensionalStiffness {L : ℕ} (layer : Fin L → LayerSlice) : Mat3 :=
  ∑ k, ((layer k).zTop - (layer k).zBottom) • (layer k).stiffness

noncomputable def couplingStiffness {L : ℕ} (layer : Fin L → LayerSlice) : Mat3 :=
  ∑ k, (((layer k).zTop ^ 2 - (layer k).zBottom ^ 2) / 2) •
    (layer k).stiffness

noncomputable def bendingStiffness {L : ℕ} (layer : Fin L → LayerSlice) : Mat3 :=
  ∑ k, (((layer k).zTop ^ 3 - (layer k).zBottom ^ 3) / 3) •
    (layer k).stiffness

def membraneResultant (A B : Mat3) (membraneStrain curvature : Vec3) : Vec3 :=
  Matrix.mulVec A membraneStrain + Matrix.mulVec B curvature

def bendingMomentResultant (B D : Mat3) (membraneStrain curvature : Vec3) : Vec3 :=
  Matrix.mulVec B membraneStrain + Matrix.mulVec D curvature

noncomputable def membraneLayerContribution (slice : LayerSlice)
    (membraneStrain curvature : Vec3) : Vec3 :=
  (slice.zTop - slice.zBottom) • Matrix.mulVec slice.stiffness membraneStrain +
    ((slice.zTop ^ 2 - slice.zBottom ^ 2) / 2) • Matrix.mulVec slice.stiffness curvature

noncomputable def bendingLayerContribution (slice : LayerSlice)
    (membraneStrain curvature : Vec3) : Vec3 :=
  ((slice.zTop ^ 2 - slice.zBottom ^ 2) / 2) • Matrix.mulVec slice.stiffness membraneStrain +
    ((slice.zTop ^ 3 - slice.zBottom ^ 3) / 3) • Matrix.mulVec slice.stiffness curvature

def abdResultant (A B D : Mat3) (membraneStrain curvature : Vec3) : Vec3 × Vec3 :=
  (membraneResultant A B membraneStrain curvature,
    bendingMomentResultant B D membraneStrain curvature)

theorem extensionalStiffness_formula {L : ℕ} (layer : Fin L → LayerSlice) :
    extensionalStiffness layer =
      ∑ k, ((layer k).zTop - (layer k).zBottom) • (layer k).stiffness := by
  rfl

theorem couplingStiffness_formula {L : ℕ} (layer : Fin L → LayerSlice) :
    couplingStiffness layer =
      ∑ k, (((layer k).zTop ^ 2 - (layer k).zBottom ^ 2) / 2) •
        (layer k).stiffness := by
  rfl

theorem bendingStiffness_formula {L : ℕ} (layer : Fin L → LayerSlice) :
    bendingStiffness layer =
      ∑ k, (((layer k).zTop ^ 3 - (layer k).zBottom ^ 3) / 3) •
        (layer k).stiffness := by
  rfl

theorem bendingMomentResultant_formula (B D : Mat3)
    (membraneStrain curvature : Vec3) :
    bendingMomentResultant B D membraneStrain curvature =
      Matrix.mulVec B membraneStrain + Matrix.mulVec D curvature := by
  rfl

theorem membraneResultant_eq_sum_layerContributions {L : ℕ}
    (layer : Fin L → LayerSlice) (membraneStrain curvature : Vec3) :
    membraneResultant (extensionalStiffness layer) (couplingStiffness layer)
        membraneStrain curvature =
      ∑ k, membraneLayerContribution (layer k) membraneStrain curvature := by
  unfold membraneResultant extensionalStiffness couplingStiffness membraneLayerContribution
  simp only [Matrix.sum_mulVec, Matrix.smul_mulVec, Finset.sum_add_distrib]

theorem bendingMomentResultant_eq_sum_layerContributions {L : ℕ}
    (layer : Fin L → LayerSlice) (membraneStrain curvature : Vec3) :
    bendingMomentResultant (couplingStiffness layer) (bendingStiffness layer)
        membraneStrain curvature =
      ∑ k, bendingLayerContribution (layer k) membraneStrain curvature := by
  unfold bendingMomentResultant couplingStiffness bendingStiffness bendingLayerContribution
  simp only [Matrix.sum_mulVec, Matrix.smul_mulVec, Finset.sum_add_distrib]

theorem abdResultant_formula (A B D : Mat3)
    (membraneStrain curvature : Vec3) :
    abdResultant A B D membraneStrain curvature =
      (Matrix.mulVec A membraneStrain + Matrix.mulVec B curvature,
        Matrix.mulVec B membraneStrain + Matrix.mulVec D curvature) := by
  rfl

theorem bendingMoment_zero_of_zero_strain (B D : Mat3) (curvature : Vec3) :
    bendingMomentResultant B D 0 curvature = Matrix.mulVec D curvature := by
  simp [bendingMomentResultant]

theorem bendingMoment_zero_of_zero_curvature (B D : Mat3) (membraneStrain : Vec3) :
    bendingMomentResultant B D membraneStrain 0 = Matrix.mulVec B membraneStrain := by
  simp [bendingMomentResultant]

end SBPD
end PeriLean
