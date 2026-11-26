import SBPD

/-!
This module is an audit entry point. Run
`lake env lean PeriLean/SBPD/AxiomAudit.lean` to inspect kernel-level
axiom dependencies of the state-based core theorems.
-/

#print axioms PeriLean.SBPD.deformationGradient_mul_shapeTensor
#print axioms PeriLean.SBPD.totalStateInternalForce_zero
#print axioms PeriLean.SBPD.discrete_linear_momentum_balance
#print axioms PeriLean.SBPD.updateAlive_irreversible
#print axioms PeriLean.SBPD.bendingMomentResultant_formula
#print axioms PeriLean.SBPD.pmbFractureEnergy_of_criticalStretch
#print axioms PeriLean.SBPD.pmbFractureEnergy_of_bulkModulus
#print axioms PeriLean.SBPD.pmbCriticalStretch_of_bulkModulus
#print axioms PeriLean.SBPD.paperStressMeasure_formula
#print axioms PeriLean.SBPD.paperForceState_formula
#print axioms PeriLean.SBPD.membraneResultant_eq_sum_layerContributions
#print axioms PeriLean.SBPD.bendingMomentResultant_eq_sum_layerContributions
#print axioms PeriLean.SBPD.bkCriticalEnergy_pure_mode_I
#print axioms PeriLean.SBPD.bkCriticalEnergy_pure_mode_II
