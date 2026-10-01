# Prepare the example image data.
# Get an Imgur URL for further examples.

# img <- knitr::imgur_upload("inst/extimg/example.jpg")

as.character(img)
# "https://i.imgur.com/NtuYqiY.jpg"
usethis::use_data(plot_examples, overwrite = TRUE)
