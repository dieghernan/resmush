# Changelog

## resmush 1.0.0

CRAN release: 2026-03-14

- Bumped the major version to indicate the package has reached a mature
  development state.
- Minimum R version required: 4.1.0.
- Migrated documentation to Quarto.
- Corrected typos.

## resmush 0.2.2

CRAN release: 2026-01-12

- Add
  `httr2::req_headers(referer = "https://dieghernan.github.io/resmush/")`
  to the relevant API calls.
- API calls now perform a dry run to ensure the compressed file exists.

## resmush 0.2.1

CRAN release: 2024-12-18

- Update documentation.

## resmush 0.2.0

CRAN release: 2024-07-19

- `webp` format is no longer supported by the API and was removed from
  the package.

## resmush 0.1.1

CRAN release: 2024-05-22

- Update documentation.

## resmush 0.1.0

CRAN release: 2024-02-02

- Accepted on **CRAN**.
- Switched from `httr` to `httr2`.
- Added DOI: <https://doi.org/10.5281/zenodo.10556679>.
- [`resmush_file()`](https://dieghernan.github.io/resmush/reference/resmush_file.md),
  [`resmush_dir()`](https://dieghernan.github.io/resmush/reference/resmush_dir.md),
  and
  [`resmush_url()`](https://dieghernan.github.io/resmush/reference/resmush_url.md)
  gain a new `overwrite` argument.
- API changes: new messages and progress bars using
  [`cli::cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.html).
  These changes also include:
  - New arguments `progress` and `report`.
  - Deprecation of the `verbose` argument.
  - [`resmush_clean_dir()`](https://dieghernan.github.io/resmush/reference/resmush_clean_dir.md)
    now shows a summary message.
- Added `png` and `grid` to `Suggests` for examples.

## resmush 0.0.1

- Initial version.
