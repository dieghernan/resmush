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

  A character vector of paths to local image files. The API can optimize
  PNG, JPEG, GIF, BMP and TIFF files.

- suffix:

  A character string appended to output file names. The default is
  `"_resmush"`, so `example.png` becomes `example_resmush.png`. Values
  `""`, `NA` and `NULL` are equivalent to `overwrite = TRUE`.

- overwrite:

  Logical. Should the file in `file` be overwritten? If `TRUE` `suffix`
  is ignored.

- progress:

  Logical. Should a progress bar be displayed?

- report:

  Logical. Should a summary report be displayed in the console?

- qlty:

  An integer between `0` and `100` indicating the optimization level.
  This only affects JPEG files. For optimal results, use values above
  `90`.

- exif_preserve:

  Logical. Should [Exif](https://en.wikipedia.org/wiki/Exif) metadata be
  preserved? The default is `FALSE`, which removes it.

## Value

A data frame summarizing the optimization, returned invisibly.
Successful API calls also write the optimized files to disk. If
`report = TRUE`, a summary is displayed in the console.

## See also

[reSmush.it API](https://resmush.it/api/) documentation.

See
[`resmush_clean_dir()`](https://dieghernan.github.io/resmush/reference/resmush_clean_dir.md)
to clean a directory of previous runs.

Other image optimization functions:
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
#> ℹ Input: 1 file, 239.9 Kb total.
#> ✔ Optimized 1 file: size is now 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
#> Saved result in directory /tmp/RtmpHJeQ8p.

# Several paths.
jpg_file <- system.file("extimg/example.jpg", package = "resmush")
tmp_jpg <- tempfile(fileext = ".jpg")

file.copy(jpg_file, tmp_jpg, overwrite = TRUE)
#> [1] TRUE

# Display a summary in the console.
summary <- resmush_file(c(tmp_png, tmp_jpg))
#> ●∙∙ Go! | ■■■■■■■■■■■■■■■■□□□□□□□□□□□□□□□   50% [1ms] | ETA:  0s (1/2 files)
#> ●∙∙ Go! | ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100% [975ms] | ETA:  0s (2/2 files)
#> 
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 2 files, 340.2 Kb total.
#> ✔ Optimized 2 files: size is now 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
#> Saved results in directory /tmp/RtmpHJeQ8p.

# The invisible data frame contains the same information.
summary
#>                                src_img
#> 1 /tmp/RtmpHJeQ8p/file1b78170dc66a.png
#> 2 /tmp/RtmpHJeQ8p/file1b7866111935.jpg
#>                                       dest_img src_size dest_size
#> 1 /tmp/RtmpHJeQ8p/file1b78170dc66a_resmush.png 239.9 Kb   70.7 Kb
#> 2 /tmp/RtmpHJeQ8p/file1b7866111935_resmush.jpg 100.4 Kb   83.2 Kb
#>   compress_ratio notes src_bytes dest_bytes
#> 1         70.54%    OK    245618      72356
#> 2         17.15%    OK    102796      85164

# Display the PNG output.
if (require("png", quietly = TRUE)) {
  my_png <- png::readPNG(summary$dest_img[1])
  grid::grid.raster(my_png)
}


# Use with JPEG files and parameters.
resmush_file(tmp_jpg)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 file, 100.4 Kb total.
#> ✔ Optimized 1 file: size is now 83.2 Kb (was 100.4 Kb). Saved 17.2 Kb (17.15%).
#> Saved result in directory /tmp/RtmpHJeQ8p.
resmush_file(tmp_jpg, qlty = 10)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 file, 100.4 Kb total.
#> ✔ Optimized 1 file: size is now 6.4 Kb (was 100.4 Kb). Saved 94 Kb (93.61%).
#> Saved result in directory /tmp/RtmpHJeQ8p.
# }
```
