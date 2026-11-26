import PDComposite.Constitutive

namespace PDComposite

open PeriLean.SBPD

structure Lamina where
  material : OrthotropicPlaneStress
  strength : HoffmanStrengths
  fiberAngle : ℝ
  thickness : ℝ
  thickness_pos : 0 < thickness

structure Laminate (L : ℕ) where
  layer : Fin L → Lamina

structure CompositeStateSystem (N L : ℕ) extends StateSystem N where
  layerOf : Fin N → Fin L

noncomputable def laminaStress (lamina : Lamina) (strain : PlaneStrain) : PlaneStress :=
  rotateStress lamina.fiberAngle (orthotropicStress lamina.material strain)

def sameLayer {N L : ℕ} (system : CompositeStateSystem N L)
    (i j : Fin N) : Prop :=
  system.layerOf i = system.layerOf j

def interfacePair {N L : ℕ} (system : CompositeStateSystem N L)
    (i j : Fin N) : Prop :=
  inHorizon system.toStateSystem i j ∧ ¬ sameLayer system i j

inductive BondKind
  | inactive
  | intralayer
  | interlayer
deriving DecidableEq, Repr

noncomputable def bondKind {N L : ℕ} (system : CompositeStateSystem N L)
    (i j : Fin N) : BondKind := by
  classical
  exact if h : inHorizon system.toStateSystem i j then
    if sameLayer system i j then BondKind.intralayer else BondKind.interlayer
  else BondKind.inactive

theorem sameLayer_swap {N L : ℕ} (system : CompositeStateSystem N L)
    (i j : Fin N) : sameLayer system j i ↔ sameLayer system i j := by
  unfold sameLayer
  constructor <;> intro h
  · exact h.symm
  · exact h.symm

theorem bondKind_swap {N L : ℕ} (system : CompositeStateSystem N L)
    (i j : Fin N) : bondKind system j i = bondKind system i j := by
  classical
  unfold bondKind
  by_cases h : inHorizon system.toStateSystem i j
  · have h' : inHorizon system.toStateSystem j i :=
      (inHorizon_swap system.toStateSystem i j).1 h
    by_cases hl : sameLayer system i j
    · have hl' : sameLayer system j i := (sameLayer_swap system i j).2 hl
      simp [h, h', hl, hl']
    · have hl' : ¬ sameLayer system j i := by
        intro hji
        exact hl ((sameLayer_swap system i j).1 hji)
      simp [h, h', hl, hl']
  · have h' : ¬ inHorizon system.toStateSystem j i := by
      intro hji
      exact h ((inHorizon_swap system.toStateSystem i j).2 hji)
    simp [h, h']

theorem laminaStress_zero (lamina : Lamina) :
    laminaStress lamina ⟨0, 0, 0⟩ = ⟨0, 0, 0⟩ := by
  simp [laminaStress, orthotropicStress, rotateStress]

end PDComposite
