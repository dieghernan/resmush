# Test offline

    Code
      dm[, -1]
    Output
        dest_img src_size dest_size compress_ratio   notes src_bytes dest_bytes
      1       NA       NA        NA             NA Offline        NA         NA

# Test corner

    Code
      dm[, -c(1, 3, 7)]
    Output
        dest_img dest_size compress_ratio
      1       NA        NA             NA
                                                       notes dest_bytes
      1 API Not responding, check https://resmush.it/status}         NA

# Test not provided file

    Code
      dm[, -1]
    Output
        dest_img src_size dest_size compress_ratio                      notes
      1       NA       NA        NA             NA Local file does not exists
        src_bytes dest_bytes
      1        NA         NA

# Not valid file

    Code
      dm[, -c(1, 3, 7)]
    Output
        dest_img dest_size compress_ratio
      1       NA        NA             NA
                                                                      notes
      1 403: Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF
        dest_bytes
      1         NA

