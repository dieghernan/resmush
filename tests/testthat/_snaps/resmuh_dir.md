# Test no file

    Code
      dm <- resmush_dir(a)
    Message
      i No files matching "\\.(png|jpe?g|bmp|gif|tif)$" found in .

# Testing nested dirs

    Code
      resmush_clean_dir(nested, "_resmush", recursive = TRUE)
    Message
      i Removing 2 files:
      > '<tempdir>/resmush-dir-<id>/top1/nested/sample_nested_resmush.jpg'
      > '<tempdir>/resmush-dir-<id>/top1/sample_top1_resmush.png'

