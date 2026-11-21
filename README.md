miHelper
================
Ivan Jacob Agaloos Pesigan

<!-- README.md is generated from .setup/readme/README.Rmd. Please edit that file -->

<!-- badges: start -->
[![Make Project (make all)](https://github.com/ijapesigan/miHelper/actions/workflows/make-all.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/make-all.yml)
[![Make Project](https://github.com/ijapesigan/miHelper/actions/workflows/make.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/make.yml)
[![R-CMD-check-full](https://github.com/ijapesigan/miHelper/actions/workflows/check-full.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/check-full.yml)
[![R-CMD-check-oldrel](https://github.com/ijapesigan/miHelper/actions/workflows/check-oldrel.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/check-oldrel.yml)
[![R-CMD-check-standard](https://github.com/ijapesigan/miHelper/actions/workflows/check-standard.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/check-standard.yml)
[![Compile LaTeX](https://github.com/ijapesigan/miHelper/actions/workflows/latex.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/latex.yml)
[![Lint R Package](https://github.com/ijapesigan/miHelper/actions/workflows/lint.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/lint.yml)
[![Non-ASCII Check](https://github.com/ijapesigan/miHelper/actions/workflows/non-ascii-check.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/non-ascii-check.yml)
[![Package Website (GitHub Pages)](https://github.com/ijapesigan/miHelper/actions/workflows/pkgdown-gh-pages.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/pkgdown-gh-pages.yml)
[![rhub 1 (essential)](https://github.com/ijapesigan/miHelper/actions/workflows/rhub-1-essential.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/rhub-1-essential.yml)
[![rhub 2 (memory)](https://github.com/ijapesigan/miHelper/actions/workflows/rhub-2-memory.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/rhub-2-memory.yml)
[![rhub 3 (numerics), review only](https://github.com/ijapesigan/miHelper/actions/workflows/rhub-3-numerics.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/rhub-3-numerics.yml)
[![rhub 4 (compilers), review only](https://github.com/ijapesigan/miHelper/actions/workflows/rhub-4-compilers.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/rhub-4-compilers.yml)
[![Shell Check](https://github.com/ijapesigan/miHelper/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/shellcheck.yml)
[![Source Code](https://github.com/ijapesigan/miHelper/actions/workflows/source.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/source.yml)
[![R Package Test Coverage](https://github.com/ijapesigan/miHelper/actions/workflows/test-coverage.yml/badge.svg)](https://github.com/ijapesigan/miHelper/actions/workflows/test-coverage.yml)
<!-- badges: end -->

## Description

Helper functions to combine multiparameter multiple imputation estimates
in R (R Core Team, 2026): a multivariate version of Rubin’s rules
(Rubin, 1987) and the adjustment proposed by Li et al. (1991). Models
are fitted on the imputed data sets from `mice`, `Amelia`, or `norm2`
(`MIFit()`) and pooled with `MICombine()`.

## Installation

You can install the development version of `miHelper` from
[GitHub](https://github.com/ijapesigan/miHelper) with:

``` r
if (!require("pak")) install.packages("pak")
pak::pkg_install("ijapesigan/miHelper")
```

## More Information

See [GitHub Pages](https://ijapesigan.github.io/miHelper) for package
documentation.

## References

<div id="refs" class="references csl-bib-body hanging-indent"
data-entry-spacing="0" data-line-spacing="2">

<div id="ref-Li-Raghunathan-Rubin-1991" class="csl-entry">

Li, K. H., Raghunathan, T. E., & Rubin, D. B. (1991). Large-sample
significance levels from multiply imputed data using moment-based
statistics and an $F$ reference distribution. *Journal of the American
Statistical Association*, *86*(416), 1065–1073.
<https://doi.org/10.1080/01621459.1991.10475152>

</div>

<div id="ref-RCoreTeam-2026" class="csl-entry">

R Core Team. (2026). *R: A language and environment for statistical
computing*. R Foundation for Statistical Computing.
<https://www.R-project.org/>

</div>

<div id="ref-Rubin-1987" class="csl-entry">

Rubin, D. B. (1987). *Multiple imputation for nonresponse in surveys*.
John Wiley & Sons, Inc. <https://doi.org/10.1002/9780470316696>

</div>

</div>
