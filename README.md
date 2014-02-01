


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
weights can be computed. Here I perform this computation on the
portfolio consisting of three large cap stocks, and find
that the Markowitz weighting of AAPL is significantly non-zero
(modulo the selection biases in universe construction). The
results are little changed when using a 'robust' covariance
estimator.


```r
some.rets <- get.rets(c("IBM", "AAPL", "XOM"), from = "2004-01-01", 
    to = "2013-08-01")
```

```
## Error: could not find function "get.rets"
```

```r

ism.wald <- function(X, vcov.func = vcov) {
    # negating returns is idiomatic to get + Markowitz
    ism <- ism_vcov(-as.matrix(X), vcov.func = vcov.func)
    ism.mu <- ism$mu[1:ism$p]
    ism.Sg <- ism$Ohat[1:ism$p, 1:ism$p]
    retval <- ism.mu/sqrt(diag(ism.Sg))
    dim(retval) <- c(ism$p, 1)
    rownames(retval) <- rownames(ism$mu)[1:ism$p]
    return(retval)
}

wald.stats <- ism.wald(some.rets)
```

```
## Error: could not find function "ism_vcov"
```

```r
print(t(wald.stats))
```

```
## Error: object 'wald.stats' not found
```

```r

if (require(sandwich)) {
    wald.stats <- ism.wald(some.rets, vcov.func = sandwich::vcovHAC)
    print(t(wald.stats))
}
```

```
## Error: could not find function "ism_vcov"
```

