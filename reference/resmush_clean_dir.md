# Clean files created by [resmush](https://CRAN.R-project.org/package=resmush)

**Use with caution.** This removes files from your computer.

Clean a directory (or a list of directories) of files created by
[`resmush_file()`](https://dieghernan.github.io/resmush/reference/resmush_file.md).

## Usage

``` r
resmush_clean_dir(dir, suffix = "_resmush", recursive = FALSE)
```

## Arguments

- dir:

  A character vector of full path names. See the `path` argument in
  [`list.files()`](https://rdrr.io/r/base/list.files.html).

- suffix:

  Character, defaults to `"_resmush"`. See
  [`resmush_file()`](https://dieghernan.github.io/resmush/reference/resmush_file.md).

- recursive:

  Logical. Should the file search recurse into directories?

## Value

Returns an [`invisible()`](https://rdrr.io/r/base/invisible.html) `NULL`
value and produces messages summarizing the process.

## See also

[`resmush_file()`](https://dieghernan.github.io/resmush/reference/resmush_file.md),
[`resmush_dir()`](https://dieghernan.github.io/resmush/reference/resmush_dir.md),
[`list.files()`](https://rdrr.io/r/base/list.files.html),
[`unlink()`](https://rdrr.io/r/base/unlink.html).

## Examples

``` r
# \donttest{
# Simple example.

png_file <- system.file("extimg/example.png", package = "resmush")

# Copy to a temporary file with a given suffix.
suffix <- "_would_be_removed"
tmp_png <- file.path(
  tempdir(),
  paste0("example", suffix, ".png")
)

file.exists(tmp_png)
#> [1] FALSE
file.copy(png_file, tmp_png, overwrite = TRUE)
#> [1] TRUE

file.exists(tmp_png)
#> [1] TRUE

# Run with the default suffix; this should not remove the file.
resmush_clean_dir(tempdir())
#> ℹ No files to clean in /tmp/RtmpaBc3ne with suffix "_resmush\\.".

file.exists(tmp_png)
#> [1] TRUE

# Use the matching suffix to remove the file.
resmush_clean_dir(tempdir(), suffix = suffix)
#> ℹ Would remove 1 file:
#> → /tmp/RtmpaBc3ne/example_would_be_removed.png

file.exists(tmp_png)
#> [1] FALSE
# }
```
