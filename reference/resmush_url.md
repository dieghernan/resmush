# Optimize an online file

Optimize and download an online image using the [reSmush.it
API](https://resmush.it/).

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

  URL or vector of URLs pointing to hosted image files. **reSmush** can
  optimize these image formats:

  - `png`

  - `jpg/jpeg`

  - `gif`

  - `bmp`

  - `tiff`

- outfile:

  Path or paths where optimized files are stored on disk. By default,
  temporary files (see
  [`tempfile()`](https://rdrr.io/r/base/tempfile.html)) with the same
  [`basename()`](https://rdrr.io/r/base/basename.html) as the file
  provided in `url` are created. It must have the same length as `url`.

- overwrite:

  Logical. Should `outfile` be overwritten if it already exists? If
  `FALSE` and `outfile` exists, a copy is created with a numerical
  suffix (i.e. `<outfile>.png`, `<outfile>_01.png`, etc.).

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
  information (if any) be preserved? The default is `FALSE` (i.e.,
  remove it).

## Value

Writes the optimized file to disk if the API call is successful. In all
cases, an [`invisible()`](https://rdrr.io/r/base/invisible.html) data
frame summarizing the process is returned as well.

If any value of the vector `outfile` is duplicated, `resmush_url()`
renames the output with a suffix `_01, _02`, etc.

## See also

[reSmush.it API](https://resmush.it/api/) docs.

Other functions for optimizing:
[`resmush_dir()`](https://dieghernan.github.io/resmush/reference/resmush_dir.md),
[`resmush_file()`](https://dieghernan.github.io/resmush/reference/resmush_file.md)

## Examples

``` r

# \donttest{

# Base URL
base_url <- "https://raw.githubusercontent.com/dieghernan/resmush/main/inst/"

png_url <- paste0(base_url, "/extimg/example.png")
resmush_url(png_url)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 url with size 239.9 Kb
#> ✔ Success for 1 url: Size now is 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
#> See result in directory /tmp/Rtmp4JfkxK.

# Several URLs
jpg_url <- paste0(base_url, "/extimg/example.jpg")

summary <- resmush_url(c(png_url, jpg_url))
#> 🕐  Go! | ■■■■■■■■■■■■■■■■□□□□□□□□□□□□□□□   50% [1ms] | ETA:  0s (1/2 urls)
#> 🕐  Go! | ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100% [981ms] | ETA:  0s (2/2 urls)
#> 
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 2 urls with size 340.2 Kb
#> ✔ Success for 2 urls: Size now is 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
#> See results in directory /tmp/Rtmp4JfkxK.

# Returns an (invisible) data frame with a summary of the process
summary
#>                                                                              src_img
#> 1 https://raw.githubusercontent.com/dieghernan/resmush/main/inst//extimg/example.png
#> 2 https://raw.githubusercontent.com/dieghernan/resmush/main/inst//extimg/example.jpg
#>                         dest_img src_size dest_size compress_ratio notes
#> 1 /tmp/Rtmp4JfkxK/example_01.png 239.9 Kb   70.7 Kb         70.54%    OK
#> 2    /tmp/Rtmp4JfkxK/example.jpg 100.4 Kb   83.2 Kb         17.15%    OK
#>   src_bytes dest_bytes
#> 1    245618      72356
#> 2    102796      85164

# Display the png output
if (require("png", quietly = TRUE)) {
  my_png <- png::readPNG(summary$dest_img[1])
  grid::grid.raster(my_png)
}


# Use with jpg and parameters
resmush_url(jpg_url)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 url with size 100.4 Kb
#> ✔ Success for 1 url: Size now is 83.2 Kb (was 100.4 Kb). Saved 17.2 Kb (17.15%).
#> See result in directory /tmp/Rtmp4JfkxK.
resmush_url(jpg_url, qlty = 10)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 url with size 100.4 Kb
#> ✔ Success for 1 url: Size now is 6.4 Kb (was 100.4 Kb). Saved 94 Kb (93.61%).
#> See result in directory /tmp/Rtmp4JfkxK.
# }
```
