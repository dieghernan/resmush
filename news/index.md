# Changelog

## resmush 0.2.2

CRAN release: 2026-01-12

- Add
  `httr2::req_headers(referer = "https://dieghernan.github.io/resmush/" )`
  on the corresponding calls.
- API call now perform a dry run to ensure that the compressed file
  exists.

## resmush 0.2.1

CRAN release: 2024-12-18

- Update documentation.

## resmush 0.2.0

CRAN release: 2024-07-19

- `webp` format is not admitted any more by the API, remove from
  package.

## resmush 0.1.1

CRAN release: 2024-05-22

- Update docs.

## resmush 0.1.0

CRAN release: 2024-02-02

- Accepted on **CRAN**.
- Now **resmush** uses **httr2** instead of **httr**.
- Add DOI: <https://doi.org/10.5281/zenodo.10556679>.
- [`resmush_file()`](https://dieghernan.github.io/resmush/reference/resmush_file.md),
  [`resmush_dir()`](https://dieghernan.github.io/resmush/reference/resmush_dir.md)
  and
  [`resmush_url()`](https://dieghernan.github.io/resmush/reference/resmush_url.md)
  gain an new argument `overwrite`.
- Changes in the API: New messages and use of progress bars with
  [`cli::cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.html).
  These changes also affects the following:
  - New arguments `progress` and `report`.
  - Deprecated the `verbose` argument.
  - [`resmush_clean_dir()`](https://dieghernan.github.io/resmush/reference/resmush_clean_dir.md)
    shows messages with the summary of the process.
- New packages on `Suggests` for examples: **png**, **grid**.

## resmush 0.0.1

- Initial version.
