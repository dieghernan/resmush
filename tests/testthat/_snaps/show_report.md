# Report for local

    Code
      show_report(test_f)
    Message
      == resmush summary =============================================================
      i Input: 4 files, 340.2 Kb total.
      v Optimized 2 files: size is now 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
      Saved results in directory 'some_folder'.
      x Failed to optimize 2 files in directories 'https://raw.githubusercontent.com/dieghernan/resmush/main' and 'https://dieghernan.github.io'.
      i Files not optimized:
      ! 'https://raw.githubusercontent.com/dieghernan/resmush/main/README.md' (NA):
        403: Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF.
      ! 'https://dieghernan.github.io/aaabbbccc.png' (NA): 401: Cannot copy from
        remote url.

---

    Code
      show_report(res_example[2, ])
    Message
      == resmush summary =============================================================
      i Input: 1 file, 0 bytes total.
      x Failed to optimize 1 file in directory 'https://raw.githubusercontent.com/dieghernan/resmush/main'.
      i File not optimized:
      ! 'https://raw.githubusercontent.com/dieghernan/resmush/main/README.md' (NA):
        403: Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF.

---

    Code
      show_report(res_example[c(2, 4), ])
    Message
      == resmush summary =============================================================
      i Input: 2 files, 0 bytes total.
      x Failed to optimize 2 files in directories 'https://raw.githubusercontent.com/dieghernan/resmush/main' and 'https://dieghernan.github.io'.
      i Files not optimized:
      ! 'https://raw.githubusercontent.com/dieghernan/resmush/main/README.md' (NA):
        403: Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF.
      ! 'https://dieghernan.github.io/aaabbbccc.png' (NA): 401: Cannot copy from
        remote url.

---

    Code
      show_report(res_example[1, ])
    Message
      == resmush summary =============================================================
      i Input: 1 file, 239.9 Kb total.
      v Optimized 1 file: size is now 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
      Saved result in directory 'some_folder'.

---

    Code
      show_report(res_example[-c(2, 4), ])
    Message
      == resmush summary =============================================================
      i Input: 2 files, 340.2 Kb total.
      v Optimized 2 files: size is now 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
      Saved results in directory 'some_folder'.

# Report for url

    Code
      show_report(test_f, "url")
    Message
      == resmush summary =============================================================
      i Input: 4 URLs, 340.2 Kb total.
      v Optimized 2 URLs: size is now 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
      Saved results in directory 'some_folder'.
      x Failed to optimize 2 URLs:
      ! <https://raw.githubusercontent.com/dieghernan/resmush/main/README.md>: 403:
        Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF.
      ! <https://dieghernan.github.io/aaabbbccc.png>: 401: Cannot copy from remote
        url.

---

    Code
      show_report(res_example[2, ], "url")
    Message
      == resmush summary =============================================================
      i Input: 1 URL, 0 bytes total.
      x Failed to optimize 1 URL:
      ! <https://raw.githubusercontent.com/dieghernan/resmush/main/README.md>: 403:
        Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF.

---

    Code
      show_report(res_example[c(2, 4), ], "url")
    Message
      == resmush summary =============================================================
      i Input: 2 URLs, 0 bytes total.
      x Failed to optimize 2 URLs:
      ! <https://raw.githubusercontent.com/dieghernan/resmush/main/README.md>: 403:
        Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF.
      ! <https://dieghernan.github.io/aaabbbccc.png>: 401: Cannot copy from remote
        url.

---

    Code
      show_report(res_example[1, ], "url")
    Message
      == resmush summary =============================================================
      i Input: 1 URL, 239.9 Kb total.
      v Optimized 1 URL: size is now 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
      Saved result in directory 'some_folder'.

---

    Code
      show_report(res_example[-c(2, 4), ], "url")
    Message
      == resmush summary =============================================================
      i Input: 2 URLs, 340.2 Kb total.
      v Optimized 2 URLs: size is now 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
      Saved results in directory 'some_folder'.

