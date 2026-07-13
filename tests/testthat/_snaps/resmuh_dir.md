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

# Testing nested dirs

    Code
      resmush_clean_dir(nested, "_resmush", recursive = TRUE)
    Message
      i Removing 2 files:
      > '<tempdir>/resmush-dir-<id>/top1/nested/sample_nested_resmush.jpg'
      > '<tempdir>/resmush-dir-<id>/top1/sample_top1_resmush.png'

