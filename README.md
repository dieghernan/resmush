
<!-- README.md is generated from README.Rmd. Please edit that file -->

# resmush <a href="https://dieghernan.github.io/resmush/"><img src="man/figures/logo.png" alt="resmush website" align="right" height="139"/></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/dieghernan/resmush/actions/workflows/check-full.yaml/badge.svg)](https://github.com/dieghernan/resmush/actions/workflows/check-full.yaml)
[![codecov](https://codecov.io/gh/dieghernan/resmush/graph/badge.svg)](https://app.codecov.io/gh/dieghernan/resmush)
[![r-universe](https://dieghernan.r-universe.dev/badges/resmush)](https://dieghernan.r-universe.dev/resmush)
[![CodeFactor](https://www.codefactor.io/repository/github/dieghernan/resmush/badge)](https://www.codefactor.io/repository/github/dieghernan/resmush)
[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

<!-- badges: end -->

**resmush** is a **R** package that allow users to optimize and compress
images using [reSmush.it](https://resmush.it/). reSmush.it is a free API
that provides image optimization, and it has been implemented on
Wordpress, Drupal or Magento.

Some of the features of reSmush.it are:

- Free optimization services, no API key required.
- Optimize local and online images.
- Image files supported: `png`, `jpg`, `gif`, `bmp`, `tif`.
- Max image size: 5 Mb.
- Compression via several algorithms:
  - [**PNGQuant**](https://pngquant.org/): Strip unneeded chunks from
    `png`s, preserving a full alpha transparency.
  - [**JPEGOptim**](https://github.com/tjko/jpegoptim)**:** Lossless
    optimization based on optimizing the Huffman tables.
  - [**OptiPNG**](https://optipng.sourceforge.net/): `png` reducer
    that’s used by several online optimizers.

## Installation

You can install the development version of **resmush** from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("dieghernan/resmush")
```

Alternatively, you can install **resmush**\* using the
[r-universe](https://dieghernan.r-universe.dev/resmush):

``` r
# Install resmush in R:
install.packages("resmush", repos = c(
  "https://dieghernan.r-universe.dev",
  "https://cloud.r-project.org"
))
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(resmush)
## basic example code
```

## Other alternatives with R

## Citation

<p>
Hernangómez D (2024). <em>resmush: Optimize and Compress Image Files
with reSmush.it</em>.
<a href="https://dieghernan.github.io/resmush/">https://dieghernan.github.io/resmush/</a>.
</p>

A BibTeX entry for LaTeX users is

    @Manual{R-arcgeocoder,
      title = {{resmush}: Optimize and Compress Image Files with {reSmush.it}},
      author = {Diego Hernangómez},
      year = {2024},
      version = {0.0.0.9000},
      url = {https://dieghernan.github.io/resmush/},
      abstract = {Compress local and online images using the reSmush.it API service <https://resmush.it/>.},
    }

## Attributions

Logo uses:

- [The great wave of Kanagawa icons created by Freepik -
  Flaticons](https://www.flaticon.com/free-icons/the-great-wave-of-kanagawa "the great wave of kanagawa icons")
- [Compression icons created by MansyGraphics -
  Flaticon](https://www.flaticon.com/free-icons/compression "compression icons")
