\name{marko_vcov}
\alias{marko_vcov}
\alias{theta_vcov}
\title{Estimate Markowitz Portfolio}
\usage{
marko_vcov(X,feat=null,vcov.func=vcov,fit.intercept=TRUE,weights=null,Jmat=null,Gmat=null)

theta_vcov(X,vcov.func=vcov,fit.intercept=TRUE)
}
\arguments{
  \item{X}{an \eqn{n \times p}{n x p} matrix of observed
  returns.}

  \item{feat}{an \eqn{n \times f}{n x f} matrix of observed
  features. defaults to none, in which case
  \code{fit.intercept} must be \code{TRUE}. If
  \code{fit.intercept} is true, ones will be prepended to
  the features.}

  \item{weights}{an optional \eqn{n} vector of the weights.
  The returns and features will be multiplied by the
  weights. Weights should be inverse volatility estimates.
  Defaults to homoskedasticity.}

  \item{Jmat}{an optional \eqn{p_j \times p}{pj x p} matrix
  of the subspace in which we constraint portfolios.
  Defaults essentially to the \eqn{p \times p}{p x p}
  identity matrix.}

  \item{Gmat}{an optional \eqn{p_g \times p}{pg x p} matrix
  of the subspace to which we constraint portfolios to have
  zero covariance. The rowspace of \code{Gmat} must be
  spanned by the rowspace of \code{Jmat}. Defaults
  essentially to the \eqn{0 \times p}{0 x p} empty matrix.}

  \item{X}{an \eqn{n \times p}{n x p} matrix of observed
  returns.}

  \item{vcov.func}{a function which takes an object of
  class \code{lm}, and computes a variance-covariance
  matrix. If equal to the string \code{"normal"}, we assume
  multivariate normal returns.}

  \item{fit.intercept}{a boolean controlling whether we add
  a column of ones to the data, or fit the raw uncentered
  second moment. For now, must be true when assuming normal
  returns.}
}
\value{
a list containing the following components:
\item{mu}{Letting \eqn{r = f + p + fit.intercept}, this is
a \eqn{q = (r)(r+1)/2} vector...} \item{Ohat}{the \eqn{q
\times q}{q x q} estimated variance covariance matrix of
\code{mu}.} \item{W}{The estimated Markowitz coefficient, a
\eqn{(f+fit.intercept) \times p}{(f+fit.intercept) x p}
matrix.} \item{What}{the estimated variance covariance
matrix of \code{vech(W)}.} \item{n}{the number of rows in
\code{X}.} \item{ff}{the number of features plus
\code{as.numeric(fit.intercept)}.} \item{p}{the number of
assets.}

a list containing the following components: \item{mu}{a
\eqn{q = (p+1)(p+2)/2} vector of 1, then the mean, then the
vech'd second moment of the sample data} \item{Ohat}{the
\eqn{q \times q}{q x q} estimated variance covariance
matrix. When \code{fit.intercept} is true, the left column
and top row are all zeros.} \item{n}{the number of rows in
\code{X}.} \item{pp}{the number of assets plus
\code{as.numeric(fit.intercept)}.}
}
\description{
Estimates the Markowitz Portfolio or Markowitz Coefficient
subject to subspace and hedging constraints, and
heteroskedasticity.

Computes the variance covariance matrix of sample mean and
second moment.
}
\details{
Suppose that the expectation of \eqn{p}-vector \eqn{x} is
linear in the \eqn{f}-vector \eqn{f}, but the covariance of
\eqn{x} is stationary and independent of \eqn{f}. The
'Markowitz Coefficient' is the \eqn{p \times f}{p x f}
matrix \eqn{W} such that, conditional on observing \eqn{f},
the portfolio \eqn{Wf} maximizes Sharpe. When \eqn{f} is
the constant 1, the Markowitz Coefficient is the
traditional Markowitz Portfolio.

Given \eqn{n} observations of the returns and features,
given as matrices \eqn{X, F}, this code computes the
Markowitz Coefficient along with the variance-covariance
matrix of the Coefficient and the precision matrix.  One
may give optional weights, which are inverse conditional
volatility. One may also give optional matrix \eqn{J, G}
which define subspace and hedging constraints. Briefly,
they constrain the portfolio optimization problem to
portfolios in the row space of \eqn{J} and with zero
covariance with the rows of \eqn{G}. It must be the case
that the rows of \eqn{J} span the rows of \eqn{G}. \eqn{J}
defaults to the \eqn{p \times p}{p x p} identity matrix,
and \eqn{G} defaults to a null matrix.

One may use the default method for computing covariance,
via the \code{\link{vcov}} function, or via a 'fancy'
estimator, like \code{sandwich:vcovHAC},
\code{sandwich:vcovHC}, \emph{etc.}

Given \eqn{p}-vector \eqn{x}, the 'unified' sample is the
\eqn{(p+1)(p+2)/2} vector of 1, \eqn{x}, and
\eqn{\mbox{vech}(x x^{\top})}{vech(x x')} stacked on top of
each other. Given \eqn{n} contemporaneous observations of
\eqn{p}-vectors, stacked as rows in the \eqn{n \times p}{n
x p} matrix \eqn{X}, this function computes the mean and
the variance-covariance matrix of the 'unified' sample.

One may use the default method for computing covariance,
via the \code{\link{vcov}} function, or via a 'fancy'
estimator, like \code{sandwich:vcovHAC},
\code{sandwich:vcovHC}, \emph{etc.}
}
\note{
Replaces similar functionality from SharpeR package, but
with modified API.
}
\examples{
X <- matrix(rnorm(1000*3),ncol=3)
ism <- marko_vcov(X,fit.intercept=TRUE)
walds <- ism$W / sqrt(diag(ism$What))
X <- matrix(rnorm(1000*3),ncol=3)
Sigmas <- theta_vcov(X)
Sigmas.n <- theta_vcov(X,vcov.func="normal")
Sigmas.n <- theta_vcov(X,fit.intercept=FALSE)

# make it fat tailed:
X <- matrix(rt(1000*3,df=5),ncol=3)
Sigmas <- theta_vcov(X)
\dontrun{
if (require(sandwich)) {
 Sigmas <- theta_vcov(X,vcov.func=vcovHC)
}
}
# add some autocorrelation to X
Xf <- filter(X,c(0.2),"recursive")
colnames(Xf) <- colnames(X)
Sigmas <- theta_vcov(Xf)
\dontrun{
if (require(sandwich)) {
	Sigmas <- theta_vcov(Xf,vcov.func=vcovHAC)
}
}
}
\author{
Steven E. Pav \email{shabbychef@gmail.com}

Steven E. Pav \email{shabbychef@gmail.com}
}
\references{
Pav, S. E. "Asymptotic Distribution of the Markowitz
Portfolio." 2013 \url{http://arxiv.org/abs/1312.0557}

Pav, S. E. "Asymptotic Distribution of the Markowitz
Portfolio." 2013 \url{http://arxiv.org/abs/1312.0557}
}
\seealso{
\code{\link{itheta_vcov}}, \code{\link{theta_vcov}}

\code{\link{itheta_vcov}}
}
\keyword{univar}

