import PeriLean.SBPD.Basic

namespace PDComposite

open PeriLean.SBPD

structure PlaneStrain where
  e1 : ℝ
  e2 : ℝ
  gamma12 : ℝ

structure PlaneStress where
  sigma1 : ℝ
  sigma2 : ℝ
  tau12 : ℝ

structure OrthotropicPlaneStress where
  E1 : ℝ
  E2 : ℝ
  G12 : ℝ
  nu12 : ℝ
  E1_pos : 0 < E1
  E2_pos : 0 < E2
  G12_pos : 0 < G12
  denominator_pos : 0 < 1 - nu12 * (nu12 * E2 / E1)

noncomputable def nu21 (material : OrthotropicPlaneStress) : ℝ :=
  material.nu12 * material.E2 / material.E1

noncomputable def q11 (material : OrthotropicPlaneStress) : ℝ :=
  material.E1 / (1 - material.nu12 * nu21 material)

noncomputable def q12 (material : OrthotropicPlaneStress) : ℝ :=
  material.nu12 * material.E2 / (1 - material.nu12 * nu21 material)

noncomputable def q22 (material : OrthotropicPlaneStress) : ℝ :=
  material.E2 / (1 - material.nu12 * nu21 material)

noncomputable def q66 (material : OrthotropicPlaneStress) : ℝ :=
  material.G12

noncomputable def orthotropicStress (material : OrthotropicPlaneStress)
    (strain : PlaneStrain) : PlaneStress :=
  { sigma1 := q11 material * strain.e1 + q12 material * strain.e2
    sigma2 := q12 material * strain.e1 + q22 material * strain.e2
    tau12 := q66 material * strain.gamma12 }

theorem nu21_formula (material : OrthotropicPlaneStress) :
    nu21 material = material.nu12 * material.E2 / material.E1 := by
  rfl

theorem poisson_reciprocity (material : OrthotropicPlaneStress) :
    material.nu12 * material.E2 = nu21 material * material.E1 := by
  unfold nu21
  field_simp [ne_of_gt material.E1_pos]

theorem q11_pos (material : OrthotropicPlaneStress) : 0 < q11 material := by
  unfold q11
  exact div_pos material.E1_pos material.denominator_pos

theorem q22_pos (material : OrthotropicPlaneStress) : 0 < q22 material := by
  unfold q22
  exact div_pos material.E2_pos material.denominator_pos

theorem q66_pos (material : OrthotropicPlaneStress) : 0 < q66 material := by
  exact material.G12_pos

theorem orthotropicStress_zero (material : OrthotropicPlaneStress) :
    orthotropicStress material ⟨0, 0, 0⟩ = ⟨0, 0, 0⟩ := by
  simp [orthotropicStress]

noncomputable def rotateStress (angle : ℝ) (stress : PlaneStress) : PlaneStress :=
  let c := Real.cos angle
  let s := Real.sin angle
  { sigma1 := c ^ 2 * stress.sigma1 + s ^ 2 * stress.sigma2 +
      2 * s * c * stress.tau12
    sigma2 := s ^ 2 * stress.sigma1 + c ^ 2 * stress.sigma2 -
      2 * s * c * stress.tau12
    tau12 := s * c * stress.sigma1 - s * c * stress.sigma2 +
      (c ^ 2 - s ^ 2) * stress.tau12 }

theorem rotateStress_zero (stress : PlaneStress) :
    rotateStress 0 stress = stress := by
  cases stress
  simp [rotateStress]

structure HoffmanStrengths where
  Xt : ℝ
  Xc : ℝ
  Yt : ℝ
  Yc : ℝ
  S : ℝ
  Xt_pos : 0 < Xt
  Xc_pos : 0 < Xc
  Yt_pos : 0 < Yt
  Yc_pos : 0 < Yc
  S_pos : 0 < S

noncomputable def hoffmanIndex (strength : HoffmanStrengths) (stress : PlaneStress) : ℝ :=
  stress.sigma1 ^ 2 / (strength.Xt * strength.Xc) -
    stress.sigma1 * stress.sigma2 / (strength.Xt * strength.Xc) +
    stress.sigma2 ^ 2 / (strength.Yt * strength.Yc) +
    (strength.Xt - strength.Xc) / (strength.Xt * strength.Xc) * stress.sigma1 +
    (strength.Yt - strength.Yc) / (strength.Yt * strength.Yc) * stress.sigma2 +
    stress.tau12 ^ 2 / strength.S ^ 2

def hoffmanFailed (strength : HoffmanStrengths) (stress : PlaneStress) : Prop :=
  1 ≤ hoffmanIndex strength stress

theorem hoffmanFailed_of_eq_one (strength : HoffmanStrengths) (stress : PlaneStress)
    (h : hoffmanIndex strength stress = 1) :
    hoffmanFailed strength stress := by
  unfold hoffmanFailed
  rw [h]

noncomputable def averageStress (left right : PlaneStress) : PlaneStress :=
  { sigma1 := (left.sigma1 + right.sigma1) / 2
    sigma2 := (left.sigma2 + right.sigma2) / 2
    tau12 := (left.tau12 + right.tau12) / 2 }

theorem averageStress_comm (left right : PlaneStress) :
    averageStress left right = averageStress right left := by
  cases left
  cases right
  simp [averageStress, add_comm]

noncomputable def pairHoffmanIndex {N : ℕ} (strength : HoffmanStrengths)
    (stress : Fin N → PlaneStress) (i j : Fin N) : ℝ :=
  hoffmanIndex strength (averageStress (stress i) (stress j))

def pairHoffmanFailed {N : ℕ} (strength : HoffmanStrengths)
    (stress : Fin N → PlaneStress) (i j : Fin N) : Prop :=
  1 ≤ pairHoffmanIndex strength stress i j

theorem pairHoffmanIndex_swap {N : ℕ} (strength : HoffmanStrengths)
    (stress : Fin N → PlaneStress) (i j : Fin N) :
    pairHoffmanIndex strength stress i j = pairHoffmanIndex strength stress j i := by
  unfold pairHoffmanIndex
  rw [averageStress_comm]

theorem pairHoffmanFailed_swap {N : ℕ} (strength : HoffmanStrengths)
    (stress : Fin N → PlaneStress) (i j : Fin N) :
    pairHoffmanFailed strength stress i j ↔ pairHoffmanFailed strength stress j i := by
  unfold pairHoffmanFailed
  rw [pairHoffmanIndex_swap]

end PDComposite
