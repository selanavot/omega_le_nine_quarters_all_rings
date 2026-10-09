module

public import ComparatorAudit.Solution
public import OAI.LinearAlgebra.MatrixMultiplication.FinalAudit

public section

/-! Guard all six independently specified declarations against extra axioms.
This module never imports the Challenge, which intentionally has theorem holes. -/

/-- info: 'ComparatorChecks.omega_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ComparatorChecks.omega_bound

/-- info: 'ComparatorChecks.admissible_bddBelow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ComparatorChecks.admissible_bddBelow

/-- info: 'ComparatorChecks.admissible_nonempty' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ComparatorChecks.admissible_nonempty

/-- info: 'ComparatorChecks.omega_lower' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ComparatorChecks.omega_lower

/-- info: 'ComparatorChecks.epsilon_cost' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ComparatorChecks.epsilon_cost

/-- info: 'ComparatorChecks.exact_coefficients' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ComparatorChecks.exact_coefficients

