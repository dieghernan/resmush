# Optimize local image files

Optimize one or more local image files with the [reSmush.it
API](https://resmush.it/).

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

  Path or paths to local image files. The API can optimize `png`,
  `jpg/jpeg`, `gif`, `bmp` and `tiff` files.

- suffix:

  Character. Defaults to `"_resmush"`. By default, the optimized file is
  saved in the same directory as `file` with this suffix. For example,
  `example.png` becomes `example_resmush.png`. Values `""`, `NA` and
  `NULL` are equivalent to `overwrite = TRUE`.

- overwrite:

  Logical. Should the file in `file` be overwritten? If `TRUE` `suffix`
  is ignored.

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
Invisibly returns a data frame summarizing the process. With
`report = TRUE`, a summary report is also displayed in the console.

## See also

[reSmush.it API](https://resmush.it/api/) documentation.

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

# Copy to a temporary file for this example.
tmp_png <- tempfile(fileext = ".png")

file.copy(png_file, tmp_png, overwrite = TRUE)
#> [1] TRUE

resmush_file(tmp_png)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 file, total size 239.9 Kb.
#> ✔ Optimized 1 file: Size is now 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
#> Saved result in directory /tmp/RtmpY8Pwau.

# Several paths.
jpg_file <- system.file("extimg/example.jpg", package = "resmush")
tmp_jpg <- tempfile(fileext = ".jpg")

file.copy(jpg_file, tmp_jpg, overwrite = TRUE)
#> [1] TRUE

# Display a summary in the console.
summary <- resmush_file(c(tmp_png, tmp_jpg))
#> ●∙∙ Go! | ■■■■■■■■■■■■■■■■□□□□□□□□□□□□□□□   50% [1ms] | ETA:  0s (1/2 files)
#> ●∙∙ Go! | ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100% [2.4s] | ETA:  0s (2/2 files)
#> 
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 2 files, total size 340.2 Kb.
#> ✔ Optimized 2 files: Size is now 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
#> Saved results in directory /tmp/RtmpY8Pwau.

# The invisible data frame contains the same information.
summary
#>                                src_img
#> 1 /tmp/RtmpY8Pwau/file1af85f853475.png
#> 2 /tmp/RtmpY8Pwau/file1af86ea87872.jpg
#>                                       dest_img src_size dest_size
#> 1 /tmp/RtmpY8Pwau/file1af85f853475_resmush.png 239.9 Kb   70.7 Kb
#> 2 /tmp/RtmpY8Pwau/file1af86ea87872_resmush.jpg 100.4 Kb   83.2 Kb
#>   compress_ratio notes src_bytes dest_bytes
#> 1         70.54%    OK    245618      72356
#> 2         17.15%    OK    102796      85164

# Display the `png` output.
if (require("png", quietly = TRUE)) {
  my_png <- png::readPNG(summary$dest_img[1])
  grid::grid.raster(my_png)
}


# Use with `jpg` files and parameters.
resmush_file(tmp_jpg)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 file, total size 100.4 Kb.
#> ✔ Optimized 1 file: Size is now 83.2 Kb (was 100.4 Kb). Saved 17.2 Kb (17.15%).
#> Saved result in directory /tmp/RtmpY8Pwau.
resmush_file(tmp_jpg, qlty = 10)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 file, total size 100.4 Kb.
#> ✔ Optimized 1 file: Size is now 6.4 Kb (was 100.4 Kb). Saved 94 Kb (93.61%).
#> Saved result in directory /tmp/RtmpY8Pwau.
# }
```
