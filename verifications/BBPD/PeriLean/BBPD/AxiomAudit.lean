import PeriLean.BBPD.PMB

/-!
This module is an audit entry point. Run
`lake env lean PeriLean/BBPD/AxiomAudit.lean`
to print the kernel-level axiom dependencies of the core theorems.
-/

#print axioms PeriLean.BBPD.referenceBond_swap
#print axioms PeriLean.BBPD.totalInternalForce_zero
#print axioms PeriLean.BBPD.pmbForce_antisymmetric
#print axioms PeriLean.BBPD.pmbUpdateAlive_is_irreversible
