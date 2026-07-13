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
      1 API is not responding. Check https://resmush.it/status         NA

# Test API response without destination

    Code
      dm$notes
    Output
      [1] "API is not responding. Check https://resmush.it/status"

# Test not provided file

    Code
      dm[, -1]
    Output
        dest_img src_size dest_size compress_ratio                     notes
      1       NA       NA        NA             NA Local file does not exist
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

# Test qlty par with jpg

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

