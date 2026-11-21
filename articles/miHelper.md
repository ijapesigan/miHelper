# miHelper: Helper Functions to Combine Multiparameter Multiple Imputation Estimates

## Description

Helper functions to combine multiparameter multiple imputation estimates
in R (R Core Team, 2026): a multivariate version of Rubin’s rules
(Rubin, 1987) and the adjustment proposed by Li et al. (1991). Models
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

## Example

\
[`library`](https://rdrr.io/r/base/library.html)`(``package ``=`` ``"miHelper"``)`\
`fit`` ``<-`` ``stats``::`[`lm`](https://rdrr.io/r/stats/lm.html)`(`\
`  formula ``=`` ``Temp`` ``~`` ``.``,`\
`  data ``=`` ``datasets``::`[`airquality`](https://rdrr.io/r/datasets/airquality.html)\
`)`\
`M`` ``<-`` ``5`

Fit the model on each imputed data set and combine the estimates. The
data sets are imputed with `mice` (`fun = "mice"`), `Amelia`
(`fun = "amelia"`), or `norm2` (`fun = "mcmcNorm"`).

\
[`set.seed`](https://rdrr.io/r/base/Random.html)`(``seed ``=`` ``42``)`\
`mifit`` ``<-`` `[`MIFit`](https://ijapesigan.github.io/miHelper/reference/MIFit.md)`(`\
`  x ``=`` ``datasets``::`[`airquality`](https://rdrr.io/r/datasets/airquality.html)`,`\
`  fit ``=`` ``fit``,`\
`  fun ``=`` ``"mice"``,`\
`  M ``=`` ``M`\
`)`\
[`MICombine`](https://ijapesigan.github.io/miHelper/reference/MICombine.md)`(``object ``=`` ``mifit``)``$``est`\
`#> (Intercept)       Ozone     Solar.R        Wind       Month         Day `\
`#> 58.65631109  0.15818814  0.01015689 -0.27512146  2.12400831 -0.08638201`

Use the adjustment of Li, Raghunathan, and Rubin (1991).

\
[`MICombine`](https://ijapesigan.github.io/miHelper/reference/MICombine.md)`(`\
`  object ``=`` ``mifit``,`\
`  adj ``=`` ``TRUE`\
`)``$``total_adj`\
`#>              (Intercept)         Ozone       Solar.R          Wind`\
`#> (Intercept) 15.467881214 -2.449691e-02 -6.395809e-03 -0.4277602967`\
`#> Ozone       -0.024496906  4.565797e-04 -4.769669e-05  0.0021167361`\
`#> Solar.R     -0.006395809 -4.769669e-05  3.967331e-05 -0.0001614201`\
`#> Wind        -0.427760297  2.116736e-03 -1.614201e-04  0.0330784889`\
`#> Month       -1.093799471 -9.379750e-04  2.461951e-04  0.0061931100`\
`#> Day         -0.067640752 -9.555539e-06  5.542167e-05 -0.0001924534`\
`#>                     Month           Day`\
`#> (Intercept) -1.0937994708 -6.764075e-02`\
`#> Ozone       -0.0009379750 -9.555539e-06`\
`#> Solar.R      0.0002461951  5.542167e-05`\
`#> Wind         0.0061931100 -1.924534e-04`\
`#> Month        0.1458769345  3.157421e-04`\
`#> Day          0.0003157421  3.632316e-03`

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
John Wiley & Sons, Inc. <https://doi.org/10.1002/9780470316696>
