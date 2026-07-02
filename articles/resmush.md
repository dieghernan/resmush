# Using resmush

**resmush** is an **R** package for optimizing local and online image
files, individually or in entire directories, with the [**reSmush.it**
API](https://resmush.it/api/). The API is free for personal use and does
not require an API key. **reSmush.it** is also available through
[WordPress](https://wordpress.org/plugins/resmushit-image-optimizer/)
and [other tools](https://resmush.it/tools/).

The **reSmush.it** API provides:

- Optimization without an API key.
- Support for PNG, JPEG, GIF, BMP and TIFF files.
- A file size limit of less than 5 MB.
- Compression powered by several algorithms:
  - [**pngquant**](https://pngquant.org/): Removes unnecessary data from
    PNG files while preserving full alpha transparency.
  - [**jpegoptim**](https://github.com/tjko/jpegoptim): Lossless
    optimization based on Huffman table optimization.
  - [**OptiPNG**](https://optipng.sourceforge.net/): A PNG optimizer
    used by several online compression tools.

## Examples

Optimize and download an online JPEG image with
[`resmush_url()`](https://dieghernan.github.io/resmush/reference/resmush_url.md):

``` r

library(resmush)

url <- "https://dieghernan.github.io/resmush/img/jpg_example_original.jpg"

resmush_url(url, outfile = "jpg_example_compress.jpg", overwrite = TRUE)

#> ══ resmush summary ═══════════════════════════════════════════════════════════════════════
#> ℹ Input: 1 URL, 178.7 Kb total.
#> ✔ Optimized 1 URL: size is now 45 Kb (was 178.7 Kb). Saved 133.7 Kb (74.82%).
#> Saved result in directory 'C:/user/john_doe/AppData/Local/Temp/'.
```

[![Original uncompressed JPEG
image](https://dieghernan.github.io/resmush/img/jpg_example_original.jpg)](https://dieghernan.github.io/resmush/img/jpg_example_original.jpg)

\(a\)

[![Optimized JPEG
image](https://dieghernan.github.io/resmush/reference/figures/jpg_example_compress.jpg)](https://dieghernan.github.io/resmush/reference/figures/jpg_example_compress.jpg)

\(b\)

Figure 1: Original image [Figure 1 (a)](#fig-orig): 178.7 KB, optimized
image [Figure 1 (b)](#fig-new): 45 KB (compression: 74.8%). Click to
enlarge.

Use the `qlty` argument to adjust the JPEG quality level. For best
results, use values above `90`.

``` r

# Use a low JPEG quality level.
resmush_url(
  url,
  outfile = tempfile(fileext = ".jpg"),
  overwrite = TRUE,
  qlty = 3
)

#> ══ resmush summary ═══════════════════════════════════════════════════════════════════════
#> ℹ Input: 1 URL, 178.7 Kb total.
#> ✔ Optimized 1 URL: size is now 2.2 Kb (was 178.7 Kb). Saved 176.4 Kb (98.74%).
#> Saved result in directory 'C:/user/john_doe/AppData/Local/Temp/'.
```

[![JPEG image with visible compression
artifacts](https://dieghernan.github.io/resmush/reference/figures/jpg_example_compress_low.jpg)](https://dieghernan.github.io/resmush/reference/figures/jpg_example_compress_low.jpg)

Figure 2: Image with visible compression artifacts caused by high
compression (`qlty = 3`), compared with [Figure 1 (b)](#fig-new).

When results are available, all optimization functions invisibly return
a data frame with one row per result and columns containing source and
destination paths, formatted and raw file sizes, compression ratios and
status notes. They return `NULL` otherwise. Successful API calls also
write the optimized files to disk. The following example shows the
result for a local image file:

``` r

png_file <- system.file("extimg/example.png", package = "resmush")

# Copy to a temporary file for this example.
tmp_png <- tempfile(fileext = ".png")
file.copy(png_file, tmp_png, overwrite = TRUE)
#> [1] TRUE

summary <- resmush_file(tmp_png, overwrite = TRUE)

tibble::as_tibble(summary[, -c(1, 2)])
#>   # A tibble: 1 × 6
#>   src_size dest_size compress_ratio notes src_bytes dest_bytes
#>   <chr>    <chr>     <chr>          <chr>     <dbl>      <dbl>
#> 1 239.9 Kb 70.7 Kb   70.54%         OK       245618      72356
```

## Alternatives

Several other **R** packages provide image optimization tools:

- The **xfun** package ([Xie 2026b](#ref-xfun)) provides:
  - [`xfun::tinify()`](https://rdrr.io/pkg/xfun/man/tinify.html):
    Similar to
    [`resmush_file()`](https://dieghernan.github.io/resmush/reference/resmush_file.md)
    but uses [**TinyPNG**](https://tinypng.com/) and requires an API
    key.
  - [`xfun::optipng()`](https://rdrr.io/pkg/xfun/man/optipng.html):
    Compresses local files using **OptiPNG**. The program must be
    installed locally.
- The [**tinieR**](https://jmablog.github.io/tinieR/) package: An **R**
  interface to [**TinyPNG**](https://tinypng.com/).
- The **tinyimg** package ([Xie 2026a](#ref-tinyimg)): Optimizes local
  PNG and JPEG files using Rust libraries. It supports lossless PNG
  optimization via **oxipng**, optional lossy PNG palette reduction and
  JPEG re-encoding via **mozjpeg**.
- The [**optout**](https://github.com/coolbutuseless/optout) package:
  Similar to
  [`xfun::optipng()`](https://rdrr.io/pkg/xfun/man/optipng.html) but
  with more options. It requires additional local software.

| Tool | CRAN | Additional software | Online images | API key required | Limits |
|----|----|----|----|----|----|
| [`xfun::tinify()`](https://rdrr.io/pkg/xfun/man/tinify.html) | Yes | No | Yes | Yes | 500 compressions per month (free tier) |
| [`xfun::optipng()`](https://rdrr.io/pkg/xfun/man/optipng.html) | Yes | Yes | No | No | None |
| **tinieR** | No | No | Yes | Yes | 500 compressions per month (free tier) |
| **tinyimg** | Yes | Yes (Rust toolchain) | No | No | None |
| **optout** | No | Yes | No | No | None |
| **resmush** | Yes | No | Yes | No | Personal use only. Files smaller than 5 MB. |

Table 1: **R** packages: comparison of image optimization alternatives.

| Tool | PNG | JPEG | GIF | BMP | TIFF | WebP | PDF |
|----|----|----|----|----|----|----|----|
| [`xfun::tinify()`](https://rdrr.io/pkg/xfun/man/tinify.html) | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ |
| [`xfun::optipng()`](https://rdrr.io/pkg/xfun/man/optipng.html) | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **tinieR** | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ |
| **tinyimg** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **optout** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **resmush** | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

Table 2: **R** packages: supported formats.

In practice, **resmush** is designed for quick image optimization with
minimal setup, including support for online image files and formats such
as GIF, BMP and TIFF. Packages such as **tinyimg** may be a better fit
for fully local workflows focused on PNG and JPEG optimization and
fine-grained control over compression settings.

## References

Xie, Yihui. 2026a. *tinyimg: Optimize and Compress Images*.
<https://doi.org/10.32614/CRAN.package.tinyimg>.

Xie, Yihui. 2026b. *xfun: Supporting Functions for Packages Maintained
by Yihui Xie*. <https://github.com/yihui/xfun>.
