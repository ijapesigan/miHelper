// -----------------------------------------------------------------------------
// edit .setup/cpp/000-forward-declarations.cpp
// Ivan Jacob Agaloos Pesigan
// -----------------------------------------------------------------------------

#include <RcppArmadillo.h>

Rcpp::List EStepNorm(const arma::mat& x, const arma::vec& mu,
                     const arma::mat& sigma, const arma::umat& obs,
                     const Rcpp::List& rows);

arma::mat IStepNorm(const arma::mat& x, const arma::vec& mu,
                    const arma::mat& sigma, const arma::umat& obs,
                    const Rcpp::List& rows);

Rcpp::List PStepNorm(const arma::mat& y, const double ridge_df,
                     const arma::vec& ridge_diag);
