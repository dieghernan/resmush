# Test offline

    Code
      dm <- resmush_file(test_png)
    Message
      ! Offline

---

    Code
      dm[, -1]
    Output
        dest_img src_size dest_size compress_ratio   notes
      1       NA       NA        NA             NA Offline

# Test not provided file

    Code
      dm[, -1]
    Output
        dest_img src_size dest_size compress_ratio                      notes
      1       NA       NA        NA             NA local file does not exists

# Not valid file

    Code
      dm[, -c(1, 2)]
    Output
        src_size dest_size compress_ratio
      1 21 bytes        NA             NA
                                                                            notes
      1 403: Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF, WEBP

