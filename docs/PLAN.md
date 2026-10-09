# Proof plan

1. Preserve the arithmetic semantics while generalizing to all rings, treating
   the trivial ring separately with its zero-cost program and real-infimum convention.
2. Generalize coefficient rank and restriction semiring to commutative rings.
3. Use the zero-or-1-restricting tensor subsemiring for spectral detection;
   extend its characters to all tensors by chi(T+1)-1 if verified.
4. Prove polynomial coefficient extraction without interpolation, finite free
   descent with fixed degree-squared overhead, and coprime scalar patching.
5. Implement integral Fourier separation via consecutive periods and
   asymptotic convolution interpolation via coprime norm denominators.
6. Port determinant/profile/growth arguments and prove integer exponent ≤9/4.
7. Convert integer bilinear schemes to programs over arbitrary associative
   rings using central integer constants and unchanged input order.
8. Audit full theorem, definitions, dependencies and axioms; Comparator and
   clean kernel replay. Draft paper in parallel but label status honestly.
9. Push private PR for review. No merge without approval for that PR.

Reviewed mathematical input: local research checkpoint7de4777, specifically
round9_integral_descent and its independent audits. Rectangular extensions
are out of the first target's scope.
