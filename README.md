
<!-- README.md is generated from README.Rmd. Please edit that file -->

# resmush <a href="https://dieghernan.github.io/resmush/"><img src="man/figures/logo.png" alt="resmush website" align="right" height="139"/></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/resmush)](https://CRAN.R-project.org/package=resmush)
[![CRAN
results](https://badges.cranchecks.info/worst/resmush.svg)](https://cran.r-project.org/web/checks/check_results_resmush.html)
[![Downloads](https://cranlogs.r-pkg.org/badges/resmush)](https://CRAN.R-project.org/package=resmush)
[![R-CMD-check](https://github.com/dieghernan/resmush/actions/workflows/check-full.yaml/badge.svg)](https://github.com/dieghernan/resmush/actions/workflows/check-full.yaml)
[![R-hub](https://github.com/dieghernan/resmush/actions/workflows/rhub.yaml/badge.svg)](https://github.com/dieghernan/resmush/actions/workflows/rhub.yaml)
[![codecov](https://codecov.io/gh/dieghernan/resmush/graph/badge.svg)](https://app.codecov.io/gh/dieghernan/resmush)
[![CodeFactor](https://www.codefactor.io/repository/github/dieghernan/resmush/badge)](https://www.codefactor.io/repository/github/dieghernan/resmush)
[![r-universe](https://dieghernan.r-universe.dev/badges/resmush)](https://dieghernan.r-universe.dev/resmush)
[![DOI](https://img.shields.io/badge/DOI-10.32614/CRAN.package.resmush-blue)](https://doi.org/10.32614/CRAN.package.resmush)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![status](https://tinyverse.netlify.app/status/resmush)](https://CRAN.R-project.org/package=resmush)

<!-- badges: end -->

**resmush** is a **R** package that allow users to optimize and compress
images using [**reSmush.it**](https://resmush.it/). reSmush.it is a
<u>free API</u> that provides image optimization, and it has been
implemented on
[WordPress](https://wordpress.org/plugins/resmushit-image-optimizer/),
[Drupal](https://www.drupal.org/project/resmushit) and [many
more](https://resmush.it/tools/).

Some of the features of **reSmush.it** are:

- Free optimization services, no API key required.
- Optimize local and online images.
- Image files supported: `png`, `jpg/jpeg`, `gif`, `bmp`, `tiff`.
- Max image size: 5 Mb.
- Compression via several algorithms:
  - [**PNGQuant**](https://pngquant.org/): Strip unneeded chunks from
    `png`s, preserving a full alpha transparency.
  - [**JPEGOptim**](https://github.com/tjko/jpegoptim)**:** Lossless
    optimization based on optimizing the Huffman tables.
  - [**OptiPNG**](https://optipng.sourceforge.net/): `png` reducer that
    is used by several online optimizers.

## Installation

Install **resmush** from
[**CRAN**](https://CRAN.R-project.org/package=resmush) with:

``` r
install.packages("resmush")
```

You can install the development version of **resmush** from
[GitHub](https://github.com/) with:

``` r
remotes::install_github("dieghernan/resmush")
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

resmush_url(url, outfile = "man/figures/jpg_example_compress.jpg", overwrite = TRUE)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 url with size 178.7 Kb
#> ✔ Success for 1 url: Size now is 45 Kb (was 178.7 Kb). Saved 133.7 Kb (74.82%).
#> See result in directory 'man/figures'.
```

<div class="figure">

[<img
src="https://raw.githubusercontent.com/dieghernan/resmush/main/img/jpg_example_original.jpg"
style="width:100.0%" alt="Original uncompressed file" />](https://raw.githubusercontent.com/dieghernan/resmush/main/img/jpg_example_original.jpg)

[<img src="./man/figures/jpg_example_compress.jpg" style="width:100.0%"
alt="Optimized file" />](https://dieghernan.github.io/resmush/reference/figures/jpg_example_compress.jpg)

<p class="caption">

Original picture (top) 178.7 Kb and optimized picture (bottom) 45 Kb
(Compression 74.8%). Click to enlarge.

</p>

</div>

The quality of the compression can be adjusted in the case of `jpg`
files using the parameter `qlty`. However, it is recommended to keep
this value above 90 to get a good image quality.

``` r
# Extreme case
resmush_url(url,
  outfile = "man/figures/jpg_example_compress_low.jpg", overwrite = TRUE,
  qlty = 3
)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 url with size 178.7 Kb
#> ✔ Success for 1 url: Size now is 2.2 Kb (was 178.7 Kb). Saved 176.4 Kb (98.74%).
#> See result in directory 'man/figures'.
```

<div class="figure">

[<img src="man/figures/jpg_example_compress_low.jpg" style="width:100.0%"
alt="Low quality figure" />](https://dieghernan.github.io/resmush/reference/figures/jpg_example_compress_low.jpg)

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


summary <- resmush_file(tmp_png, overwrite = TRUE)

tibble::as_tibble(summary[, -c(1, 2)])
#> # A tibble: 1 × 6
#>   src_size dest_size compress_ratio notes src_bytes dest_bytes
#>   <chr>    <chr>     <chr>          <chr>     <dbl>      <dbl>
#> 1 239.9 Kb 70.7 Kb   70.54%         OK       245618      72356
```

## Other alternatives

There are other alternatives for optimizing images with **R**:

- **xfun** ([Xie 2024](#ref-xfun)), which includes the following
  functions for optimizing image files:
  - `xfun::tinify()` is similar to `resmush_file()` but uses
    [**TinyPNG**](https://tinypng.com/). An API key is required.
  - `xfun::optipng()` compresses local files with **OptiPNG** (which
    needs to be installed locally).
- [**tinieR**](https://jmablog.github.io/tinieR/) package by
  [jmablog](https://jmablog.com/). An **R** package that provides a full
  interface with [**TinyPNG**](https://tinypng.com/).
- [**optout**](https://github.com/coolbutuseless/optout) package by
  [@coolbutuseless](https://coolbutuseless.github.io/). Similar to
  `xfun::optipng()` with more options. Requires additional software to
  be installed locally.

| tool | CRAN | Additional software? | Online? | API Key? | Limits? |
|----|----|----|----|----|----|
| `xfun::tinify()` | Yes | No | Yes | Yes | 500 files/month (Free tier) |
| `xfun::optipng()` | Yes | Yes | No | No | No |
| **tinieR** | No | No | Yes | Yes | 500 files/month (Free tier) |
| **optout** | No | Yes | No | No | No |
| **resmush** | Yes | No | Yes | No | Max size 5Mb |

Table 1: **R** packages: Comparison of alternatives for optimizing
images.

| tool              | png | jpg | gif | bmp | tiff | webp | pdf |
|-------------------|-----|-----|-----|-----|------|------|-----|
| `xfun::tinify()`  | ✅  | ✅  | ❌  | ❌  | ❌   | ✅   | ❌  |
| `xfun::optipng()` | ✅  | ❌  | ❌  | ❌  | ❌   | ❌   | ❌  |
| **tinieR**        | ✅  | ✅  | ❌  | ❌  | ❌   | ✅   | ❌  |
| **optout**        | ✅  | ✅  | ❌  | ❌  | ❌   | ❌   | ✅  |
| **resmush**       | ✅  | ✅  | ✅  | ✅  | ✅   | ❌   | ❌  |

Table 2: **R** packages: Formats admitted.

## Citation

<p>
Hernangómez D (2024). <em>resmush: Optimize and Compress Image Files
with reSmush.it</em>.
<a href="https://doi.org/10.32614/CRAN.package.resmush">doi:10.32614/CRAN.package.resmush</a>,
<a href="https://dieghernan.github.io/resmush/">https://dieghernan.github.io/resmush/</a>.
</p>

A BibTeX entry for LaTeX users is

    @Manual{R-resmush,
      title = {{resmush}: Optimize and Compress Image Files with {reSmush.it}},
      doi = {10.32614/CRAN.package.resmush},
      author = {Diego Hernangómez},
      year = {2024},
      version = {0.2.0},
      url = {https://dieghernan.github.io/resmush/},
      abstract = {Compress local and online images using the reSmush.it API service <https://resmush.it/>.},
    }

## References

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0">

<div id="ref-xfun" class="csl-entry">

Xie, Yihui. 2024. *<span class="nocase">xfun</span>: Supporting
Functions for Packages Maintained by Yihui Xie*.
<https://github.com/yihui/xfun>.

</div>

</div>
