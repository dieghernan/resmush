# resmush 1.0.0

- Corrected typos.
- Migrated documentation to Quarto.
- Minimum **R** version required: 4.1.0.
- Updated the major version to indicate that the package has reached a mature
  development state.

# resmush 0.2.2

- API calls now perform a dry run to ensure that the compressed file exists.
- API calls now include
  `httr2::req_headers(referer = "https://dieghernan.github.io/resmush/")`.

# resmush 0.2.1

- Updated documentation.

# resmush 0.2.0

- Removed `webp` support because the API no longer supports that format.

# resmush 0.1.1

- Updated documentation.

# resmush 0.1.0

- Accepted on **CRAN**.
- Added DOI: <https://doi.org/10.5281/zenodo.10556679>.
- Added **png** and **grid** to `Suggests` for examples.
- Switched from the **httr** package to the **httr2** package.
- `resmush_clean_dir()` now shows a summary message.
- `resmush_dir()`, `resmush_file()` and `resmush_url()` gained the `overwrite`
  argument.
- `resmush_dir()`, `resmush_file()` and `resmush_url()` gained the `progress`
  and `report` arguments, which add new messages and progress bars using
  `cli::cli_progress_bar()`.
- `resmush_dir()`, `resmush_file()` and `resmush_url()` deprecated the `verbose`
  argument.

# resmush 0.0.1

- Initial version.
