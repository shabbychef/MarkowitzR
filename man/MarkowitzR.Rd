\docType{package}
\name{MarkowitzR}
\alias{MarkowitzR}
\alias{MarkowitzR-package}
\title{statistics concerning the Markowitz portfolio}
\description{
Inference on the Markowitz portfolio.
}
\section{Sharpe Ratio}{
  Suppose \eqn{x_i}{xi} are \eqn{n} independent draws of a
  normal random variable with mean \eqn{\mu}{mu} and
  variance \eqn{\sigma^2}{sigma^2}. Let \eqn{\bar{x}}{xbar}
  be the sample mean, and \eqn{s} be the sample standard
  deviation (using Bessel's correction). Let \eqn{c_0}{c0}
  be the 'risk free' or 'disastrous rate' of return.  Then
  \deqn{z = \frac{\bar{x} - c_0}{s}}{z = (xbar - c0)/s} is
  the (sample) Sharpe ratio.

  The units of \eqn{z} are \eqn{\mbox{time}^{-1/2}}{per
  root time}. Typically the Sharpe ratio is
  \emph{annualized} by multiplying by
  \eqn{\sqrt{d}}{sqrt(d)}, where \eqn{d} is the number of
  observations per year (or whatever the target
  annualization epoch.) It is \emph{not} common practice to
  include units when quoting Sharpe ratio, though doing so
  could avoid confusion.

  The Sharpe ratio follows a rescaled non-central t
  distribution. That is, \eqn{z/K} follows a non-central
  t-distribution with \eqn{m} degrees of freedom and
  non-centrality parameter \eqn{\zeta / K}, for some
  \eqn{K}, \eqn{m} and \eqn{\zeta}{zeta}.

  We can generalize Sharpe's model to APT, wherein we write
  \deqn{x_i = \alpha + \sum_j \beta_j F_{j,i} +
  \epsilon_i,}{ x_i = alpha + sum_j beta_j F_j,i +
  epsilon_i,} where the \eqn{F_{j,i}} are observed 'factor
  returns', and the variance of the noise term is
  \eqn{\sigma^2}{sigma^2}. Via linear regression, one can
  compute estimates \eqn{\hat{\alpha}}{alpha}, and
  \eqn{\hat{\sigma}}{sigma}, and then let the 'Sharpe
  ratio' be \deqn{z = \frac{\hat{\alpha} -
  c_0}{\hat{\sigma}}.}{z = (alpha - c0)/sigma.} As above,
  this Sharpe ratio follows a rescaled t-distribution under
  normality, \emph{etc.}

  The parameters are encoded as follows: \itemize{ \item
  \code{df} stands for the degrees of freedom, typically
  \eqn{n-1}, but \eqn{n-J-1} in general. \item
  \eqn{\zeta}{zeta} is denoted by \code{zeta}. \item
  \eqn{d} is denoted by \code{ope}. ('Observations Per
  Year') \item For the APT form of Sharpe, \code{K} stands
  for the rescaling parameter. }
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
}
\keyword{This}
\keyword{a}
\keyword{as}
\keyword{hobby.}
\keyword{is}
\keyword{maintained}
\keyword{package}

