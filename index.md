

<!-- index.md is generated from index.qmd. Please edit that file -->

# resmush <a href="https://dieghernan.github.io/resmush/"><img src="man/figures/logo.png" alt="resmush website" align="right" height="139"/></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/resmush)](https://CRAN.R-project.org/package=resmush)
[![CRAN
results](https://badges.cranchecks.info/worst/resmush.svg)](https://cran.r-project.org/web/checks/check_results_resmush.html)
[![Downloads](https://cranlogs.r-pkg.org/badges/resmush)](https://CRAN.R-project.org/package=resmush)
[![R-CMD-check](https://github.com/dieghernan/resmush/actions/workflows/check-full.yaml/badge.svg)](https://github.com/dieghernan/resmush/actions/workflows/check-full.yaml)
[![codecov](https://codecov.io/gh/dieghernan/resmush/graph/badge.svg)](https://app.codecov.io/gh/dieghernan/resmush)
[![CodeFactor](https://www.codefactor.io/repository/github/dieghernan/resmush/badge)](https://www.codefactor.io/repository/github/dieghernan/resmush)
[![r-universe](https://dieghernan.r-universe.dev/badges/resmush)](https://dieghernan.r-universe.dev/resmush)
[![DOI](https://img.shields.io/badge/DOI-10.32614/CRAN.package.resmush-blue)](https://doi.org/10.32614/CRAN.package.resmush)
[![Project Status: Inactive – The project has reached a stable, usable
state but is no longer being actively developed; support/maintenance
will be provided as time
allows.](https://www.repostatus.org/badges/latest/inactive.svg)](https://www.repostatus.org/#inactive)
[![status](https://tinyverse.netlify.app/status/resmush)](https://CRAN.R-project.org/package=resmush)

<!-- badges: end -->

**resmush** is an **R** package for optimizing local image files,
directories and online images with the [**reSmush.it**
API](https://resmush.it/api/). The API is free for personal use and does
not require an API key. **reSmush.it** is also available through
[WordPress](https://wordpress.org/plugins/resmushit-image-optimizer/)
and [other tools](https://resmush.it/tools/).

The **reSmush.it** API provides:

- Optimization without an API key.
- Support for PNG, JPEG, GIF, BMP and TIFF files.
- A file size limit of less than 5 MB.
- Compression powered by multiple algorithms:
  - [**pngquant**](https://pngquant.org/): Removes unnecessary data from
    PNG files while preserving full alpha transparency.
  - [**JPEGOptim**](https://github.com/tjko/jpegoptim): Lossless
    optimization based on Huffman table optimization.
  - [**OptiPNG**](https://optipng.sourceforge.net/): A PNG optimizer
    used by several online compression tools.

<div class="callout callout-style-default callout-note callout-titled">
<div class="callout-header d-flex align-content-center">
<div class="callout-icon-container"><i class="callout-icon"></i></div>
<div class="callout-title-container flex-fill">Note</div></div>
<div class="callout-body-container callout-body">

This package is stable and maintained on a best-effort basis. I
currently prioritize CRAN compatibility, bug fixes and regressions over
new features.

</div>
</div>

## Installation

<div class="pkgdown-release">

Install **resmush** from
[**CRAN**](https://CRAN.R-project.org/package=resmush) with:

``` r
install.packages("resmush")
```

</div>

<div class="pkgdown-devel">

Check the documentation for the development version at
<https://dieghernan.github.io/resmush/dev/>.

You can install the development version of **resmush** from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("dieghernan/resmush")
```

Alternatively, install **resmush** from
[r-universe](https://dieghernan.r-universe.dev/resmush):

``` r
# Install resmush in R:
install.packages(
  "resmush",
  repos = c(
    "https://dieghernan.r-universe.dev",
    "https://cloud.r-project.org"
  )
)
```

</div>

## Examples

Optimize and download an online JPEG image with `resmush_url()`:

``` r
library(resmush)

url <- "https://dieghernan.github.io/resmush/img/jpg_example_original.jpg"

resmush_url(
  url,
  outfile = "man/figures/jpg_example_compress.jpg",
  overwrite = TRUE
)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 URL, 178.7 Kb total.
#> ✔ Optimized 1 URL: size is now 45 Kb (was 178.7 Kb). Saved 133.7 Kb (74.82%).
#> Saved result in directory 'man/figures'.
```

<div class="figure">

[<img
src="https://dieghernan.github.io/resmush/img/jpg_example_original.jpg"
style="width:100.0%" alt="Original uncompressed JPEG image" />](https://dieghernan.github.io/resmush/img/jpg_example_original.jpg)
<small class="caption fst-italic">(a)</small>

[<img src="./man/figures/jpg_example_compress.jpg" style="width:100.0%"
alt="Optimized JPEG image" />](https://dieghernan.github.io/resmush/reference/figures/jpg_example_compress.jpg)
<small class="caption fst-italic">(b)</small>

<figcaption>

Figure 1: Original image <em>(a)</em>: 178.7 KB, optimized image
<em>(b)</em>: 45 KB (compression: 74.8%). Click to enlarge.
</figcaption>

</div>

Use the `qlty` argument to adjust the optimization level for JPEG files.
For best results, use values above `90`.

``` r
# Use a low optimization level.
resmush_url(
  url,
  outfile = "man/figures/jpg_example_compress_low.jpg",
  overwrite = TRUE,
  qlty = 3
)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 URL, 178.7 Kb total.
#> ✔ Optimized 1 URL: size is now 2.2 Kb (was 178.7 Kb). Saved 176.4 Kb (98.74%).
#> Saved result in directory 'man/figures'.
```

<div class="figure">

[<img src="man/figures/jpg_example_compress_low.jpg" style="width:100.0%"
alt="JPEG image with visible compression artifacts" />](https://dieghernan.github.io/resmush/reference/figures/jpg_example_compress_low.jpg)

<figcaption>

Figure 2: Image with visible compression artifacts caused by high
compression (`qlty = 3`).
</figcaption>

</div>

All optimization functions return, invisibly, a data frame summarizing
the optimization. Successful API calls also write the optimized files to
disk. The following example shows the returned data frame for a local
image file:

``` r
png_file <- system.file("extimg/example.png", package = "resmush")

# Copy to a temporary file for this example.
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

## Alternatives

Several other **R** packages provide image optimization tools:

- The **xfun** package ([Xie 2024](#ref-xfun)), which includes:
  - `xfun::tinify()`: Similar to `resmush_file()` but uses
    [**TinyPNG**](https://tinypng.com/) and requires an API key.
  - `xfun::optipng()`: Compresses local files using **OptiPNG**, which
    must be installed locally.
- The [**tinieR**](https://jmablog.github.io/tinieR/) package by
  jmablog: an **R** interface to [**TinyPNG**](https://tinypng.com/).
- The **tinyimg** package ([Xie 2026](#ref-tinyimg)): Optimizes local
  PNG and JPEG files using Rust libraries. It supports lossless PNG
  optimization via `oxipng`, optional lossy PNG palette reduction, and
  JPEG re-encoding via `mozjpeg`.
- The [**optout**](https://github.com/coolbutuseless/optout) package by
  [@coolbutuseless](https://coolbutuseless.github.io/): Similar to
  `xfun::optipng()` but with more options. Requires additional local
  software.

| Tool | CRAN | Additional software | Online images | API key required | Limits |
|----|----|----|----|----|----|
| `xfun::tinify()` | Yes | No | Yes | Yes | 500 compressions/month (free tier) |
| `xfun::optipng()` | Yes | Yes | No | No | No |
| **tinieR** | No | No | Yes | Yes | 500 compressions/month (free tier) |
| **tinyimg** | Yes | Yes (Rust toolchain) | No | No | No |
| **optout** | No | Yes | No | No | No |
| **resmush** | Yes | No | Yes | No | Personal use, files under 5 MB |

<p class="caption">

Table 1: **R** packages: comparison of image optimization alternatives.
</p>

| Tool              | PNG | JPEG | GIF | BMP | TIFF | WebP | PDF |
|-------------------|-----|------|-----|-----|------|------|-----|
| `xfun::tinify()`  | ✅  | ✅   | ❌  | ❌  | ❌   | ✅   | ❌  |
| `xfun::optipng()` | ✅  | ❌   | ❌  | ❌  | ❌   | ❌   | ❌  |
| **tinieR**        | ✅  | ✅   | ❌  | ❌  | ❌   | ✅   | ❌  |
| **tinyimg**       | ✅  | ✅   | ❌  | ❌  | ❌   | ❌   | ❌  |
| **optout**        | ✅  | ✅   | ❌  | ❌  | ❌   | ❌   | ✅  |
| **resmush**       | ✅  | ✅   | ✅  | ✅  | ✅   | ❌   | ❌  |

<p class="caption">

Table 2: **R** packages: supported formats.
</p>

In practice, **resmush** is designed for quick image optimization with
minimal setup, including support for online images and formats such as
GIF, BMP and TIFF. Packages such as **tinyimg** may be a better fit for
fully local workflows focused on PNG / JPEG optimization and
fine-grained control over compression settings.

## Citation

<p>

Hernangómez D (2026). <em>resmush: Optimize and Compress Image Files
with reSmush.it</em>.
<a href="https://doi.org/10.32614/CRAN.package.resmush">doi:10.32614/CRAN.package.resmush</a>.
<a href="https://dieghernan.github.io/resmush/">https://dieghernan.github.io/resmush/</a>.
</p>

A BibTeX entry for LaTeX users:

    @Manual{R-resmush,
      title = {{resmush}: Optimize and Compress Image Files with {reSmush.it}},
      doi = {10.32614/CRAN.package.resmush},
      author = {Diego Hernangómez},
      year = {2026},
      version = {1.0.1},
      url = {https://dieghernan.github.io/resmush/},
      abstract = {Optimize and compress local image files, directories and online images with the reSmush.it API <https://resmush.it/api/>. The API is free for personal use, accepts files smaller than 5 MB and supports PNG, JPEG, GIF, BMP and TIFF files.},
    }

## References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-xfun" class="csl-entry">

Xie, Yihui. 2024. *<span class="nocase">xfun</span>: Supporting
Functions for Packages Maintained by Yihui Xie*.
<https://github.com/yihui/xfun>.

</div>

<div id="ref-tinyimg" class="csl-entry">

Xie, Yihui. 2026. *<span class="nocase">tinyimg</span>: Optimize and
Compress Images*. <https://doi.org/10.32614/CRAN.package.tinyimg>.

</div>

</div>
