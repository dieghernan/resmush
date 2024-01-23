
<!-- README.md is generated from README.Rmd. Please edit that file -->

# resmush <a href="https://dieghernan.github.io/resmush/"><img src="man/figures/logo.png" alt="resmush website" align="right" height="139"/></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/dieghernan/resmush/actions/workflows/check-full.yaml/badge.svg)](https://github.com/dieghernan/resmush/actions/workflows/check-full.yaml)
[![codecov](https://codecov.io/gh/dieghernan/resmush/graph/badge.svg)](https://app.codecov.io/gh/dieghernan/resmush)
[![r-universe](https://dieghernan.r-universe.dev/badges/resmush)](https://dieghernan.r-universe.dev/resmush)
[![CodeFactor](https://www.codefactor.io/repository/github/dieghernan/resmush/badge)](https://www.codefactor.io/repository/github/dieghernan/resmush)
[![DOI](https://img.shields.io/badge/DOI-10.5281/zenodo.10556679-blue)](https://doi.org/10.5281/zenodo.10556679)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

<!-- badges: end -->

**resmush** is a **R** package that allow users to optimize and compress
images using [reSmush.it](https://resmush.it/). reSmush.it is a free API
that provides image optimization, and it has been implemented on
Wordpress, Drupal or Magento.

Some of the features of reSmush.it are:

- Free optimization services, no API key required.
- Optimize local and online images.
- Image files supported: `png`, `jpg/jpeg`, `gif`, `bmp`, `tiff`,
  `webp`.
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

<img src="https://raw.githubusercontent.com/dieghernan/resmush/main/img/jpg_example_original.jpg" alt="Original online figure" width="100%"/>
<img src="./man/figures/jpg_example_compress.jpg" alt="Optimized figure" width="100%"/>

<p class="caption">

Original picture (top) 178.7 Kb and optimized picture (bottom) 45 Kb
(Compression 74.8%)

</p>

</div>

The quality of the compression can be adjusted in the case of `jpg`
files using the parameter `qlty`. However, it is recommended to keep
this value above 90 to get a good image quality.

``` r
resmush_url(url,
  outfile = "man/figures/jpg_example_compress_low.jpg", qlty = 10,
  verbose = TRUE
)
#> ✔ Optimizing https://raw.githubusercontent.com/dieghernan/resmush/main/img/jpg_example_original.jpg:
#> ℹ Effective compression ratio: 96.9%
#> ℹ Current size: 5.6 Kb (was 178.7 Kb)
#> ℹ Output: 'man/figures/jpg_example_compress_low.jpg'
```

<div class="figure">

<figure>
<img src="man/figures/jpg_example_compress_low.jpg" style="width:100.0%"
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
png_file <- system.file("extimg/example.png", package = "resmush")

# For the example, copy to a temporary file
tmp_png <- tempfile(fileext = ".png")
file.copy(png_file, tmp_png, overwrite = TRUE)
#> [1] TRUE


summary <- resmush_file(tmp_png)

tibble::as_tibble(summary[, -c(1, 2)])
#> # A tibble: 1 × 4
#>   src_size dest_size compress_ratio notes
#>   <chr>    <chr>     <chr>          <chr>
#> 1 239.9 Kb 70.7 Kb   70.5%          OK ;)
```

## Other alternatives

- [**xfun**](https://cran.r-project.org/package=xfun) package by Yihui
  Xie [![Sponsor Yihui Xie on
  GitHub](man/figures/sponsor.svg)](https://github.com/sponsors/yihui)
  has the following functions that optimize image files:
  - `xfun::tinify()` is similar to `resmush_file()` but uses
    [TinyPNG](https://tinypng.com/). API key required.
  - `xfun::optipng()` compress local files with OptiPNG (that needs to
    be installed locally).
- [**tinieR**](https://jmablog.github.io/tinieR/) package by
  [jmablog](https://jmablog.com/). **R** package that provides a full
  interface with [TinyPNG](https://tinypng.com/).
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
<a href="https://doi.org/10.5281/zenodo.10556679">doi:10.5281/zenodo.10556679</a>,
<a href="https://dieghernan.github.io/resmush/">https://dieghernan.github.io/resmush/</a>.
</p>

A BibTeX entry for LaTeX users is

    @Manual{R-resmush,
      title = {{resmush}: Optimize and Compress Image Files with {reSmush.it}},
      author = {Diego Hernangómez},
      year = {2024},
      version = {0.0.1.9000},
      doi = {10.5281/zenodo.10556679},
      url = {https://dieghernan.github.io/resmush/},
      abstract = {Compress local and online images using the reSmush.it API service <https://resmush.it/>.},
    }

## Attributions

Logo uses:

- [The great wave of Kanagawa icons created by Freepik -
  Flaticons](https://www.flaticon.com/free-icons/the-great-wave-of-kanagawa "the great wave of kanagawa icons")
- [Compression icons created by MansyGraphics -
  Flaticon](https://www.flaticon.com/free-icons/compression "compression icons")
