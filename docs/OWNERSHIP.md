# Ownership

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
