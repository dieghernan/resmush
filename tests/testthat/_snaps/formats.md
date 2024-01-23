# png

    Code
      dm <- resmush_url(url)
    Message
      ! API Error for <https://raw.githubusercontent.com/dieghernan/resmush/main/img/sample-png-10mb.png>
      i Error 502: Uploaded file must be below 5MB

---

    Code
      dm[, -1]
    Output
        dest_img src_size dest_size compress_ratio
      1       NA       NA        NA             NA
                                       notes
      1 502: Uploaded file must be below 5MB

# tif

    Code
      dm <- resmush_url(url)
    Message
      ! API Error for <https://raw.githubusercontent.com/dieghernan/resmush/main/img/sample-tif-1mb.tif>
      i Error 403: Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF

