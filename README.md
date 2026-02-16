

<!-- README.md is generated from README.qmd. Please edit that file -->

# resmush <a href="https://dieghernan.github.io/resmush/"><img src="man/figures/logo.png" alt="resmush website" align="right" height="139"/></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/resmush)](https://CRAN.R-project.org/package=resmush)
[![CRAN
results](https://badges.cranchecks.info/worst/resmush.svg)](https://cran.r-project.org/web/checks/check_results_resmush.html)
[![Downloads](https://cranlogs.r-pkg.org/badges/resmush)](https://CRAN.R-project.org/package=resmush)
[![R-CMD-check](https://github.com/dieghernan/resmush/actions/workflows/check-full.yml/badge.svg)](https://github.com/dieghernan/resmush/actions/workflows/check-full.yml)
[![codecov](https://codecov.io/gh/dieghernan/resmush/graph/badge.svg)](https://app.codecov.io/gh/dieghernan/resmush)
[![CodeFactor](https://www.codefactor.io/repository/github/dieghernan/resmush/badge)](https://www.codefactor.io/repository/github/dieghernan/resmush)
[![r-universe](https://dieghernan.r-universe.dev/badges/resmush)](https://dieghernan.r-universe.dev/resmush)
[![DOI](https://img.shields.io/badge/DOI-10.32614/CRAN.package.resmush-blue)](https://doi.org/10.32614/CRAN.package.resmush)
[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![status](https://tinyverse.netlify.app/status/resmush)](https://CRAN.R-project.org/package=resmush)

<!-- badges: end -->

**resmush** is a **R** package that allows users to optimize and
compress images using [**reSmush.it**](https://resmush.it/). reSmush.it
is a <u>free API</u> that provides image optimization and has been
implemented in
[WordPress](https://wordpress.org/plugins/resmushit-image-optimizer/)
and [many other tools](https://resmush.it/tools/).

Some of the features of **reSmush.it** include:

- Free optimization services with <u>no API key required</u>.
- Support for both local and online images.
- Supported image formats: `png`, `jpg/jpeg`, `gif`, `bmp`, `tiff`.
- Maximum image size: 5 MB.
- Compression using several algorithms:
  - [**PNGQuant**](https://pngquant.org/): Removes unnecessary chunks
    from `png` files while preserving a full alpha transparency.
  - [**JPEGOptim**](https://github.com/tjko/jpegoptim)**:** Lossless
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

Check the docs of the developing version in
<https://dieghernan.github.io/resmush/dev/>.

You can install the development version of **resmush** from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("dieghernan/resmush")
```

Alternatively, install **resmush** using the
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

Compressing an online `jpg` image:

``` r
library(resmush)

url <- "https://dieghernan.github.io/resmush/img/jpg_example_original.jpg"

resmush_url(
  url,
  outfile = "man/figures/jpg_example_compress.jpg",
  overwrite = TRUE
)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 url with size 178.7 Kb
#> ✔ Success for 1 url: Size now is 45 Kb (was 178.7 Kb). Saved 133.7 Kb (74.82%).
#> See result in directory 'man/figures'.
```

<div class="figure">

[<img
src="https://dieghernan.github.io/resmush/img/jpg_example_original.jpg"
style="width:100.0%" alt="Original uncompressed file" />](https://dieghernan.github.io/resmush/img/jpg_example_original.jpg)
<small class="caption fst-italic">(a)</small>

[<img src="./man/figures/jpg_example_compress.jpg" style="width:100.0%"
alt="Optimized file" />](https://dieghernan.github.io/resmush/reference/figures/jpg_example_compress.jpg)
<small class="caption fst-italic">(b)</small>

<figcaption>

Figure 1: Original picture <em>(a)</em>: 178.7 Kb; Optimized picture
<em>(b)</em>: 45 Kb (Compression: 74.8%). Click to enlarge.
</figcaption>

</div>

The compression quality for `jpg` files can be adjusted using the `qlty`
argument. However, it is recommended to keep this value above 90 to
maintain good image quality.

``` r
# Extreme case
resmush_url(
  url,
  outfile = "man/figures/jpg_example_compress_low.jpg",
  overwrite = TRUE,
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

<figcaption>

Figure 2: Low quality image due to a high compression rate.
</figcaption>

</div>

All the functions return (invisibly) a dataset summarizing the process.
The following example shows how this works when compressing a local
file:

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

Several other **R** packages also provide image optimization tools:

- **xfun** ([Xie 2024](#ref-xfun)), which includes:
  - `xfun::tinify()`: Similar to `resmush_file()` but uses
    [**TinyPNG**](https://tinypng.com/) and requires an API key.
  - `xfun::optipng()`: Compresses local files using **OptiPNG**, which
    must be installed locally.
- [**tinieR**](https://jmablog.github.io/tinieR/) by jmablog: An **R**
  interface to [**TinyPNG**](https://tinypng.com/).
- [**optout**](https://github.com/coolbutuseless/optout) by
  [@coolbutuseless](https://coolbutuseless.github.io/): Similar to
  `xfun::optipng()` but with more options. Requires additional local
  software.

| tool | CRAN | Additional software? | Online? | API Key? | Limits? |
|----|----|----|----|----|----|
| `xfun::tinify()` | Yes | No | Yes | Yes | 500 files/month (free tier) |
| `xfun::optipng()` | Yes | Yes | No | No | No |
| **tinieR** | No | No | Yes | Yes | 500 files/month (free tier) |
| **optout** | No | Yes | No | No | No |
| **resmush** | Yes | No | Yes | No | Max size 5 MB |

<p class="caption">

Table 1: <strong>R</strong> packages: Comparison of alternatives for
optimizing images.
</p>

| tool              | png | jpg | gif | bmp | tiff | webp | pdf |
|-------------------|-----|-----|-----|-----|------|------|-----|
| `xfun::tinify()`  | ✅  | ✅  | ❌  | ❌  | ❌   | ✅   | ❌  |
| `xfun::optipng()` | ✅  | ❌  | ❌  | ❌  | ❌   | ❌   | ❌  |
| **tinieR**        | ✅  | ✅  | ❌  | ❌  | ❌   | ✅   | ❌  |
| **optout**        | ✅  | ✅  | ❌  | ❌  | ❌   | ❌   | ✅  |
| **resmush**       | ✅  | ✅  | ✅  | ✅  | ✅   | ❌   | ❌  |

<p class="caption">

Table 2: <strong>R</strong> packages: Supported formats.
</p>

## Citation

<p>

Hernangómez D (2026). <em>resmush: Optimize and Compress Image Files
with reSmush.it</em>.
<a href="https://doi.org/10.32614/CRAN.package.resmush">doi:10.32614/CRAN.package.resmush</a>,
<a href="https://dieghernan.github.io/resmush/">https://dieghernan.github.io/resmush/</a>.
</p>

A BibTeX entry for LaTeX users is

    @Manual{R-resmush,
      title = {{resmush}: Optimize and Compress Image Files with {reSmush.it}},
      doi = {10.32614/CRAN.package.resmush},
      author = {Diego Hernangómez},
      year = {2026},
      version = {0.2.2},
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
