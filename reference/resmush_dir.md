# Optimize image files in directories

Optimize supported image files in one or more directories with the
[reSmush.it API](https://resmush.it/api/). The API is free for personal
use and accepts files smaller than 5 MB.

## Usage

``` r
resmush_dir(
  dir,
  ext = "\\.(png|jpe?g|bmp|gif|tif)$",
  suffix = "_resmush",
  overwrite = FALSE,
  progress = TRUE,
  report = TRUE,
  recursive = FALSE,
  ...
)
```

## Arguments

- dir:

  A character vector of paths to local directories.

- ext:

  A [`regex`](https://rdrr.io/r/base/regex.html) matching file
  extensions to optimize. The default matches lowercase `.png`, `.jpg`,
  `.jpeg`, `.gif`, `.bmp` and `.tif` extensions.

- suffix:

  A character string inserted before each output file extension. The
  default is `"_resmush"`. Therefore, `example.png` becomes
  `example_resmush.png`. Values `""`, `NA` and `NULL` are equivalent to
  `overwrite = TRUE`.

- overwrite:

  Logical. Should the input files be overwritten? If `TRUE`, `suffix` is
  ignored.

- progress:

  Logical. Should a progress bar be displayed?

- report:

  Logical. Should a summary report be displayed in the console?

- recursive:

  Logical. Should the file search within each directory in `dir` be
  recursive? See
  [`base::list.files()`](https://rdrr.io/r/base/list.files.html).

- ...:

  Arguments passed on to
  [`resmush_file`](https://dieghernan.github.io/resmush/reference/resmush_file.md)

  `qlty`

  :   An integer between `0` and `100` indicating the JPEG quality
      level. For best results, use values above `90`. This argument only
      affects JPEG files.

  `exif_preserve`

  :   Logical. Should [EXIF](https://en.wikipedia.org/wiki/Exif)
      metadata be preserved? The default is `FALSE`, which removes it.

## Value

An invisibly returned [data
frame](https://rdrr.io/r/base/data.frame.html) with one row per result
and columns containing source and destination paths, formatted file
sizes, file sizes in bytes, compression ratios and status notes. Returns
[`NULL`](https://rdrr.io/r/base/NULL.html) if no result is available.
Successful API calls also write the optimized files to disk. If
`report = TRUE`, a summary is displayed in the console.

## See also

[`resmush_clean_dir()`](https://dieghernan.github.io/resmush/reference/resmush_clean_dir.md)
removes output files created by previous runs. The [reSmush.it API
documentation](https://resmush.it/api/) describes the external service.

Other image optimization functions:
[`resmush_file()`](https://dieghernan.github.io/resmush/reference/resmush_file.md),
[`resmush_url()`](https://dieghernan.github.io/resmush/reference/resmush_url.md)

## Examples

``` r
# \donttest{
# Copy the example directory.
example_dir <- system.file("extimg", package = "resmush")
temp_dir <- tempdir()
file.copy(example_dir, temp_dir, recursive = TRUE)
#> [1] TRUE

# Create the destination directory path.
dest_folder <- file.path(tempdir(), "extimg")

# Optimize files non-recursively.
resmush_dir(dest_folder)
#> ℹ Optimizing 2 files.
#> 🕐  reSmushing | ■■■■■■■■■■■■■■■■□□□□□□□□□□□□□□□   50% [2ms] | ETA:  0s (1/2 fi…
#> 🕐  reSmushing | ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100% [1.9s] | ETA:  0s (2/2 f…
#> 
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 2 files, 340.2 Kb total.
#> ✔ Optimized 2 files: size is now 159.2 Kb (was 340.2 Kb). Saved 181 Kb (53.20%).
#> Saved results in directory /tmp/RtmpMqTm1O/extimg.
resmush_clean_dir(dest_folder)
#> ℹ Removing 2 files:
#> → /tmp/RtmpMqTm1O/extimg/example_resmush.jpg
#> → /tmp/RtmpMqTm1O/extimg/example_resmush.png

# Optimize files recursively.
summary <- resmush_dir(dest_folder, recursive = TRUE)
#> ℹ Optimizing 5 files.
#> 🕐  reSmushing | ■■■■■■■□□□□□□□□□□□□□□□□□□□□□□□□   20% [1ms] | ETA:  0s (1/5 fi…
#> 🕑  reSmushing | ■■■■■■■■■■■■■■■■■■■□□□□□□□□□□□□   60% [3.3s] | ETA:  2s (3/5 f…
#> 🕑  reSmushing | ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100% [4.9s] | ETA:  0s (5/5 f…
#> 
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 5 files, 401.7 Kb total.
#> ✔ Optimized 5 files: size is now 179.6 Kb (was 401.7 Kb). Saved 222.1 Kb (55.30%).
#> Saved results in directories /tmp/RtmpMqTm1O/extimg,
#> /tmp/RtmpMqTm1O/extimg/top1/nested, /tmp/RtmpMqTm1O/extimg/top1, and
#> /tmp/RtmpMqTm1O/extimg/top2.

# Inspect the returned optimization summary.
summary[, -c(1, 2)]
#>   src_size dest_size compress_ratio notes src_bytes dest_bytes
#> 1 100.4 Kb   83.2 Kb         17.15%    OK    102796      85164
#> 2 239.9 Kb   76.1 Kb         68.29%    OK    245618      77896
#> 3  17.8 Kb      6 Kb         66.48%    OK     18214       6105
#> 4  25.9 Kb    8.4 Kb         67.53%    OK     26499       8605
#> 5  17.8 Kb      6 Kb         66.48%    OK     18214       6105

# Display the PNG output.
if (require("png", quietly = TRUE)) {
  a_png <- grepl("png$", summary$dest_img)
  my_png <- png::readPNG(summary[a_png, ]$dest_img[2])
  grid::grid.raster(my_png)
}


# Clean up the example files.
unlink(dest_folder, force = TRUE, recursive = TRUE)
# }
```
