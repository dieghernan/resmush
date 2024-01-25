# png

    Code
      dm <- resmush_url(url)
    Message
      == resmush summary =============================================================
      i Input: 1 url with size 0 bytes
      x Failed for 1 url:
      ! <https://raw.githubusercontent.com/dieghernan/resmush/main/img/sample-png-10mb.png>:
        502: Uploaded file must be below 5MB.

---

    Code
      dm[, -1]
    Output
        dest_img src_size dest_size compress_ratio
      1       NA       NA        NA             NA
                                       notes src_bytes dest_bytes
      1 502: Uploaded file must be below 5MB        NA         NA

# tif

    Code
      dm <- resmush_url(url)
    Message
      == resmush summary =============================================================
      i Input: 1 url with size 0 bytes
      x Failed for 1 url:
      ! <https://raw.githubusercontent.com/dieghernan/resmush/main/img/sample-tif-1mb.tif>:
        403: Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF.

