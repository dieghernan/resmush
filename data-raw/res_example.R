## code to prepare `res_example` dataset goes here

# No url
turl <- "https://dieghernan.github.io/aaabbbccc.png"


# Not valid
notval <- paste0(
  "https://raw.githubusercontent.com/",
  "dieghernan/resmush/main/README.md"
)

png_url <- paste0(
  "https://raw.githubusercontent.com/",
  "dieghernan/resmush/main/inst/",
  "extimg/example.png"
)

jpg_url <- paste0(
  "https://raw.githubusercontent.com/",
  "dieghernan/resmush/main/inst/",
  "extimg/example.jpg"
)

all_in <- c(png_url, notval, jpg_url, turl)

res_example <- resmush_url(all_in)

# Anonimize folder

res_example$dest_img <- basename(res_example$dest_img)

res_example$dest_img <- ifelse(is.na(res_example$dest_img),
  NA, file.path("some_folder", res_example$dest_img)
)


usethis::use_data(res_example, overwrite = TRUE, internal = TRUE)
