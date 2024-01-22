
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
  - [**OptiPNG**](https://optipng.sourceforge.net/): `png` reducer that
    is used by several online optimizers.

## Installation

You can install the development version of **resmush** from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("dieghernan/resmush")
```

Alternatively, you can install **resmush** using the
[r-universe](https://dieghernan.r-universe.dev/resmush):

``` r
# Install resmush in R:
install.packages("resmush", repos = c(
  "https://dieghernan.r-universe.dev",
  "https://cloud.r-project.org"
))
```

## Example

Compressing an online `jpg` image:

``` r
library(resmush)

url <- paste0(
  "https://raw.githubusercontent.com/dieghernan/",
  "resmush/main/img/jpg_example_original.jpg"
)

resmush_url(url, outfile = "man/figures/jpg_example_compress.jpg")
```

<div class="figure">

<img src="https://raw.githubusercontent.com/dieghernan/resmush/main/img/jpg_example_original.jpg" alt="Original online figure" width="49%"/>

<img src="./man/figures/jpg_example_compress.jpg" alt="Optimized figure" width="49%"/>

<p class="caption">

Original picture (left) 178.7 Kb and optimized picture (right) 45 Kb
(Compression 74.8%)

</p>

</div>

The quality of the compression can be adjusted in the case of `jpg`
files using the parameter `qlty`. However, it is recommended to keep
this value above 90 to get a good image quality.

``` r
resmush_url(url,
  outfile = "man/figures/jpg_example_low.jpg", qlty = 10,
  verbose = TRUE
)
```

<div class="figure">

<figure>
<img src="./man/figures/jpg_example_low.jpg" style="width:100.0%"
alt="Low quality figure" />
<figcaption aria-hidden="true">Low quality figure</figcaption>
</figure>

<p class="caption">

Low quality image due to a high compression rate.

</p>

</div>

All the functions return invisibly a data set with a summary of the
process. The next example shows how when compressing a local file.

``` r
tmpfile <- tempfile(fileext = ".png")
url2 <- paste0(
  "https://raw.githubusercontent.com/dieghernan/",
  "resmush/main/img/png_example_original.png"
)

download.file(url2, tmpfile, quiet = TRUE)

summary <- resmush_file(tmpfile)

tibble::as_tibble(summary[, -c(1, 2)])
#> # A tibble: 1 × 4
#>   src_size dest_size compress_ratio notes
#>   <chr>    <chr>     <chr>          <chr>
#> 1 186.2 Kb 70.8 Kb   62.0%          OK ;)
```

## Other alternatives

- [**xfun**](https://cran.r-project.org/package=xfun) package by Yihui
  Xie [![Sponsor Yihui Xie on
  GitHub](https://img.shields.io/badge/Sponsor-white?style=flat&logo=github&logoColor=%23bf3989)](https://github.com/sponsors/yihui)
  has the following functions that optimize image files:

  - `xfun::tinify()` is similar to `resmush_file()` but uses
    [TinyPNG](https://tinypng.com/). API key required.
  - `xfun::optipng()` compress local files with OptiPNG (that needs to
    be installed locally).

- [**optout**](https://github.com/coolbutuseless/optout) package by
  [@coolbutuseless](https://coolbutuseless.github.io/). Similar to
  `xfun::optipng()` with additionall options. Needs additional software
  installed locally.

- [Imgbot](https://imgbot.net/): Automatic optimization for files hosted
  in GitHub repos.

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
