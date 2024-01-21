## code to prepare `logo` dataset goes here
rm(list = ls())

library(hexSticker)

library(showtext)
## Loading Google fonts (http://www.google.com/fonts)
font_add_google("Inter", "inter")

showtext_auto()
sticker("data-raw/plot.png",
  s_width = 0,
  s_height = 0,
  s_x = 1,
  s_y = 1,
  p_family = "inter",
  p_fontface = "bold",
  filename = "data-raw/base.png",
  h_fill = "black",
  h_color = "black",
  package = "",
  p_y = 1.5,
  p_x = 1,
  p_size = 20
)

usethis::use_logo("data-raw/logo.png")
pkgdown::build_favicons(overwrite = TRUE)
