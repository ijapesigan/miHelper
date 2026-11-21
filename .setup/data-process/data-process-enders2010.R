#' Data Process - `data/enders2010.rda`
#'
DataProcessEnders2010 <- function(overwrite = FALSE) {
  root <- rprojroot::is_rstudio_project
  data_folder <- root$find_file(
    "data"
  )
  if (!dir.exists(data_folder)) {
    dir.create(
      data_folder,
      recursive = TRUE
    )
  }
  enders2010_rda <- file.path(
    data_folder,
    "enders2010.rda"
  )
  if (!file.exists(enders2010_rda)) {
    write <- TRUE
  } else {
    if (overwrite) {
      write <- TRUE
    } else {
      write <- FALSE
    }
  }
  if (write) {
    enders2010 <- read.csv(
      root$find_file(
        ".setup",
        "data-raw",
        "enders2010.txt"
      )
    )
    save(
      enders2010,
      file = root$find_file(
        "data",
        "enders2010.rda"
      ),
      compress = FALSE
    )
  }
}
DataProcessEnders2010(overwrite = TRUE)
rm(DataProcessEnders2010)
