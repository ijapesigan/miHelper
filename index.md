# miHelper

Ivan Jacob Agaloos Pesigan

## Description

Helper functions to combine multiparameter multiple imputation estimates
in R (R Core Team, 2026): a multivariate version of Rubin’s rules
(Rubin, 1987) and the adjustment proposed by Li et al. (1991). Models
are fitted on the imputed data sets from `mice`, `Amelia`, or `norm2`
([`MIFit()`](https://ijapesigan.github.io/miHelper/reference/MIFit.md))
and pooled with
[`MICombine()`](https://ijapesigan.github.io/miHelper/reference/MICombine.md).

## Installation

You can install the development version of `miHelper` from
[GitHub](https://github.com/ijapesigan/miHelper) with:

\
`if`` ``(``!`[`require`](https://rdrr.io/r/base/library.html)`(`[`"pak"`](https://pak.r-lib.org/)`)``)`` `[`install.packages`](https://rdrr.io/r/utils/install.packages.html)`(``"pak"``)`\
`pak``::`[`pkg_install`](https://pak.r-lib.org/reference/pkg_install.html)`(``"ijapesigan/miHelper"``)`

## More Information

See [GitHub Pages](https://ijapesigan.github.io/miHelper) for package
documentation.

## References

Li, K. H., Raghunathan, T. E., & Rubin, D. B. (1991). Large-sample
significance levels from multiply imputed data using moment-based
statistics and an F reference distribution. *Journal of the American
Statistical Association*, *86*(416), 1065–1073.
<https://doi.org/10.1080/01621459.1991.10475152>

R Core Team. (2026). *R: A language and environment for statistical
computing*. R Foundation for Statistical Computing.
<https://www.R-project.org/>

Rubin, D. B. (1987). *Multiple imputation for nonresponse in surveys*.
John Wiley & Sons, Inc. <https://doi.org/10.1002/9780470316696>
