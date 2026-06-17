# Optimize online image files

Optimize and download one or more online image files with the
[reSmush.it API](https://resmush.it/).

## Usage

``` r
resmush_url(
  url,
  outfile = file.path(tempdir(), basename(url)),
  overwrite = FALSE,
  progress = TRUE,
  report = TRUE,
  qlty = 92,
  exif_preserve = FALSE
)
```

## Arguments

- url:

  URL or vector of URLs pointing to hosted image files. The API can
  optimize `png`, `jpg/jpeg`, `gif`, `bmp` and `tiff` files.

- outfile:

  Path or paths where optimized files are stored on disk. By default,
  temporary files are created with
  [`tempfile()`](https://rdrr.io/r/base/tempfile.html) and the same
  [`basename()`](https://rdrr.io/r/base/basename.html) as the file
  provided in `url`. `outfile` must have the same length as `url`.

- overwrite:

  Logical. Should `outfile` be overwritten if it already exists? If
  `FALSE` and `outfile` exists, a copy is created with a numerical
  suffix, such as `<outfile>_01.png`.

- progress:

  Logical. Should a progress bar be displayed?

- report:

  Logical. Should a summary report be displayed in the console?

- qlty:

  Integer between `0` and `100` indicating the optimization level. This
  only affects `jpg` files. For optimal results, use values above `90`.

- exif_preserve:

  Logical. Should [Exif](https://en.wikipedia.org/wiki/Exif) metadata be
  preserved? The default is `FALSE`, which removes it.

## Value

Writes optimized files to disk when the API call is successful.
Invisibly returns a data frame summarizing the process. If any value in
`outfile` is duplicated, `resmush_url()` renames the outputs with
suffixes such as `_01` and `_02`.

## See also

[reSmush.it API](https://resmush.it/api/) documentation.

Other functions for optimizing:
[`resmush_dir()`](https://dieghernan.github.io/resmush/reference/resmush_dir.md),
[`resmush_file()`](https://dieghernan.github.io/resmush/reference/resmush_file.md)

## Examples

``` r

# \donttest{
# Base URL.
base_url <- "https://raw.githubusercontent.com/dieghernan/resmush/main/inst/"

png_url <- paste0(base_url, "/extimg/example.png")
resmush_url(png_url)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 URL, total size 239.9 Kb.
#> ✔ Optimized 1 URL: Size is now 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
#> Saved result in directory /tmp/Rtmp6N5z2E.

# Several URLs.
jpg_url <- paste0(base_url, "/extimg/example.jpg")

summary <- resmush_url(c(png_url, jpg_url))
#> ●∙∙ Go! | ■■■■■■■■■■■■■■■■□□□□□□□□□□□□□□□   50% [1ms] | ETA:  0s (1/2 URLs)
#> ●∙∙ Go! | ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100% [1.1s] | ETA:  0s (2/2 URLs)
#> 
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 2 URLs, total size 340.2 Kb.
#> ✔ Optimized 2 URLs: Size is now 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
#> Saved results in directory /tmp/Rtmp6N5z2E.

# The invisible data frame contains a summary of the process.
summary
#>                                                                              src_img
#> 1 https://raw.githubusercontent.com/dieghernan/resmush/main/inst//extimg/example.png
#> 2 https://raw.githubusercontent.com/dieghernan/resmush/main/inst//extimg/example.jpg
#>                         dest_img src_size dest_size compress_ratio notes
#> 1 /tmp/Rtmp6N5z2E/example_01.png 239.9 Kb   70.7 Kb         70.54%    OK
#> 2    /tmp/Rtmp6N5z2E/example.jpg 100.4 Kb   83.2 Kb         17.15%    OK
#>   src_bytes dest_bytes
#> 1    245618      72356
#> 2    102796      85164

# Display the `png` output.
if (require("png", quietly = TRUE)) {
  my_png <- png::readPNG(summary$dest_img[1])
  grid::grid.raster(my_png)
}


# Use with `jpg` files and parameters.
resmush_url(jpg_url)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 URL, total size 100.4 Kb.
#> ✔ Optimized 1 URL: Size is now 83.2 Kb (was 100.4 Kb). Saved 17.2 Kb (17.15%).
#> Saved result in directory /tmp/Rtmp6N5z2E.
resmush_url(jpg_url, qlty = 10)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 URL, total size 100.4 Kb.
#> ✔ Optimized 1 URL: Size is now 6.4 Kb (was 100.4 Kb). Saved 94 Kb (93.61%).
#> Saved result in directory /tmp/Rtmp6N5z2E.
# }
```
