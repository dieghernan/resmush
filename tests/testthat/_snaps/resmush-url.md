# resmush_url() rejects unequal URL and output path lengths

    Code
      dm <- resmush_url(two_input, several_outputs)
    Condition
      Error in `resmush_url()`:
      ! `url` and `outfile` must have the same length. They have lengths 2 and 3, respectively.

