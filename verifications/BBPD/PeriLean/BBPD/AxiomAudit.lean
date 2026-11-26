import PeriLean.BBPD.Moment
import PeriLean.BBPD.PMB
import PeriLean.BBPD.Calibration

/-!
This module is an audit entry point. Run
`lake env lean PeriLean/BBPD/AxiomAudit.lean`
to print the kernel-level axiom dependencies of the core theorems.
-/

#print axioms PeriLean.BBPD.referenceBond_swap
#print axioms PeriLean.BBPD.totalInternalForce_zero
#print axioms PeriLean.BBPD.pmbForce_antisymmetric
#print axioms PeriLean.BBPD.pmbUpdateAlive_is_irreversible
#print axioms PeriLean.BBPD.pairTorque_zero_of_central_and_antisymmetric
#print axioms PeriLean.BBPD.pmbPairTorque_zero
#print axioms PeriLean.BBPD.pmbForce_formula_current_direction
#print axioms PeriLean.BBPD.pmbFractureEnergy_of_bulkModulus
#print axioms PeriLean.BBPD.pmbCriticalStretch_of_bulkModulus
