# Optimize local files in directories

Optimize all local files in a directory (or list of directories) using
the [reSmush.it API](https://resmush.it/).

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

  A [`regex`](https://rdrr.io/r/base/regex.html) indicating the
  extensions of the files to optimize. The default value captures all
  extensions supported by the API.

- suffix:

  Character. Defaults to `"_resmush"`. By default, a new file with the
  suffix is created in the same directory (i.e., optimized `example.png`
  becomes `example_resmush.png`). Values `""`, `NA` and `NULL` are
  equivalent to `overwrite = TRUE`.

- overwrite:

  Logical. Should the files in `dir` be overwritten? If `TRUE` `suffix`
  is ignored.

- progress:

  Logical. Display a progress bar when needed.

- report:

  Logical. Display a summary report of the process in the console. See
  also **Value**.

- recursive:

  Logical. Should file search within `dir` be recursive? See also
  [`list.files()`](https://rdrr.io/r/base/list.files.html).

- ...:

  Arguments passed on to
  [`resmush_file`](https://dieghernan.github.io/resmush/reference/resmush_file.md)

  `qlty`

  :   Only affects `jpg` files. An integer between `0` and `100`
      indicating the optimization level. For optimal results, use values
      above `90`.

  `exif_preserve`

  :   Logical. Should the [Exif](https://en.wikipedia.org/wiki/Exif)
      information (if any) be preserved? The default is `FALSE` (i.e.,
      remove it).

## Value

Writes optimized files to disk in the directories specified in `dir` if
the API call is successful.

In all cases, an [`invisible()`](https://rdrr.io/r/base/invisible.html)
data frame summarizing the process is returned as well.

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
# Copy the example directory.
example_dir <- system.file("extimg", package = "resmush")
temp_dir <- tempdir()
file.copy(example_dir, temp_dir, recursive = TRUE)
#> [1] TRUE

# Create the destination folder path.
dest_folder <- file.path(tempdir(), "extimg")

# Non-recursive.
resmush_dir(dest_folder)
#> ℹ Resmushing 2 files
#> 🕐  Go! | ■■■■■■■■■■■■■■■■□□□□□□□□□□□□□□□   50% [2ms] | ETA:  0s (1/2 files)
#> 🕐  Go! | ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100% [2.2s] | ETA:  0s (2/2 files)
#> 
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 2 files with size 340.2 Kb
#> ✔ Success for 2 files: Size is now 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
#> See results in directory /tmp/RtmpmiQt8u/extimg.
resmush_clean_dir(dest_folder)
#> ℹ Would remove 2 files:
#> → /tmp/RtmpmiQt8u/extimg/example_resmush.jpg
#> → /tmp/RtmpmiQt8u/extimg/example_resmush.png

# Recursive.
summary <- resmush_dir(dest_folder, recursive = TRUE)
#> ℹ Resmushing 5 files
#> 🕐  Go! | ■■■■■■■■■■■■■□□□□□□□□□□□□□□□□□□   40% [1.4s] | ETA:  2s (2/5 files)
#> 🕑  Go! | ■■■■■■■■■■■■■■■■■■■□□□□□□□□□□□□   60% [3.2s] | ETA:  2s (3/5 files)
#> 🕑  Go! | ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100% [4.5s] | ETA:  0s (5/5 files)
#> 
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 5 files with size 401.7 Kb
#> ✔ Success for 5 files: Size is now 173.5 Kb (was 401.7 Kb). Saved 228.2 Kb (56.81%).
#> See results in directories /tmp/RtmpmiQt8u/extimg,
#> /tmp/RtmpmiQt8u/extimg/top1/nested, /tmp/RtmpmiQt8u/extimg/top1, and
#> /tmp/RtmpmiQt8u/extimg/top2.

# Return the same information in the invisible data frame.
summary[, -c(1, 2)]
#>   src_size dest_size compress_ratio notes src_bytes dest_bytes
#> 1 100.4 Kb   83.2 Kb         17.15%    OK    102796      85164
#> 2 239.9 Kb   70.7 Kb         70.54%    OK    245618      72356
#> 3  17.8 Kb      6 Kb         66.48%    OK     18214       6105
#> 4  25.9 Kb    7.7 Kb         70.09%    OK     26499       7926
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
