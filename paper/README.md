# Manuscript

The source and PDF describe the integral extension of OpenAI's 9/4 proof and
its consequence for associative unital rings. Both the manuscript and the
new Lean proof development are AI-generated with Codex under human direction.
OpenAI's original result and the prior all-fields extension are explicitly
credited in the paper. There is no author byline or document date; the source
and PDF are associated with their repository commit.

**Current status:** the complete AllRings entry point compiled in queue request
2aa7a8, including the integer rank bound, arbitrary-ring exponent theorem, and
explicit operation-count corollary. Transport axioms are clean. Final axiom
audits, fresh-kernel replay, and Comparator checks remain pending. The PDF
distinguishes these checks and does not claim peer review.

- [PDF](paper.pdf)
- [LaTeX source](paper.tex)

For a repository PDF build using the existing TeX installation:

```sh
bash paper/build.sh
```

The source is a standalone LaTeX document, also supported by Codex's built-in
editor/compiler. The build script places intermediate files in
`tmp/paper-build/` and writes `paper/paper.pdf`. It omits PDF creation/modification
dates, author metadata, and the trailer ID. `SOURCE_DATE_EPOCH` defaults to the
current repository commit timestamp. Dependencies are a standard pdfLaTeX
installation with amsmath, amsthm, mathtools, geometry, microtype, lmodern, and
hyperref. No TeX tools were installed for this task.

For visual review, render the PDF with `pdftoppm` and inspect every page. Keep
rendered pages and build logs out of version control. The compiled PDF should
be committed alongside the source after validation.

## PDF checks

The six-page PDF was compiled successfully both by the desktop editor and by
`paper/build.sh`, rendered with Poppler, and every page visually inspected.
The final TeX log has no overfull/underfull boxes or unresolved references.
`pdfinfo` confirms an empty Author field and no creation/modification dates.
The mathematical wording in the spectral and Fourier sections was separately
reviewed against the corresponding Lean modules. OpenAI's title, finite
separation proposition (3.1), and detecting-character appendix (A) were checked
against the pinned upstream manuscript source.
