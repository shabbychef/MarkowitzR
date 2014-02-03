


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
##              X1   X2  X3
## Intercept -0.72 0.16 1.8
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
##              X1    X2    X3    X4
## Intercept  0.31  0.11 -0.55 -0.47
## Feat1      1.26 -1.80 -2.04 -4.11
## Feat2     -5.35  1.60  1.97  6.26
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
##              X1    X2    X3    X4
## Intercept  0.32  0.11 -0.53 -0.48
## Feat1      1.25 -1.77 -2.00 -4.08
## Feat2     -5.28  1.60  1.93  6.19
```

