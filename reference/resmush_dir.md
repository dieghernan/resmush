# Optimize files of several directories

Optimize all the local files of a directory (or list of directories)
using the [reSmush.it API](https://resmush.it/).

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

  Character or vector of characters representing paths of local
  directories.

- ext:

  [`regex`](https://rdrr.io/r/base/regex.html) indicating the extensions
  of the files to be optimized. The default value would capture all the
  extensions admitted by the API.

- suffix:

  Character, defaults to `"_resmush"`. By default, a new file with the
  suffix is created in the same directory (i.e., optimized `example.png`
  would be `example_resmush.png`). Values `""`, `NA` and `NULL` would be
  the same as `overwrite = TRUE`.

- overwrite:

  Logical. Should the files in `dir` be overwritten? If `TRUE` `suffix`
  would be ignored.

- progress:

  Logical. Display a progress bar when needed.

- report:

  Logical. Display a summary report of the process in the console. See
  also **Value**.

- recursive:

  Logical. Should the `dir` file search be recursive? See also
  [`list.files()`](https://rdrr.io/r/base/list.files.html).

- ...:

  Arguments passed on to
  [`resmush_file`](https://dieghernan.github.io/resmush/reference/resmush_file.md)

  `qlty`

  :   Only affects `jpg` files. Integer between `0` and `100` indicating
      the optimization level. For optimal results use values above `90`.

  `exif_preserve`

  :   Logical. Should the [Exif](https://en.wikipedia.org/wiki/Exif)
      information (if any) be deleted? Default is to remove it (i.e.
      `exif_preserve = FALSE`).

## Value

Writes on disk the optimized file if the API call is successful in the
directories specified in `dir`.

In all cases, an
([`invisible()`](https://rdrr.io/r/base/invisible.html)) data frame with
a summary of the process is returned as well.

## See also

[reSmush.it API](https://resmush.it/api/) docs.

See
[`resmush_clean_dir()`](https://dieghernan.github.io/resmush/reference/resmush_clean_dir.md)
to clean a directory of previous runs.

Other functions for optimizing:
[`resmush_file()`](https://dieghernan.github.io/resmush/reference/resmush_file.md),
[`resmush_url()`](https://dieghernan.github.io/resmush/reference/resmush_url.md)

## Examples

``` r
# \donttest{
# Get example dir and copy
example_dir <- system.file("extimg", package = "resmush")
temp_dir <- tempdir()
file.copy(example_dir, temp_dir, recursive = TRUE)
#> [1] TRUE

# Dest folder

dest_folder <- file.path(tempdir(), "extimg")


# Non-recursive
resmush_dir(dest_folder)
#> ℹ Resmushing 2 files
#> 🕐  Go! | ■■■■■■■■■■■■■■■■□□□□□□□□□□□□□□□   50% [3ms] | ETA:  0s (1/2 files)
#> 🕐  Go! | ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100% [1.5s] | ETA:  0s (2/2 files)
#> 
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 2 files with size 340.2 Kb
#> ✔ Success for 2 files: Size now is 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
#> See results in directory
#> C:/Users/RUNNER~1/AppData/Local/Temp/RtmpABQipV/extimg.
resmush_clean_dir(dest_folder)
#> ℹ Would remove 2 files:
#> → C:\Users\RUNNER~1\AppData\Local\Temp\RtmpABQipV/extimg/example_resmush.jpg
#> → C:\Users\RUNNER~1\AppData\Local\Temp\RtmpABQipV/extimg/example_resmush.png

# Recursive
summary <- resmush_dir(dest_folder, recursive = TRUE)
#> ℹ Resmushing 5 files
#> 🕐  Go! | ■■■■■■■■■■■■■□□□□□□□□□□□□□□□□□□   40% [746ms] | ETA:  1s (2/5 files)
#> 🕐  Go! | ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100% [2.6s] | ETA:  0s (5/5 files)
#> 
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 5 files with size 401.7 Kb
#> ✔ Success for 5 files: Size now is 173.5 Kb (was 401.7 Kb). Saved 228.2 Kb (56.81%).
#> See results in directories
#> C:/Users/RUNNER~1/AppData/Local/Temp/RtmpABQipV/extimg,
#> C:/Users/RUNNER~1/AppData/Local/Temp/RtmpABQipV/extimg/top1/nested,
#> C:/Users/RUNNER~1/AppData/Local/Temp/RtmpABQipV/extimg/top1, and
#> C:/Users/RUNNER~1/AppData/Local/Temp/RtmpABQipV/extimg/top2.

# Same info in the invisible df
summary[, -c(1, 2)]
#>   src_size dest_size compress_ratio notes src_bytes dest_bytes
#> 1 100.4 Kb   83.2 Kb         17.15%    OK    102796      85164
#> 2 239.9 Kb   70.7 Kb         70.54%    OK    245618      72356
#> 3  17.8 Kb      6 Kb         66.48%    OK     18214       6105
#> 4  25.9 Kb    7.7 Kb         70.09%    OK     26499       7926
#> 5  17.8 Kb      6 Kb         66.48%    OK     18214       6105

# Display with png
if (require("png", quietly = TRUE)) {
  a_png <- grepl("png$", summary$dest_img)
  my_png <- png::readPNG(summary[a_png, ]$dest_img[2])
  grid::grid.raster(my_png)
}


# Clean up example
unlink(dest_folder, force = TRUE, recursive = TRUE)
# }
```
