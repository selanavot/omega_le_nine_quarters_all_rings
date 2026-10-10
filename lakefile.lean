import Lake
open Lake DSL

package omega_le_nine_quarters_all_rings where
  version := v!"0.1.0"
  description := "Matrix multiplication over rings through integer coefficient schemes"
  license := "Apache-2.0"
  srcDir := "lean"
  fixedToolchain := true
  leanOptions := #[⟨`autoImplicit, false⟩]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "c55e6e786f49471c72fbddbec5415808896aec1e"

@[default_target]
lean_lib OAI

lean_lib FixedPointTheorems

lean_lib ComparatorAudit
