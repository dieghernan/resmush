# Test offline

    Code
      dm <- resmush_url(png_url)
    Message
      == resmush summary =============================================================
      i Input: 1 URL, 0 bytes total.
      x Failed to optimize 1 URL:
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
      i Input: 1 URL, 0 bytes total.
      x Failed to optimize 1 URL:
      ! <https://raw.githubusercontent.com/dieghernan/resmush/main/inst/extimg/example.png>:
        API is not responding. Check https://resmush.it/status.

---

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
      dm <- resmush_url(turl)
    Message
      == resmush summary =============================================================
      i Input: 1 URL, 0 bytes total.
      x Failed to optimize 1 URL:
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
      i Input: 1 URL, 0 bytes total.
      x Failed to optimize 1 URL:
      ! <https://raw.githubusercontent.com/dieghernan/resmush/main/README.md>: 403:
        Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF.

---

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

# Test default opts with png

    Code
      dm <- resmush_url(png_url)
    Message
      == resmush summary =============================================================
      i Input: 1 URL, 239.9 Kb total.
      v Optimized 1 URL: size is now 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
      Saved result in directory '<tempdir>'.

# Test opts with png

    Code
      dm <- resmush_url(png_url, outf)
    Message
      == resmush summary =============================================================
      i Input: 1 URL, 239.9 Kb total.
      v Optimized 1 URL: size is now 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
      Saved result in directory '<tempdir>'.

# Test qlty par with jpg

    Code
      dm <- resmush_url(jpg_url, outf)
    Message
      == resmush summary =============================================================
      i Input: 1 URL, 100.4 Kb total.
      v Optimized 1 URL: size is now 83.2 Kb (was 100.4 Kb). Saved 17.2 Kb (17.15%).
      Saved result in directory '<tempdir>'.

# Test errors in lengths

    Code
      dm <- resmush_url(two_input, several_outputs)
    Condition
      Error in `resmush_url()`:
      ! `url` and `outfile` must have the same length. They have lengths 2 and 3, respectively.

# Test full vectors with outfile

    Code
      dm <- resmush_url(all_in, all_outs)
    Message
      == resmush summary =============================================================
      i Input: 4 URLs, 340.2 Kb total.
      v Optimized 2 URLs: size is now 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
      Saved results in directory '<tempdir>'.
      x Failed to optimize 2 URLs:
      ! <https://raw.githubusercontent.com/dieghernan/resmush/main/README.md>: 403:
        Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF.
      ! <https://dieghernan.github.io/aaabbbccc.png>: 401: Cannot copy from remote
        url.

# Handle duplicate names

    Code
      dm <- resmush_url(png_url, outs)
    Message
      == resmush summary =============================================================
      i Input: 3 URLs, 719.6 Kb total.
      v Optimized 3 URLs: size is now 212 Kb (was 719.6 Kb). Saved 507.6 Kb (70.54%).
      Saved results in directory '<tempdir>'.

# Use overwrite

    Code
      dm <- resmush_url(png_url, outs, overwrite = TRUE)
    Message
      == resmush summary =============================================================
      i Input: 3 URLs, 719.6 Kb total.
      v Optimized 3 URLs: size is now 212 Kb (was 719.6 Kb). Saved 507.6 Kb (70.54%).
      Saved results in directory '<tempdir>/over'.

# Test no file

    Code
      dm <- resmush_url(png_url)
    Message
      x Cannot download optimized image <https://raw.githubusercontent.com/dieghernan/resmush/main/inst/extimg/example.png>. HTTP status: 404 (Not Found).

