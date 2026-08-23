# resmush_dir() returns NULL when no files match

    Code
      dm <- resmush_dir(dir_temp)
    Message
      i No files matching "\\.(png|jpe?g|bmp|gif|tif)$" were found in '<tempdir>/resmush_test<id>'.

# resmush_dir() processes matching files recursively

    Code
      resmush_clean_dir(nested, "_resmush", recursive = TRUE)
    Message
      i Removing 2 files:
      > '<tempdir>/resmush-dir-<id>/top1/nested/sample_nested_resmush.jpg'
      > '<tempdir>/resmush-dir-<id>/top1/sample_top1_resmush.png'

