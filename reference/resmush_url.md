# Optimize online image files

Optimize and download one or more online image files with the
[reSmush.it API](https://resmush.it/api/). The API is free for personal
use and accepts files smaller than 5 MB.

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

  A character vector of URLs pointing to hosted image files. The API can
  optimize PNG, JPEG, GIF, BMP and TIFF files.

- outfile:

  A character vector of paths where optimized files are stored. By
  default, files are created in
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html) with the same
  [`basename()`](https://rdrr.io/r/base/basename.html) as each file in
  `url`. `outfile` must have the same length as `url`.

- overwrite:

  Logical. Should existing files in `outfile` be overwritten? If
  `FALSE`, existing paths are made unique with a numeric suffix, such as
  `example_01.png`.

- progress:

  Logical. Should a progress bar be displayed?

- report:

  Logical. Should a summary report be displayed in the console?

- qlty:

  An integer between `0` and `100` indicating the optimization level.
  This only affects JPEG files. For optimal results, use values above
  `90`.

- exif_preserve:

  Logical. Should [EXIF](https://en.wikipedia.org/wiki/Exif) metadata be
  preserved? The default is `FALSE`, which removes it.

## Value

A data frame with source and destination paths, file sizes, compression
ratios and status notes, returned invisibly. Successful API calls also
write the optimized files to disk. If `outfile` contains duplicate
paths, `resmush_url()` makes them unique with suffixes such as `_01` and
`_02`.

## See also

[reSmush.it API](https://resmush.it/api/) documentation.

Other image optimization functions:
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
#> ℹ Input: 1 URL, 239.9 Kb total.
#> ✔ Optimized 1 URL: size is now 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
#> Saved result in directory /tmp/Rtmp7FR69Y.

# Optimize multiple URLs.
jpg_url <- paste0(base_url, "/extimg/example.jpg")

summary <- resmush_url(c(png_url, jpg_url))
#> 🕐  reSmushing | ■■■■■■■■■■■■■■■■□□□□□□□□□□□□□□□   50% [1ms] | ETA:  0s (1/2 UR…
#> 🕐  reSmushing | ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100% [908ms] | ETA:  0s (2/2 …
#> 
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 2 URLs, 340.2 Kb total.
#> ✔ Optimized 2 URLs: size is now 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
#> Saved results in directory /tmp/Rtmp7FR69Y.

# Inspect the returned optimization summary.
summary
#>                                                                              src_img
#> 1 https://raw.githubusercontent.com/dieghernan/resmush/main/inst//extimg/example.png
#> 2 https://raw.githubusercontent.com/dieghernan/resmush/main/inst//extimg/example.jpg
#>                         dest_img src_size dest_size compress_ratio notes
#> 1 /tmp/Rtmp7FR69Y/example_01.png 239.9 Kb   70.7 Kb         70.54%    OK
#> 2    /tmp/Rtmp7FR69Y/example.jpg 100.4 Kb   83.2 Kb         17.15%    OK
#>   src_bytes dest_bytes
#> 1    245618      72356
#> 2    102796      85164

# Display the PNG output.
if (require("png", quietly = TRUE)) {
  my_png <- png::readPNG(summary$dest_img[1])
  grid::grid.raster(my_png)
}


# Adjust the optimization level for a JPEG file.
resmush_url(jpg_url)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 URL, 100.4 Kb total.
#> ✔ Optimized 1 URL: size is now 83.2 Kb (was 100.4 Kb). Saved 17.2 Kb (17.15%).
#> Saved result in directory /tmp/Rtmp7FR69Y.
resmush_url(jpg_url, qlty = 10)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 URL, 100.4 Kb total.
#> ✔ Optimized 1 URL: size is now 6.4 Kb (was 100.4 Kb). Saved 94 Kb (93.61%).
#> Saved result in directory /tmp/Rtmp7FR69Y.
# }
```
