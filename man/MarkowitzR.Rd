\docType{package}
\name{MarkowitzR}
\alias{MarkowitzR}
\alias{MarkowitzR-package}
\title{statistics concerning the Markowitz portfolio}
\description{
Inference on the Markowitz portfolio.
}
\section{Markowitz Portfolio}{
  Suppose \eqn{x} is a \eqn{p}-vector of returns of some
  assets with expected value \eqn{\mu}{mu} and covariance
  \eqn{\Sigma}{Sigma}. The \emph{Markowitz Portfolio} is
  the portfolio \eqn{w = \Sigma^{-1}\mu}{w = Sigma^-1 mu}.
  Scale multiples of this portfolio solve various portfolio
  optimization problems, among them
  \deqn{\operatorname{argmax}_{w: w^{\top}\Sigma w \le R^2}
  \frac{\mu^{\top} w - r_0}{\sqrt{w^{\top}\Sigma
  w}}}{argmax{ (mu'w - r0) / sqrt(w'Sigma w) : w'Sigma w <=
  R^2}}

  This packages supports various statistical tests around
  the elements of the Markowitz Portfolio, and its Sharpe
  ratio, including the possibility of hedging, and scalar
  conditional heteroskedasticity and conditional
  expectation.
}

\section{Legal Mumbo Jumbo}{
  MarkowitzR is distributed in the hope that it will be
  useful, but WITHOUT ANY WARRANTY; without even the
  implied warranty of MERCHANTABILITY or FITNESS FOR A
  PARTICULAR PURPOSE.  See the GNU Lesser General Public
  License for more details.
}
\author{
Steven E. Pav \email{shabbychef@gmail.com}
}
\references{
Pav, S. E. "Asymptotic Distribution of the Markowitz
Portfolio." 2013 \url{http://arxiv.org/abs/1312.0557}

Britten-Jones, Mark. "The Sampling Error in Estimates of
Mean-Variance Efficient Portfolio Weights." The Journal of
Finance 54, no. 2 (1999): 655--671.
\url{http://www.jstor.org/stable/2697722}

Bodnar, Taras and Okhrin, Yarema. "On the Product of
Inverse Wishart and Normal Distributions with Applications
to Discriminant Analysis and Portfolio Theory."
Scandinavian Journal of Statistics 38, no. 2 (2011):
311--331.
\url{http://dx.doi.org/10.1111/j.1467-9469.2011.00729.x}

Markowitz, Harry. "Portfolio Selection." The Journal of
Finance 7, no. 1 (1952): 77--91.
\url{http://www.jstor.org/stable/2975974}

Brandt, Michael W. "Portfolio Choice Problems." Handbook of
Financial Econometrics 1 (2009): 269--336.
\url{http://shr.receptidocs.ru/docs/5/4748/conv_1/file1.pdf#page=298}
}
\keyword{This}
\keyword{a}
\keyword{as}
\keyword{hobby.}
\keyword{is}
\keyword{maintained}
\keyword{package}

