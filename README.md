


# MarkowitzR

A number of utilities for dealing with the Markowitz portfolio.

-- Steven E. Pav, shabbychef@gmail.com

## Installation

This package may be installed from CRAN; the latest version may be
found on [github](https://www.github.com/shabbychef/MarkowitzR "MarkowitzR")
via devtools:


```r
if (require(devtools)) {
    # latest greatest
    install_github(repo = "MarkowitzR", username = "shabbychef", 
        ref = "master")
}
```


# Basic Usage

## Inference on the Markowitz Portfolio

The (negative) Markowitz portfolio appears in the inverse of
the uncentered second moment matrix of the 'augmented' vector
of returns. Via the Central Limit Theorem and the delta method
the asymptotic distribution of the Markowitz portfolio can
be found. From this, Wald statistics on the individual portfolio
weights can be computed. 

Some example usage:


```r
set.seed(1001)
X <- matrix(rnorm(1000 * 3), ncol = 3)
ism <- marko_vcov(X, fit.intercept = TRUE)
walds <- ism$W/sqrt(diag(ism$What))
print(t(walds))
```

```
##             X1    X2   X3
## Intercept 0.83 -0.15 -1.8
```

```r

set.seed(1001)
Feat <- matrix(rnorm(1000 * 2), ncol = 2)
Btrue <- 0.1 * matrix(rnorm(2 * 4), nrow = 2)
Xmean <- Feat %*% Btrue
Strue <- cov(matrix(rnorm(100 * 4), ncol = 4))
Shalf <- chol(Strue)
X <- Xmean + matrix(rnorm(prod(dim(Xmean))), ncol = dim(Xmean)[2]) %*% 
    Shalf
ism <- marko_vcov(X, feat = Feat, fit.intercept = TRUE)
walds <- ism$W/sqrt(diag(ism$What))
print(t(walds))
```

```
##              X1      X2    X3    X4
## Intercept -0.34 -0.0074  0.45  0.33
## Feat1     -0.95  2.5674  2.18  3.72
## Feat2      5.64 -1.9175 -1.77 -6.18
```

```r
# results are not much changed when using robust
# s.e.
require(sandwich)

ism <- marko_vcov(X, feat = Feat, vcov.func = sandwich::vcovHAC, 
    fit.intercept = TRUE)
walds <- ism$W/sqrt(diag(ism$What))
print(t(walds))
```

```
##              X1      X2    X3    X4
## Intercept -0.34 -0.0073  0.43  0.34
## Feat1     -0.95  2.5766  2.16  3.67
## Feat2      5.56 -1.8861 -1.74 -6.11
```



```r
# generate data with given W, Sigma
Xgen <- function(W, Sigma, Feat) {
    Btrue <- Sigma %*% W
    Xmean <- Feat %*% t(Btrue)
    Shalf <- chol(Sigma)
    X <- Xmean + matrix(rnorm(prod(dim(Xmean))), ncol = dim(Xmean)[2]) %*% 
        Shalf
}

n.feat <- 3
n.ret <- 10
n.obs <- 1000
set.seed(101)
Feat <- matrix(rnorm(n.obs * n.feat), ncol = n.feat)
Wtrue <- 10 * matrix(rnorm(n.feat * n.ret), ncol = n.feat)
Sigma <- cov(matrix(rnorm(100 * n.ret), ncol = n.ret))
Sigma <- Sigma + diag(seq(from = 1, to = 3, length.out = n.ret))
X <- Xgen(Wtrue, Sigma, Feat)
ism <- marko_vcov(X, feat = Feat, fit.intercept = TRUE)
Wcomp <- cbind(0, Wtrue)
errs <- ism$W - Wcomp
dim(errs) <- c(length(errs), 1)
Zerr <- solve(t(chol(ism$What)), errs)
qqnorm(Zerr)
```

![plot of chunk marko_plot](figure/marko_plot.pdf) 

