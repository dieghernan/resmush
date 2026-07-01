# Changelog

## resmush (development version)

- Improved testing.

## resmush 1.0.1

CRAN release: 2026-05-29

- Improved console messages for optimization reports and file management
  helpers.
- Refactored internal code and updated function documentation with AI
  assistance.

## resmush 1.0.0

CRAN release: 2026-03-14

- Corrected typos.
- Migrated documentation to Quarto.
- Increased the minimum required **R** version to 4.1.0.
- Released version 1.0.0 to indicate that the package had reached a
  mature development state.

## resmush 0.2.2

CRAN release: 2026-01-12

- API downloads now perform a `HEAD` request to verify that the
  optimized file exists.
- API requests now include the package website as the HTTP referrer.

## resmush 0.2.1

CRAN release: 2024-12-18

- Updated documentation.

## resmush 0.2.0

CRAN release: 2024-07-19

- Removed WebP support because the API no longer supports that format.

## resmush 0.1.1

CRAN release: 2024-05-22

- Updated documentation.

## resmush 0.1.0

CRAN release: 2024-02-02

- Accepted on **CRAN**.
- Added the DOI <https://doi.org/10.5281/zenodo.10556679>.
- Added the **png** and **grid** packages to `Suggests` for examples.
- Switched from the **httr** package to the **httr2** package.
- [`resmush_clean_dir()`](https://dieghernan.github.io/resmush/dev/reference/resmush_clean_dir.md)
  now shows a summary message.
- [`resmush_dir()`](https://dieghernan.github.io/resmush/dev/reference/resmush_dir.md),
  [`resmush_file()`](https://dieghernan.github.io/resmush/dev/reference/resmush_file.md)
  and
  [`resmush_url()`](https://dieghernan.github.io/resmush/dev/reference/resmush_url.md)
  gained the `overwrite` argument.
- [`resmush_dir()`](https://dieghernan.github.io/resmush/dev/reference/resmush_dir.md),
  [`resmush_file()`](https://dieghernan.github.io/resmush/dev/reference/resmush_file.md)
  and
  [`resmush_url()`](https://dieghernan.github.io/resmush/dev/reference/resmush_url.md)
  gained the `progress` and `report` arguments. These add messages and
  progress bars using
  [`cli::cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.html).
- [`resmush_dir()`](https://dieghernan.github.io/resmush/dev/reference/resmush_dir.md),
  [`resmush_file()`](https://dieghernan.github.io/resmush/dev/reference/resmush_file.md)
  and
  [`resmush_url()`](https://dieghernan.github.io/resmush/dev/reference/resmush_url.md)
  deprecated the `verbose` argument.

## resmush 0.0.1

- Initial version.
