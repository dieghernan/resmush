# Test offline

    Code
      dm <- resmush_url(png_url)
    Message
      == resmush summary =============================================================
      i Input: 1 url with size 0 bytes
      x Failed for 1 url:
      ! <https://raw.githubusercontent.com/dieghernan/resmush/main/inst/extimg/example.png>:
        Offline.

---

    Code
      dm
    Output
                                                                                  src_img
      1 https://raw.githubusercontent.com/dieghernan/resmush/main/inst/extimg/example.png
        dest_img src_size dest_size compress_ratio   notes src_bytes dest_bytes
      1       NA       NA        NA             NA Offline        NA         NA

# Test corner

    Code
      dm <- resmush_url(png_url)
    Message
      == resmush summary =============================================================
      i Input: 1 url with size 0 bytes
      x Failed for 1 url:
      ! <https://raw.githubusercontent.com/dieghernan/resmush/main/inst/extimg/example.png>:
        API Not responding, check https://resmush.it/status}.

---

    Code
      dm
    Output
                                                                                  src_img
      1 https://raw.githubusercontent.com/dieghernan/resmush/main/inst/extimg/example.png
        dest_img src_size dest_size compress_ratio
      1       NA       NA        NA             NA
                                                       notes src_bytes dest_bytes
      1 API Not responding, check https://resmush.it/status}        NA         NA

# Test not url

    Code
      dm <- resmush_url(turl)
    Message
      == resmush summary =============================================================
      i Input: 1 url with size 0 bytes
      x Failed for 1 url:
      ! <https://dieghernan.github.io/aaabbbccc.png>: 401: Cannot copy from remote
        url.

---

    Code
      dm
    Output
                                           src_img dest_img src_size dest_size
      1 https://dieghernan.github.io/aaabbbccc.png       NA       NA        NA
        compress_ratio                            notes src_bytes dest_bytes
      1             NA 401: Cannot copy from remote url        NA         NA

# Not valid file

    Code
      dm <- resmush_url(turl)
    Message
      == resmush summary =============================================================
      i Input: 1 url with size 0 bytes
      x Failed for 1 url:
      ! <https://raw.githubusercontent.com/dieghernan/resmush/main/README.md>: 403:
        Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF, WEBP.

---

    Code
      dm
    Output
                                                                    src_img dest_img
      1 https://raw.githubusercontent.com/dieghernan/resmush/main/README.md       NA
        src_size dest_size compress_ratio
      1       NA        NA             NA
                                                                            notes
      1 403: Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF, WEBP
        src_bytes dest_bytes
      1        NA         NA

# Test errors in lengths

    Code
      dm <- resmush_url(two_input, several_outputs)
    Condition
      Error in `resmush_url()`:
      ! Lengths of `url` and `outfile`should be the same (2 vs. 3)

