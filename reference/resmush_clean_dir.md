# Helper function for cleaning files created by [resmush](https://CRAN.R-project.org/package=resmush)

**Use with caution**. This would remove files from your computer.

Clean a directory (or a list of directories) of files created by
[`resmush_file()`](https://dieghernan.github.io/resmush/reference/resmush_file.md).

## Usage

``` r
resmush_clean_dir(dir, suffix = "_resmush", recursive = FALSE)
```

## Arguments

- dir:

  A character vector of full path names. See
  [`list.files()`](https://rdrr.io/r/base/list.files.html), `path`
  argument.

- suffix:

  Character, defaults to `"_resmush"`. See
  [`resmush_file()`](https://dieghernan.github.io/resmush/reference/resmush_file.md).

- recursive:

  Logical. Should the file search recurse into directories?

## Value

An [`invisible()`](https://rdrr.io/r/base/invisible.html) `NULL` value.
Produces messages with information of the process.

## See also

[`resmush_file()`](https://dieghernan.github.io/resmush/reference/resmush_file.md),
[`resmush_dir()`](https://dieghernan.github.io/resmush/reference/resmush_dir.md),
[`list.files()`](https://rdrr.io/r/base/list.files.html),
[`unlink()`](https://rdrr.io/r/base/unlink.html)

## Examples

``` r
# \donttest{
# Simple example

png_file <- system.file("extimg/example.png", package = "resmush")

# Copy to a temporary file with a given suffix
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

# This won't remove it
resmush_clean_dir(tempdir())
#> ℹ No files to clean in /tmp/RtmpZt3YBf with suffix "_resmush\\.".

file.exists(tmp_png)
#> [1] TRUE

# Need suffix
resmush_clean_dir(tempdir(), suffix = suffix)
#> ℹ Would remove 1 file:
#> → /tmp/RtmpZt3YBf/example_would_be_removed.png

file.exists(tmp_png)
#> [1] FALSE
# }
```
