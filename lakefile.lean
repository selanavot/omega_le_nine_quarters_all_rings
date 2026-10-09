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
  "https://github.com/leanprover-community/mathlib4.git" @ "f0469b25d97aef3998d4bc06f6f01da670b3d18e"

@[default_target]
lean_lib OAI

lean_lib FixedPointTheorems
