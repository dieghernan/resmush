# resmush_clean_dir() leaves directories unchanged without matches

    Code
      resmush_clean_dir(dir_temp)
    Message
      i No files with suffix "_resmush" were found in '<tempdir>/test_dir_nomess<id>'.

# resmush_clean_dir() removes one matching file

    Code
      resmush_clean_dir(dir_temp)
    Message
      i Removing 1 file:
      > '<tempdir>/test_dir_onefile<id>/example_resmush.png'

# resmush_clean_dir() removes multiple matching files

    Code
      resmush_clean_dir(dir_temp)
    Message
      i Removing 2 files:
      > '<tempdir>/test_dir_twofile<id>/example2_resmush.png'
      > '<tempdir>/test_dir_twofile<id>/example_resmush.png'

