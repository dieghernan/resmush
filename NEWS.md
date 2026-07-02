# resmush 1.0.2

- Improved testing.

# resmush 1.0.1

- Improved console messages for optimization reports and file management
  helpers.
- Refactored internal code and updated function documentation with AI
  assistance.

# resmush 1.0.0

- Corrected typos.
- Migrated documentation to Quarto.
- Increased the minimum required **R** version to 4.1.0.
- Released version 1.0.0 to indicate that the package had reached a mature
  development state.

# resmush 0.2.2

- API downloads now perform a `HEAD` request to verify that the optimized file
  exists.
- API requests now include the package website as the HTTP referrer.

# resmush 0.2.1

- Updated documentation.

# resmush 0.2.0

- Removed WebP support because the API no longer supports that format.

# resmush 0.1.1

- Updated documentation.

# resmush 0.1.0

- Accepted on **CRAN**.
- Added the DOI <https://doi.org/10.5281/zenodo.10556679>.
- Added the **png** and **grid** packages to `Suggests` for examples.
- Switched from the **httr** package to the **httr2** package.
- `resmush_clean_dir()` now shows a summary message.
- `resmush_dir()`, `resmush_file()` and `resmush_url()` gained the `overwrite`
  argument.
- `resmush_dir()`, `resmush_file()` and `resmush_url()` gained the `progress`
  and `report` arguments. These add messages and progress bars using
  `cli::cli_progress_bar()`.
- `resmush_dir()`, `resmush_file()` and `resmush_url()` deprecated the `verbose`
  argument.

# resmush 0.0.1

- Initial version.
