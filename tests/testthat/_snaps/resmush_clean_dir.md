# resmush_clean_dir reports no files when none match

    Code
      resmush_clean_dir(dir_temp)
    Message
      i No files with suffix "_resmush" were found in '<tempdir>/test_dir_nomess<id>'.

# resmush_clean_dir reports one file removed

    Code
      resmush_clean_dir(dir_temp)
    Message
      i Removing 1 file:
      > '<tempdir>/test_dir_onefile<id>/example_resmush.png'

# resmush_clean_dir reports two files removed

    Code
      resmush_clean_dir(dir_temp)
    Message
      i Removing 2 files:
      > '<tempdir>/test_dir_twofile<id>/example2_resmush.png'
      > '<tempdir>/test_dir_twofile<id>/example_resmush.png'

