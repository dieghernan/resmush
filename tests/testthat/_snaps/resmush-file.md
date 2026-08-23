# resmush_file() preserves EXIF metadata when requested

    Code
      resmush_clean_dir(exif_dir, "_without_exif")
    Message
      i Removing 1 file:
      > '<tempdir>/resmush-exif-<id>/exif_without_exif.jpg'

---

    Code
      resmush_clean_dir(exif_dir, "_with_exif")
    Message
      i Removing 1 file:
      > '<tempdir>/resmush-exif-<id>/exif_with_exif.jpg'

# resmush_file() overwrites existing outputs when enabled

    Code
      dm <- resmush_file(test_png, suffix = "_resmush", overwrite = TRUE, progress = FALSE)
    Message
      == resmush summary =============================================================
      i Input: 1 file, 239.9 Kb total.
      v Optimized 1 file: size is now 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
      Saved result in directory
      '<tempdir>/resmush-file-<id>/overr_file'.

# resmush_file() returns NULL after HTTP download errors

    Code
      dm <- resmush_file(test_png, progress = FALSE)
    Message
      x Cannot download the optimized file '<tempdir>/resmush-dir-<id>/example.png'. HTTP status: 404 (Not Found).

