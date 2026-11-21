# Combine Multiple Imputation Estimates and Sampling Covariance Matrix

Combine Multiple Imputation Estimates and Sampling Covariance Matrix

## Usage

``` r
MICombine(object, adj = FALSE)
```

## Arguments

- object:

  Object of class `mifit`, that is, the output of the
  [`MIFit()`](https://ijapesigan.github.io/miHelper/reference/MIFit.md)
  function.

- adj:

  Logical. If `adj = TRUE`, use Li, Raghunathan, and Rubin (1991)
  adjustment.

## Value

Returns a list with the following elements:

- `M`:

  Number of imputations \\(M\\).

- `est`:

  Vector of pooled coefficients/parameter estimates
  \\(\bar{\boldsymbol{\theta}}\\).

- `within`:

  Covariance within imputations \\(\boldsymbol{V}\_{\mathrm{within}}\\).

- `between`:

  Covariance between imputations
  \\(\boldsymbol{V}\_{\mathrm{between}}\\).

- `total`:

  Total covariance matrix \\(\boldsymbol{V}\_{\mathrm{total}}\\).

- `ariv`:

  Average relative increase in variance (`NA` if `adj = FALSE`).

- `total_adj`:

  Adjusted total covariance matrix
  \\(\tilde{\boldsymbol{V}}\_{\mathrm{total}}\\) (`NA` if
  `adj = FALSE`).

## Details

The pooled vector of parameter estimates is given by \$\$
\bar{\boldsymbol{\theta}} = M^{-1} \sum\_{m = 1}^{M}
\hat{\boldsymbol{\theta}}\_{m} \$\$ where \\(M\\) is the number of
imputations, \\(m = \left\\{ 1, 2, \cdots, M \right\\}\\), and
\\(\hat{\boldsymbol{\theta}}\_{m}\\) is the vector of parameter
estimates for the \\(m^{\mathrm{th}}\\) imputation.

The pooled or total sampling variance-covariance matrix consists of
combining between and within imputation variances given by \$\$
\boldsymbol{V}\_{\mathrm{within}} = M^{-1} \sum\_{m = 1}^{M}
\operatorname{Var} \left( \hat{\boldsymbol{\theta}}\_{m} \right) \$\$

\$\$ \boldsymbol{V}\_{\mathrm{between}} = \left( M - 1 \right)^{-1}
\sum\_{m = 1}^{M} \left( \hat{\boldsymbol{\theta}}\_{m} -
\bar{\boldsymbol{\theta}} \right) \left(
\hat{\boldsymbol{\theta}}\_{m} - \bar{\boldsymbol{\theta}}
\right)^{\prime} \$\$

\$\$ \boldsymbol{V}\_{\mathrm{total}} =
\boldsymbol{V}\_{\mathrm{within}} + \boldsymbol{V}\_{\mathrm{between}} +
M^{-1} \boldsymbol{V}\_{\mathrm{between}} . \$\$

An alternative total variance was introduced by Li, Raghunathan, and
Rubin (1991) and is given by \$\$
\tilde{\boldsymbol{V}}\_{\mathrm{total}} = \left( 1 +
\operatorname{ARIV} \right) \boldsymbol{V}\_{\mathrm{within}} \$\$ where
\\(\operatorname{ARIV}\\) is given by \$\$ \operatorname{ARIV} = \frac{
\left( 1 + M^{-1} \right) \operatorname{tr} \left(
\boldsymbol{V}\_{\mathrm{between}}
\boldsymbol{V}\_{\mathrm{within}}^{-1} \right) }{ k } . \$\$

## References

Li, K. H., Raghunathan, T. E., & Rubin, D. B. (1991). Large-sample
significance levels from multiply imputed data using moment-based
statistics and an F reference distribution. *Journal of the American
Statistical Association*, 86 (416), 1065–1073.
[doi:10.1080/01621459.1991.10475152](https://doi.org/10.1080/01621459.1991.10475152)

Rubin, D. B. (1987). *Multiple imputation for nonresponse in surveys*.
John Wiley & Sons, Inc.
[doi:10.1002/9780470316696](https://doi.org/10.1002/9780470316696)

## See also

Other Multiple Imputation Helper Functions:
[`MI2List()`](https://ijapesigan.github.io/miHelper/reference/MI2List.md),
[`MIFit()`](https://ijapesigan.github.io/miHelper/reference/MIFit.md)

## Author

Ivan Jacob Agaloos Pesigan

## Examples

``` r
fit <- lm(Temp ~ ., data = airquality)
set.seed(42)
mifit <- MIFit(
  x = airquality,
  fit = fit,
  fun = "mice",
  M = 3
)
MICombine(mifit)
#> $M
#> [1] 3
#> 
#> $est
#>  (Intercept)        Ozone      Solar.R         Wind        Month          Day 
#> 58.193572686  0.156900555  0.009134043 -0.269963853  2.228686250 -0.101110270 
#> 
#> $within
#>              (Intercept)         Ozone       Solar.R          Wind
#> (Intercept) 14.289107122 -2.268461e-02 -5.810969e-03 -0.3921696288
#> Ozone       -0.022684607  3.935376e-04 -4.331274e-05  0.0018969278
#> Solar.R     -0.005810969 -4.331274e-05  3.723871e-05 -0.0001745757
#> Wind        -0.392169629  1.896928e-03 -1.745757e-04  0.0304373682
#> Month       -1.019199262 -5.967721e-04  2.210235e-04  0.0067148983
#> Day         -0.060346682 -4.677929e-05  5.799876e-05 -0.0003938111
#>                     Month           Day
#> (Intercept) -1.0191992620 -6.034668e-02
#> Ozone       -0.0005967721 -4.677929e-05
#> Solar.R      0.0002210235  5.799876e-05
#> Wind         0.0067148983 -3.938111e-04
#> Month        0.1331014165  3.603209e-04
#> Day          0.0003603209  3.351515e-03
#> 
#> $between
#>              (Intercept)         Ozone       Solar.R          Wind        Month
#> (Intercept)  1.800517075 -2.196816e-02  2.916518e-03 -0.1289045028 -0.087545264
#> Ozone       -0.021968157  2.945288e-04 -4.382326e-05  0.0015858748  0.001078524
#> Solar.R      0.002916518 -4.382326e-05  7.286143e-06 -0.0002128783 -0.000145036
#> Wind        -0.128904503  1.585875e-03 -2.128783e-04  0.0092351507  0.006272768
#> Month       -0.087545264  1.078524e-03 -1.450360e-04  0.0062727682  0.004260719
#> Day          0.040051354 -4.927322e-04  6.613998e-05 -0.0028694093 -0.001948981
#>                       Day
#> (Intercept)  4.005135e-02
#> Ozone       -4.927322e-04
#> Solar.R      6.613998e-05
#> Wind        -2.869409e-03
#> Month       -1.948981e-03
#> Day          8.915404e-04
#> 
#> $total
#>              (Intercept)         Ozone       Solar.R          Wind
#> (Intercept) 16.689796556 -0.0519754837 -1.922278e-03 -0.5640422991
#> Ozone       -0.051975484  0.0007862427 -1.017437e-04  0.0040114276
#> Solar.R     -0.001922278 -0.0001017437  4.695356e-05 -0.0004584134
#> Wind        -0.564042299  0.0040114276 -4.584134e-04  0.0427509024
#> Month       -1.135926280  0.0008412596  2.764213e-05  0.0150785892
#> Day         -0.006944877 -0.0007037556  1.461854e-04 -0.0042196902
#>                     Month           Day
#> (Intercept) -1.135926e+00 -0.0069448767
#> Ozone        8.412596e-04 -0.0007037556
#> Solar.R      2.764213e-05  0.0001461854
#> Wind         1.507859e-02 -0.0042196902
#> Month        1.387824e-01 -0.0022383208
#> Day         -2.238321e-03  0.0045402353
#> 
#> $ariv
#> [1] NA
#> 
#> $total_adj
#> [1] NA
#> 
MICombine(mifit, adj = TRUE)
#> $M
#> [1] 3
#> 
#> $est
#>  (Intercept)        Ozone      Solar.R         Wind        Month          Day 
#> 58.193572686  0.156900555  0.009134043 -0.269963853  2.228686250 -0.101110270 
#> 
#> $within
#>              (Intercept)         Ozone       Solar.R          Wind
#> (Intercept) 14.289107122 -2.268461e-02 -5.810969e-03 -0.3921696288
#> Ozone       -0.022684607  3.935376e-04 -4.331274e-05  0.0018969278
#> Solar.R     -0.005810969 -4.331274e-05  3.723871e-05 -0.0001745757
#> Wind        -0.392169629  1.896928e-03 -1.745757e-04  0.0304373682
#> Month       -1.019199262 -5.967721e-04  2.210235e-04  0.0067148983
#> Day         -0.060346682 -4.677929e-05  5.799876e-05 -0.0003938111
#>                     Month           Day
#> (Intercept) -1.0191992620 -6.034668e-02
#> Ozone       -0.0005967721 -4.677929e-05
#> Solar.R      0.0002210235  5.799876e-05
#> Wind         0.0067148983 -3.938111e-04
#> Month        0.1331014165  3.603209e-04
#> Day          0.0003603209  3.351515e-03
#> 
#> $between
#>              (Intercept)         Ozone       Solar.R          Wind        Month
#> (Intercept)  1.800517075 -2.196816e-02  2.916518e-03 -0.1289045028 -0.087545264
#> Ozone       -0.021968157  2.945288e-04 -4.382326e-05  0.0015858748  0.001078524
#> Solar.R      0.002916518 -4.382326e-05  7.286143e-06 -0.0002128783 -0.000145036
#> Wind        -0.128904503  1.585875e-03 -2.128783e-04  0.0092351507  0.006272768
#> Month       -0.087545264  1.078524e-03 -1.450360e-04  0.0062727682  0.004260719
#> Day          0.040051354 -4.927322e-04  6.613998e-05 -0.0028694093 -0.001948981
#>                       Day
#> (Intercept)  4.005135e-02
#> Ozone       -4.927322e-04
#> Solar.R      6.613998e-05
#> Wind        -2.869409e-03
#> Month       -1.948981e-03
#> Day          8.915404e-04
#> 
#> $total
#>              (Intercept)         Ozone       Solar.R          Wind
#> (Intercept) 16.689796556 -0.0519754837 -1.922278e-03 -0.5640422991
#> Ozone       -0.051975484  0.0007862427 -1.017437e-04  0.0040114276
#> Solar.R     -0.001922278 -0.0001017437  4.695356e-05 -0.0004584134
#> Wind        -0.564042299  0.0040114276 -4.584134e-04  0.0427509024
#> Month       -1.135926280  0.0008412596  2.764213e-05  0.0150785892
#> Day         -0.006944877 -0.0007037556  1.461854e-04 -0.0042196902
#>                     Month           Day
#> (Intercept) -1.135926e+00 -0.0069448767
#> Ozone        8.412596e-04 -0.0007037556
#> Solar.R      2.764213e-05  0.0001461854
#> Wind         1.507859e-02 -0.0042196902
#> Month        1.387824e-01 -0.0022383208
#> Day         -2.238321e-03  0.0045402353
#> 
#> $ariv
#> [1] 0.25886
#> 
#> $total_adj
#>              (Intercept)         Ozone       Solar.R          Wind
#> (Intercept) 17.987984946 -2.855674e-02 -7.315196e-03 -0.4936866467
#> Ozone       -0.028556744  4.954087e-04 -5.452468e-05  0.0023879664
#> Solar.R     -0.007315196 -5.452468e-05  4.687832e-05 -0.0002197664
#> Wind        -0.493686647  2.387966e-03 -2.197664e-04  0.0383163844
#> Month       -1.283029151 -7.512526e-04  2.782376e-04  0.0084531167
#> Day         -0.075968023 -5.888857e-05  7.301231e-05 -0.0004957531
#>                     Month           Day
#> (Intercept) -1.2830291512 -7.596802e-02
#> Ozone       -0.0007512526 -5.888857e-05
#> Solar.R      0.0002782376  7.301231e-05
#> Wind         0.0084531167 -4.957531e-04
#> Month        0.1675560450  4.535935e-04
#> Day          0.0004535935  4.219088e-03
#> 
```
