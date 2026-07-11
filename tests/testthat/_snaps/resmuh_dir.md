# Test no file

    Code
      dm <- resmush_dir(a)
    Message
      i No files matching "\\.(png|jpe?g|bmp|gif|tif)$" found in .

# Testing regex

    Code
      dm <- resmush_dir(dir_temp, ext = "png$")
    Message
      i Optimizing 1 file.
      == resmush summary =============================================================
      i Input: 1 file, 239.9 Kb total.
      v Optimized 1 file: size is now 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
      Saved result in directory
      '<tempdir>/resmush-dir-<id>'.

# Testing regex several with suffix

    Code
      dm <- resmush_dir(dir_temp, ext = "*", suffix = "_some_error")
    Message
      i Optimizing 2 files.
      == resmush summary =============================================================
      i Input: 2 files, 239.9 Kb total.
      v Optimized 1 file: size is now 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
      Saved result in directory
      '<tempdir>/test2<id>'.
      x Failed to optimize 1 file in directory '<tempdir>/test2<id>'.
      i File not optimized:
      ! '<tempdir>/test2<id>/aa.txt' ("21
        bytes"): 403: Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF.

# Testing nested dirs

    Code
      dm <- resmush_dir(nested, recursive = TRUE)
    Message
      i Optimizing 2 files.
      == resmush summary =============================================================
      i Input: 2 files, 43.7 Kb total.
      v Optimized 2 files: size is now 13.7 Kb (was 43.7 Kb). Saved 30 Kb (68.62%).
      Saved results in directories
      '<tempdir>/resmush-dir-<id>/top1/nested'
      and
      '<tempdir>/resmush-dir-<id>/top1'.

---

    Code
      resmush_clean_dir(nested, "_resmush", recursive = TRUE)
    Message
      i Removing 2 files:
      > '<tempdir>/resmush-dir-<id>/top1/nested/sample_nested_resmush.jpg'
      > '<tempdir>/resmush-dir-<id>/top1/sample_top1_resmush.png'

---

    Code
      dm <- resmush_dir(nested, recursive = FALSE)
    Message
      i Optimizing 1 file.
      == resmush summary =============================================================
      i Input: 1 file, 25.9 Kb total.
      v Optimized 1 file: size is now 7.7 Kb (was 25.9 Kb). Saved 18.1 Kb (70.09%).
      Saved result in directory
      '<tempdir>/resmush-dir-<id>/top1'.

# Testing separated dirs

    Code
      dm <- resmush_dir(dir = c(dir_temp1, dir_temp2), suffix = "", qlty = 10,
      recursive = TRUE)
    Message
      i Optimizing 3 files.
      == resmush summary =============================================================
      i Input: 3 files, 61.5 Kb total.
      v Optimized 3 files: size is now 9.9 Kb (was 61.5 Kb). Saved 51.5 Kb (83.86%).
      Saved results in directories
      '<tempdir>/resmush-dir-<id>/top1/nested',
      '<tempdir>/resmush-dir-<id>/top1',
      and
      '<tempdir>/resmush-dir-<id>/top2'.

# Overwrite ignore suffix

    Code
      dm <- resmush_dir(dir = c(dir_temp1, nested_dir), suffix = "_not_exist",
      overwrite = TRUE)
    Message
      i Optimizing 2 files.
      == resmush summary =============================================================
      i Input: 2 files, 43.7 Kb total.
      v Optimized 2 files: size is now 13.7 Kb (was 43.7 Kb). Saved 30 Kb (68.62%).
      Saved results in directories
      '<tempdir>/resmush-dir-<id>/top1/nested'
      and
      '<tempdir>/resmush-dir-<id>/top1'.

