# Message when no files

    Code
      resmush_clean_dir(dir_temp)
    Message
      i No files with suffix "_resmush" found in '<tempdir>/test_dir_nomess<id>'.

# Message with 1 file

    Code
      resmush_clean_dir(dir_temp)
    Message
      i Removing 1 file:
      > '<tempdir>/test_dir_onefile<id>/example_resmush.png'

# Message with 2 files

    Code
      resmush_clean_dir(dir_temp)
    Message
      i Removing 2 files:
      > '<tempdir>/test_dir_twofile<id>/example2_resmush.png'
      > '<tempdir>/test_dir_twofile<id>/example_resmush.png'

