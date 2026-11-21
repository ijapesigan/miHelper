# miHelper 0.1.0

## New features

- Multiple imputation under the multivariate normal model without `norm2` (archived on CRAN 2023-08-25):
  EM (`.EMNorm()`) and data augmentation (`.MCMCNorm()`, `.ImpNorm()`) after Schafer (1997), with the E-step,
  I-step, and P-step in C++ (`.EStepNorm()`, `.IStepNorm()`, `.PStepNorm()`), one regression per missing-data pattern.
  Priors: noninformative (default) and ridge (`prior = "ridge"`, `ridge_df`). EM stops at a relative change of 1e-8.
- `MIFit(fun = "mcmcNorm")` uses them: EM once, then one chain of `iter` cycles (default 1000) per imputation.
  `MIFit()` and `MI2List()` still accept `norm` objects made by `norm2`.

## Other changes

- `norm2` is no longer imported. The EM estimates agree with `norm2::emNorm()` to 1e-6
  (`.setup/tests-external/test-external-miHelper-em-norm.R`, run by hand where `norm2` is installed).

# miHelper 0.0.1

## Major changes

- Move to the rProject template (`.setup/` layout, `DESCRIPTION`, README, vignette, GitHub workflows).
- Every function has complete roxygen documentation and a test file; the tests use named arguments.
- The `enders2010` data set is now processed from `.setup/data-raw/enders2010.txt` by `.setup/data-process/data-process-enders2010.R` and documented in `R/miHelper-enders2010.R`.

## Minor changes

- The internal functions `.nu2Li()` and `.nu2Reiter()` are renamed `.Nu2Li()` and `.Nu2Reiter()`; the empty stub `.UnivDF()` is removed.
- Fix the roxygen link `[miFit()]` to `[MIFit()]` and add the `1 / k` factor to the documented `ARIV` formula (the code already divided by `k`).
- Fix `.MIFitList()` (used by `MIFit()`): the `data` argument of the fitted model was evaluated before it was replaced, which failed when the data object was not visible from the package's internal frame (for example, `lm(formula, data = d)` with `d` defined by the caller). It is no longer evaluated. Regression test in `test-miHelper-mi-fit-list-dot.R`.

# miHelper 0.0.0.9000

- And so it begins.
