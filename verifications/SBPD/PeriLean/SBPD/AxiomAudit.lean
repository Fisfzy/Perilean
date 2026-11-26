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
