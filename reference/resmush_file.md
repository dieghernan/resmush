# Optimize a local file

Optimize local images using the [reSmush.it API](https://resmush.it/).

## Usage

``` r
resmush_file(
  file,
  suffix = "_resmush",
  overwrite = FALSE,
  progress = TRUE,
  report = TRUE,
  qlty = 92,
  exif_preserve = FALSE
)
```

## Arguments

- file:

  Path or paths to local files. **reSmush** can optimize the following
  image files:

  - `png`

  - `jpg/jpeg`

  - `gif`

  - `bmp`

  - `tiff`

- suffix:

  Character, defaults to `"_resmush"`. By default, a new file with this
  `suffix` is created in the same directory as `file`. (i.e., optimized
  `example.png` would be `example_resmush.png`). Values `""`, `NA` and
  `NULL` would be the same as `overwrite = TRUE`.

- overwrite:

  Logical. Should the file in `file` be overwritten? If `TRUE` `suffix`
  would be ignored.

- progress:

  Logical. Display a progress bar when needed.

- report:

  Logical. Display a summary report of the process in the console. See
  also **Value**.

- qlty:

  Only affects `jpg` files. Integer between `0` and `100` indicating the
  optimization level. For optimal results use values above `90`.

- exif_preserve:

  Logical. Should the [Exif](https://en.wikipedia.org/wiki/Exif)
  information (if any) be deleted? Default is to remove it (i.e.
  `exif_preserve = FALSE`).

## Value

Writes on disk the optimized file if the API call is successful in the
same directory as `file`.

With the option `report = TRUE` a summary report is displayed in the
console. In all cases, an
([`invisible()`](https://rdrr.io/r/base/invisible.html)) data frame with
a summary of the process used to generate the report is returned.

## See also

[reSmush.it API](https://resmush.it/api/) docs.

See
[`resmush_clean_dir()`](https://dieghernan.github.io/resmush/reference/resmush_clean_dir.md)
to clean a directory of previous runs.

Other functions for optimizing:
[`resmush_dir()`](https://dieghernan.github.io/resmush/reference/resmush_dir.md),
[`resmush_url()`](https://dieghernan.github.io/resmush/reference/resmush_url.md)

## Examples

``` r
# \donttest{
png_file <- system.file("extimg/example.png", package = "resmush")

# For the example, copy to a temporary file
tmp_png <- tempfile(fileext = ".png")

file.copy(png_file, tmp_png, overwrite = TRUE)
#> [1] TRUE

resmush_file(tmp_png)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 file with size 239.9 Kb
#> ✔ Success for 1 file: Size now is 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
#> See result in directory /tmp/Rtmp9uaUYV.

# Several paths
jpg_file <- system.file("extimg/example.jpg", package = "resmush")
tmp_jpg <- tempfile(fileext = ".jpg")

file.copy(jpg_file, tmp_jpg, overwrite = TRUE)
#> [1] TRUE

# Output summary in console
summary <- resmush_file(c(tmp_png, tmp_jpg))
#> 🕐  Go! | ■■■■■■■■■■■■■■■■□□□□□□□□□□□□□□□   50% [1ms] | ETA:  0s (1/2 files)
#> 🕐  Go! | ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100% [1.1s] | ETA:  0s (2/2 files)
#> 
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 2 files with size 340.2 Kb
#> ✔ Success for 2 files: Size now is 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
#> See results in directory /tmp/Rtmp9uaUYV.

# Similar info in an (invisible) data frame as a result
summary
#>                                src_img
#> 1 /tmp/Rtmp9uaUYV/file1cd52bba98dd.png
#> 2 /tmp/Rtmp9uaUYV/file1cd5429148d1.jpg
#>                                       dest_img src_size dest_size
#> 1 /tmp/Rtmp9uaUYV/file1cd52bba98dd_resmush.png 239.9 Kb   70.7 Kb
#> 2 /tmp/Rtmp9uaUYV/file1cd5429148d1_resmush.jpg 100.4 Kb   83.2 Kb
#>   compress_ratio notes src_bytes dest_bytes
#> 1         70.54%    OK    245618      72356
#> 2         17.15%    OK    102796      85164

# Display with png
if (require("png", quietly = TRUE)) {
  my_png <- png::readPNG(summary$dest_img[1])
  grid::grid.raster(my_png)
}


# With parameters
resmush_file(tmp_jpg)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 file with size 100.4 Kb
#> ✔ Success for 1 file: Size now is 83.2 Kb (was 100.4 Kb). Saved 17.2 Kb (17.15%).
#> See result in directory /tmp/Rtmp9uaUYV.
resmush_file(tmp_jpg, qlty = 10)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 file with size 100.4 Kb
#> ✔ Success for 1 file: Size now is 6.4 Kb (was 100.4 Kb). Saved 94 Kb (93.61%).
#> See result in directory /tmp/Rtmp9uaUYV.
# }
```
