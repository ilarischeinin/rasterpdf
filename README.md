# rasterpdf

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
![CRAN status](https://www.r-pkg.org/badges/version/rasterpdf)
[![Travis build status](https://travis-ci.org/ilarischeinin/rasterpdf.svg?branch=master)](https://travis-ci.org/ilarischeinin/rasterpdf)
[![Codecov test coverage](https://codecov.io/gh/ilarischeinin/rasterpdf/branch/master/graph/badge.svg)](https://codecov.io/gh/ilarischeinin/rasterpdf?branch=master)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

`rasterpdf` is an R package to plot raster graphics in PDF files. This can be
useful when one needs multipage documents, but the plots contain so many
individual elements that use of vector graphics (with `grDevices::pdf()`)
results in inconveniently large file sizes. Internally, `rasterpdf` plots each
individual page as a PNG, and then combines them in one PDF file.

## Installation

`rasterpdf` is not on CRAN, but can be installed from GitHub with:

```r
devtools::install_github("ilarischeinin/rasterpdf")
```

## Usage

`rasterpdf`'s main function `raster_pdf()` can be used as any graphics device
in R:

```r
library(rasterpdf)

raster_pdf("Rplots.pdf")
plot(iris)
image(volcano)
plot(EuStockMarkets)
dev.off()
```

Or similarly with `ggplot2`:

```r
library(ggplot2)
library(rasterpdf)

raster_pdf("diamonds.pdf")
ggplot(diamonds, aes(carat, price)) + geom_point()
ggplot(diamonds, aes(carat, price, colour = color)) + geom_point()
ggplot(diamonds, aes(carat, price, colour = clarity)) + geom_point()
dev.off()
```

The output size and resolution can be set with parameters `width`, `height`,
`units`, and `res`. The default is 7 x 7 inches and 72 ppi. Any other
parameters (`...`) are passed through to the PNG device function. By default
this is `grDevices::png()`, but another function can also be specified, such
`ragg::agg_png()`. The PDF file is by default generated with
`grDevices::cairo_pdf()` if cairo is available, and `grDevices::pdf()`
otherwise. Here again it is also possible to specify another function.
