# resmush (development version)

-   Minimum **R** version required is now 4.1.0.
-   Migrate documentation to Quarto (#28).

# resmush 0.2.2

-   Add `httr2::req_headers(referer = "https://dieghernan.github.io/resmush/")`
    on the corresponding calls.
-   API calls now perform a dry run to ensure that the compressed file exists.

# resmush 0.2.1

-   Update documentation.

# resmush 0.2.0

-   `webp` format is no longer supported by the API; removed from package.

# resmush 0.1.1

-   Update docs.

# resmush 0.1.0

-   Accepted on **CRAN**.
-   Now **resmush** uses **httr2** instead of **httr**.
-   Add DOI: <https://doi.org/10.5281/zenodo.10556679>.
-   `resmush_file()`, `resmush_dir()` and `resmush_url()` gain a new argument
    `overwrite`.
-   Changes in the API: New messages and use of progress bars with
    `cli::cli_progress_bar()`. These changes also affect the following:
    -   New arguments `progress` and `report`.
    -   Deprecated the `verbose` argument.
    -   `resmush_clean_dir()` shows messages with the summary of the process.
-   New packages on `Suggests` for examples: **png**, **grid**.

# resmush 0.0.1

-   Initial version.
