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

  url or a vector of urls pointing to hosted image files. **reSmush**
  can optimize the following image files:

  - `png`

  - `jpg/jpeg`

  - `gif`

  - `bmp`

  - `tiff`

- outfile:

  Path or paths where the optimized files would be store in your disk.
  By default, temporary files (see
  [`tempfile()`](https://rdrr.io/r/base/tempfile.html)) with the same
  [`basename()`](https://rdrr.io/r/base/basename.html) than the file
  provided in `url` would be created. It should be of the same length
  than `url` parameter.

- overwrite:

  Logical. Should `outfile` be overwritten (if already exists)? If
  `FALSE` and `outfile` exists it would create a copy with a numerical
  suffix (i.e. `<outfile>.png`, `<outfile>_01.png`, etc.).

- progress:

  Logical. Display a progress bar when needed.

- report:

  Logical. Display a summary report of the process in the console. See
  also **Value**.

- qlty:

  Only affects `jpg` files. Integer between 0 and 100 indicating the
  optimization level. For optimal results use vales above 90.

- exif_preserve:

  Logical. Should the [Exif](https://en.wikipedia.org/wiki/Exif)
  information (if any) deleted? Default is to remove it (i.e.
  `exif_preserve = FALSE`).

## Value

Writes on disk the optimized file if the API call is successful. In all
cases, a (invisible) data frame with a summary of the process is
returned as well.

If any value of the vector `outfile` is duplicated, `resmush_url()`
would rename the output with a suffix `_01. _02`, etc.

## See also

[reSmush.it API](https://resmush.it/api/) docs.

Other functions for optimizing:
[`resmush_dir()`](https://dieghernan.github.io/resmush/reference/resmush_dir.md),
[`resmush_file()`](https://dieghernan.github.io/resmush/reference/resmush_file.md)

## Examples

``` r
# \donttest{

# Base url
base_url <- "https://raw.githubusercontent.com/dieghernan/resmush/main/inst/"

png_url <- paste0(base_url, "/extimg/example.png")
resmush_url(png_url)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 url with size 239.9 Kb
#> ✔ Success for 1 url: Size now is 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
#> See result in directory C:/Users/RUNNER~1/AppData/Local/Temp/Rtmpcx4sL0.

# Several urls
jpg_url <- paste0(base_url, "/extimg/example.jpg")


summary <- resmush_url(c(png_url, jpg_url))
#> 🕐  Go! | ■■■■■■■■■■■■■■■■□□□□□□□□□□□□□□□   50% [2ms] | ETA:  0s (1/2 urls)
#> 🕐  Go! | ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100% [831ms] | ETA:  0s (2/2 urls)
#> 
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 2 urls with size 340.2 Kb
#> ✔ Success for 2 urls: Size now is 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
#> See results in directory C:/Users/RUNNER~1/AppData/Local/Temp/Rtmpcx4sL0.

# Returns an (invisible) data frame with a summary of the process
summary
#>                                                                              src_img
#> 1 https://raw.githubusercontent.com/dieghernan/resmush/main/inst//extimg/example.png
#> 2 https://raw.githubusercontent.com/dieghernan/resmush/main/inst//extimg/example.jpg
#>                                                               dest_img src_size
#> 1 C:\\Users\\RUNNER~1\\AppData\\Local\\Temp\\Rtmpcx4sL0/example_01.png 239.9 Kb
#> 2    C:\\Users\\RUNNER~1\\AppData\\Local\\Temp\\Rtmpcx4sL0/example.jpg 100.4 Kb
#>   dest_size compress_ratio notes src_bytes dest_bytes
#> 1   70.7 Kb         70.54%    OK    245618      72356
#> 2   83.2 Kb         17.15%    OK    102796      85164

# Display with png
if (require("png", quietly = TRUE)) {
  my_png <- png::readPNG(summary$dest_img[1])
  grid::grid.raster(my_png)
}


# Use with jpg and parameters
resmush_url(jpg_url)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 url with size 100.4 Kb
#> ✔ Success for 1 url: Size now is 83.2 Kb (was 100.4 Kb). Saved 17.2 Kb (17.15%).
#> See result in directory C:/Users/RUNNER~1/AppData/Local/Temp/Rtmpcx4sL0.
resmush_url(jpg_url, qlty = 10)
#> ══ resmush summary ═════════════════════════════════════════════════════════════
#> ℹ Input: 1 url with size 100.4 Kb
#> ✔ Success for 1 url: Size now is 6.4 Kb (was 100.4 Kb). Saved 94 Kb (93.61%).
#> See result in directory C:/Users/RUNNER~1/AppData/Local/Temp/Rtmpcx4sL0.
# }
```
