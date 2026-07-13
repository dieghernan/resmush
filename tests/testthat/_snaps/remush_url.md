# Test offline

    Code
      dm
    Output
                                                                                  src_img
      1 https://raw.githubusercontent.com/dieghernan/resmush/main/inst/extimg/example.png
        dest_img src_size dest_size compress_ratio   notes src_bytes dest_bytes
      1       NA       NA        NA             NA Offline        NA         NA

# Test corner

    Code
      dm
    Output
                                                                                  src_img
      1 https://raw.githubusercontent.com/dieghernan/resmush/main/inst/extimg/example.png
        dest_img src_size dest_size compress_ratio
      1       NA       NA        NA             NA
                                                         notes src_bytes dest_bytes
      1 API is not responding. Check https://resmush.it/status        NA         NA

# Test API response without destination

    Code
      dm$notes
    Output
      [1] "API is not responding. Check https://resmush.it/status"

# Test not url

    Code
      dm
    Output
                                           src_img dest_img src_size dest_size
      1 https://dieghernan.github.io/aaabbbccc.png       NA       NA        NA
        compress_ratio                            notes src_bytes dest_bytes
      1             NA 401: Cannot copy from remote url        NA         NA

# Not valid file

    Code
      dm
    Output
                                                                    src_img dest_img
      1 https://raw.githubusercontent.com/dieghernan/resmush/main/README.md       NA
        src_size dest_size compress_ratio
      1       NA        NA             NA
                                                                      notes src_bytes
      1 403: Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF        NA
        dest_bytes
      1         NA

# Test errors in lengths

    Code
      dm <- resmush_url(two_input, several_outputs)
    Condition
      Error in `resmush_url()`:
      ! `url` and `outfile` must have the same length. They have lengths 2 and 3, respectively.

