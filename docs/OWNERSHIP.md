# Ownership

## Active rc3 intake handoff

2026-10-10, documentation branch `docs/palomar-rc3-intake`:

- Root: monitor current intake `psdxspsdhwdz`, retain private credentials outside
  Git, and coordinate any follow-up. Only root starts Lean/Lake processes.
- `rc2_audit_requirements`: AGENTS.md, README.md, docs/STATUS.md, docs/PLAN.md,
  docs/OWNERSHIP.md, docs/PALOMAR.md and verification/palomar/README.md;
  verification/palomar/registry-psdxspsdhwdz.json; commit and push updates to
  documentation PR #7. Do not merge it.
- Additional assignments require an explicit file list from root. The
  arithmetic model, frozen Challenge statements and published records remain
  protected. Do not edit another agent's files while its work is in progress.

Local proof, kernel, Comparator, negative-control and rendering checks passed.
The official hosted preflight passed candidate
`9d10116c89f9bdcdaccd58aacea353d4b7ae6e90`; [PR #6](https://github.com/selanavot/omega_le_nine_quarters_all_rings/pull/6)
is merged with explicit approval. No Lean proof repair was needed; all 160 files
under `lean/` are unchanged. Sela also approved the corrected intake and
overnight monitor. That approval does not authorize another PR merge or final
registration. Later receipt/docs commits must not be represented as the
preflight or intake's immutable target.
Registry mechanical verification of `psdxspsdhwdz` passed; rendering and review
remain unconfirmed. Root monitors the API/service state separately from the
completed public workflow. No proof rebuild is needed to retain its report.

## Historical proof and publication assignments

- Root: setup, docs/paper, serialized build coordinator; integral Fourier/separation and determinant/sector integration; Integral/{Cyclotomic,UnnormalizedFourier}.
- ring_statement: Model; Arithmetic/{Complexity,Programs,ProgramComposition,NaiveAlgorithm,Padding,LowerBound,Exponent,RecursiveBlockPrograms,Growth}; Polynomial/ExpressionFamily; Integral/Arithmetic; Character/{Dot,Permutation,Symmetrization}; Convolution/{Basic,Symmetry}; Growth/NormalizedProfile; Entropy/Tag; docs/ARITHMETIC-STATUS.md.
- ring_spectrum: Tensor/ComplexTensorFlattening; AuxiliarySeparation/Arithmetic/RankExponent; AuxiliarySeparation/Tensor/{Semiring,Scalar,Characters,CharacterBounds,BinaryCharacter,DirectSumClass,SupportExtension,SixfoldProductBounds,Primitive,PrimitiveClass}; Character/{Basic,Existence}; Spectrum/Obstruction; docs/SPECTRUM-STATUS.md.
- omega_constructions: AuxiliarySeparation/Integral/{Restriction,CoefficientExtraction,FiniteFreeDescent,CoprimePatch,Vandermonde} and additional transport modules except Integral/Arithmetic; Polynomial/{ComplexPolynomialApproximation,ComplexPolynomialDegenerationComposition}; docs/TRANSPORT-STATUS.md.
- No other writers until assigned an explicit file list. Every audit gets a unique filename.

Only root runs the queue worker; agents submit builds using scripts/lean-queue.py.

Further assignments:
- ring_statement: Arithmetic/CharacterRounding; Tensor/{SharedPadding,TagInequality}.
- ring_spectrum: Integral/CharacterTransport (after spectral foundation).
- Root: Integral/{SeparationWeights,SeparationPolynomial}; Separation/{Basic,BranchTagging};
  Determinant/{Basis,Bounds,Filtration}; Sector/{Branches,Degeneration}.
- omega_constructions: Integral/{MonicQuotient,ResidueBasis,FiniteFieldLift,ConvolutionRank,RestrictionDescent} too.

Final integration assignments:
- ring_statement: AllRings, FinalAudit, OAI entrypoint.
- ring_spectrum: ComparatorAudit, verification/comparator, verification scripts; read-only adversarial separation audit.
- omega_constructions: paper source, build script, PDF and paper README.
- Root: Integral/{SeparationDescent,FiniteSeparation}, main README, final verification orchestration and Git.

Publication preparation (after PR #1 merge):
- ring_spectrum: formalization.yaml, .github/workflows/palomar-preflight.yml, docs/PALOMAR.md.
- omega_constructions: .zenodo.json, CITATION.cff, docs/ZENODO.md.
- Root: main README, status, validation, release archive, Git and external actions.
- check_reply_direction: read-only metadata and release review.
Proof, frozen specification and paper are unchanged during this metadata task.
