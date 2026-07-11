# Test offline

    Code
      dm[, -1]
    Output
        dest_img src_size dest_size compress_ratio   notes src_bytes dest_bytes
      1       NA       NA        NA             NA Offline        NA         NA

# Test corner

    Code
      dm <- resmush_file(test_png)
    Message
      == resmush summary =============================================================
      i Input: 1 file, 239.9 Kb total.
      x Failed to optimize 1 file in directory '<tempdir>/resmush-dir-<id>'.
      i File not optimized:
      ! '<tempdir>/resmush-dir-<id>/example.png'
        ("239.9 Kb"): API is not responding. Check https://resmush.it/status.

---

    Code
      dm[, -c(1, 3, 7)]
    Output
        dest_img dest_size compress_ratio
      1       NA        NA             NA
                                                         notes dest_bytes
      1 API is not responding. Check https://resmush.it/status         NA

# Test API response without destination

    Code
      dm$notes
    Output
      [1] "API is not responding. Check https://resmush.it/status"

# Test not provided file

    Code
      dm <- resmush_file(fl)
    Message
      == resmush summary =============================================================
      i Input: 1 file, 0 bytes total.
      x Failed to optimize 1 file in directory '<tempdir>'.
      i File not optimized:
      ! '<tempdir>/file<id>' (NA): Local
        file does not exist.

---

    Code
      dm[, -1]
    Output
        dest_img src_size dest_size compress_ratio                     notes
      1       NA       NA        NA             NA Local file does not exist
        src_bytes dest_bytes
      1        NA         NA

# Not valid file

    Code
      dm <- resmush_file(fl)
    Message
      == resmush summary =============================================================
      i Input: 1 file, 21 bytes total.
      x Failed to optimize 1 file in directory '<tempdir>'.
      i File not optimized:
      ! '<tempdir>/file<id>txt' ("21
        bytes"): 403: Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF.

---

    Code
      dm[, -c(1, 3, 7)]
    Output
        dest_img dest_size compress_ratio
      1       NA        NA             NA
                                                                      notes
      1 403: Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF
        dest_bytes
      1         NA

# Test default opts with png

    Code
      dm <- resmush_file(test_png)
    Message
      == resmush summary =============================================================
      i Input: 1 file, 239.9 Kb total.
      v Optimized 1 file: size is now 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
      Saved result in directory
      '<tempdir>/resmush-dir-<id>'.

# Test opts with png

    Code
      dm <- resmush_file(test_png, suffix = "")
    Message
      == resmush summary =============================================================
      i Input: 1 file, 239.9 Kb total.
      v Optimized 1 file: size is now 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
      Saved result in directory
      '<tempdir>/resmush-dir-<id>'.

# Test qlty par with jpg

    Code
      dm <- resmush_file(test_jpg, suffix = "a_jpg_qlty")
    Message
      == resmush summary =============================================================
      i Input: 1 file, 100.4 Kb total.
      v Optimized 1 file: size is now 83.2 Kb (was 100.4 Kb). Saved 17.2 Kb (17.15%).
      Saved result in directory
      '<tempdir>/resmush-dir-<id>'.

---

    Code
      resmush_clean_dir(tempdir(), "_even_lower")
    Message
      i No files with suffix "_even_lower" found in '<tempdir>'.

# Test full vectors

    Code
      resmush_clean_dir(tempdir())
    Message
      i No files with suffix "_resmush" found in '<tempdir>'.

---

    Code
      resmush_clean_dir(tempdir())
    Message
      i No files with suffix "_resmush" found in '<tempdir>'.

# Test full vectors silent

    Code
      resmush_clean_dir(tempdir())
    Message
      i No files with suffix "_resmush" found in '<tempdir>'.

---

    Code
      resmush_clean_dir(tempdir())
    Message
      i No files with suffix "_resmush" found in '<tempdir>'.

# Test EXIF

    Code
      resmush_clean_dir(tempdir(), "_without_exif")
    Message
      i Removing 1 file:
      > '<tempdir>/exif<id>_without_exif.jpg'

---

    Code
      resmush_clean_dir(tempdir(), "_with_exif")
    Message
      i Removing 1 file:
      > '<tempdir>/exif<id>_with_exif.jpg'

# Test override

    Code
      dm <- resmush_file(test_png, suffix = "_resmush", overwrite = TRUE)
    Message
      == resmush summary =============================================================
      i Input: 1 file, 239.9 Kb total.
      v Optimized 1 file: size is now 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
      Saved result in directory
      '<tempdir>/resmush-file-<id>/overr_file'.

# Test no file

    Code
      dm <- resmush_file(test_png)
    Message
      x Cannot download optimized file '<tempdir>/resmush-dir-<id>/example.png'. HTTP status: 404 (Not Found).

