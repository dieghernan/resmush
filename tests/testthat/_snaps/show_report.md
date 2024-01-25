# Report for local

    Code
      show_report(test_f)
    Message
      == resmush summary =============================================================
      i Input: 4 files with size 340.2 Kb
      v Success for 2 files: Size now is 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
      See results in directory '/RtmpwZ55V8'.
      x Failed for 2 files in directories 'https://raw.githubusercontent.com/dieghernan/resmush/main' and 'https://dieghernan.github.io'.
      i Files not converted:
      ! 'https://raw.githubusercontent.com/dieghernan/resmush/main/README.md' (NA):
        403: Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF, WEBP.
      ! 'https://dieghernan.github.io/aaabbbccc.png' (NA): 401: Cannot copy from
        remote url.

---

    Code
      show_report(res_example[2, ])
    Message
      == resmush summary =============================================================
      i Input: 1 file with size 0 bytes
      x Failed for 1 file in directory 'https://raw.githubusercontent.com/dieghernan/resmush/main'.
      i File not converted:
      ! 'https://raw.githubusercontent.com/dieghernan/resmush/main/README.md' (NA):
        403: Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF, WEBP.

---

    Code
      show_report(res_example[c(2, 4), ])
    Message
      == resmush summary =============================================================
      i Input: 2 files with size 0 bytes
      x Failed for 2 files in directories 'https://raw.githubusercontent.com/dieghernan/resmush/main' and 'https://dieghernan.github.io'.
      i Files not converted:
      ! 'https://raw.githubusercontent.com/dieghernan/resmush/main/README.md' (NA):
        403: Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF, WEBP.
      ! 'https://dieghernan.github.io/aaabbbccc.png' (NA): 401: Cannot copy from
        remote url.

---

    Code
      show_report(res_example[1, ])
    Message
      == resmush summary =============================================================
      i Input: 1 file with size 239.9 Kb
      v Success for 1 file: Size now is 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
      See result in directory '/RtmpwZ55V8'.

---

    Code
      show_report(res_example[-c(2, 4), ])
    Message
      == resmush summary =============================================================
      i Input: 2 files with size 340.2 Kb
      v Success for 2 files: Size now is 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
      See results in directory '/RtmpwZ55V8'.

# Report for url

    Code
      show_report(test_f, "url")
    Message
      == resmush summary =============================================================
      i Input: 4 urls with size 340.2 Kb
      v Success for 2 urls: Size now is 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
      See results in directory '/RtmpwZ55V8'.
      x Failed for 2 urls:
      ! <https://raw.githubusercontent.com/dieghernan/resmush/main/README.md>: 403:
        Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF, WEBP.
      ! <https://dieghernan.github.io/aaabbbccc.png>: 401: Cannot copy from remote
        url.

---

    Code
      show_report(res_example[2, ], "url")
    Message
      == resmush summary =============================================================
      i Input: 1 url with size 0 bytes
      x Failed for 1 url:
      ! <https://raw.githubusercontent.com/dieghernan/resmush/main/README.md>: 403:
        Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF, WEBP.

---

    Code
      show_report(res_example[c(2, 4), ], "url")
    Message
      == resmush summary =============================================================
      i Input: 2 urls with size 0 bytes
      x Failed for 2 urls:
      ! <https://raw.githubusercontent.com/dieghernan/resmush/main/README.md>: 403:
        Unauthorized extension. Allowed are : JPG, PNG, GIF, BMP, TIFF, WEBP.
      ! <https://dieghernan.github.io/aaabbbccc.png>: 401: Cannot copy from remote
        url.

---

    Code
      show_report(res_example[1, ], "url")
    Message
      == resmush summary =============================================================
      i Input: 1 url with size 239.9 Kb
      v Success for 1 url: Size now is 70.7 Kb (was 239.9 Kb). Saved 169.2 Kb (70.54%).
      See result in directory '/RtmpwZ55V8'.

---

    Code
      show_report(res_example[-c(2, 4), ], "url")
    Message
      == resmush summary =============================================================
      i Input: 2 urls with size 340.2 Kb
      v Success for 2 urls: Size now is 153.8 Kb (was 340.2 Kb). Saved 186.4 Kb (54.79%).
      See results in directory '/RtmpwZ55V8'.

