

<!-- README.md is generated from README.qmd. Please edit that file -->

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
[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![status](https://tinyverse.netlify.app/status/resmush)](https://CRAN.R-project.org/package=resmush)

<!-- badges: end -->

**resmush** is an **R** package for optimizing and compressing images
with [**reSmush.it**](https://resmush.it/). **reSmush.it** is a <u>free
API</u> for image optimization and is available through
[WordPress](https://wordpress.org/plugins/resmushit-image-optimizer/)
and [many other tools](https://resmush.it/tools/).

**reSmush.it** includes:

- Free image optimization with <u>no API key required</u>.
- Support for local and online images.
- Support for `png`, `jpg/jpeg`, `gif`, `bmp` and `tiff` files.
- Maximum image size: 5 MB.
- Compression powered by several algorithms:
  - [**PNGQuant**](https://pngquant.org/): Removes unnecessary chunks
    from `png` files while preserving full alpha transparency.
  - [**JPEGOptim**](https://github.com/tjko/jpegoptim): Lossless
    optimization based on Huffman table optimization.
  - [**OptiPNG**](https://optipng.sourceforge.net/): A `png` optimizer
    used by several online compression tools.

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

## Example

Compress an online `jpg` image with `resmush_url()`:

``` r
library(resmush)

url <- "https://dieghernan.github.io/resmush/img/jpg_example_original.jpg"

resmush_url(
  url,
  outfile = "man/figures/jpg_example_compress.jpg",
  overwrite = TRUE
)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 URL, total size 178.7 Kb.
#> ✔ Optimized 1 URL: Size is now 45 Kb (was 178.7 Kb). Saved 133.7 Kb (74.82%).
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

Use the `qlty` argument to adjust compression quality for `jpg` files.
Keep this value above 90 to maintain good image quality.

``` r
# Use an extreme compression setting.
resmush_url(
  url,
  outfile = "man/figures/jpg_example_compress_low.jpg",
  overwrite = TRUE,
  qlty = 3
)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 URL, total size 178.7 Kb.
#> ✔ Optimized 1 URL: Size is now 2.2 Kb (was 178.7 Kb). Saved 176.4 Kb (98.74%).
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

All optimization functions invisibly return a data frame that summarizes
the process. The following example shows this output when compressing a
local file:

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

Several other **R** packages also provide image optimization tools:

- The **xfun** package ([Xie 2024](#ref-xfun)), which includes:
  - `xfun::tinify()`: Similar to `resmush_file()` but uses
    [**TinyPNG**](https://tinypng.com/) and requires an API key.
  - `xfun::optipng()`: Compresses local files using **OptiPNG**, which
    must be installed locally.
- The [**tinieR**](https://jmablog.github.io/tinieR/) package by
  jmablog: An **R** interface to [**TinyPNG**](https://tinypng.com/).
- The **tinyimg** package ([Xie 2026](#ref-tinyimg)): Optimizes local
  `png` and `jpg/jpeg` files using Rust libraries.
- The [**optout**](https://github.com/coolbutuseless/optout) package by
  [@coolbutuseless](https://coolbutuseless.github.io/): Similar to
  `xfun::optipng()` but with more options. Requires additional local
  software.

| Tool | CRAN | Additional software | Online images | API key required | Limits |
|----|----|----|----|----|----|
| `xfun::tinify()` | Yes | No | Yes | Yes | 500 files/month (free tier) |
| `xfun::optipng()` | Yes | Yes | No | No | No |
| **tinieR** | No | No | Yes | Yes | 500 files/month (free tier) |
| **tinyimg** | Yes | Yes | No | No | No |
| **optout** | No | Yes | No | No | No |
| **resmush** | Yes | No | Yes | No | Maximum size: 5 MB |

<p class="caption">

Table 1: **R** packages: comparison of image optimization alternatives.
</p>

| Tool              | png | jpg | gif | bmp | tiff | webp | pdf |
|-------------------|-----|-----|-----|-----|------|------|-----|
| `xfun::tinify()`  | ✅  | ✅  | ❌  | ❌  | ❌   | ✅   | ❌  |
| `xfun::optipng()` | ✅  | ❌  | ❌  | ❌  | ❌   | ❌   | ❌  |
| **tinieR**        | ✅  | ✅  | ❌  | ❌  | ❌   | ✅   | ❌  |
| **tinyimg**       | ✅  | ✅  | ❌  | ❌  | ❌   | ❌   | ❌  |
| **optout**        | ✅  | ✅  | ❌  | ❌  | ❌   | ❌   | ✅  |
| **resmush**       | ✅  | ✅  | ✅  | ✅  | ✅   | ❌   | ❌  |

<p class="caption">

Table 2: **R** packages: supported formats.
</p>

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
      abstract = {Optimize and compress local image files, directories and online images with the reSmush.it API <https://resmush.it/>. Supports png, jpg/jpeg, gif, bmp and tiff files.},
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
