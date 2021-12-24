################################################################################
# Libraries ---------------------------------------------------------------
################################################################################

library(magick)
library(readr)
library(dplyr)

################################################################################
# Prepare paths -----------------------------------------------------------
################################################################################

# Find paths to all images
images <- list.files(file.path("images", "png"))
kbNames <- fs::path_ext_remove(images)

################################################################################
# Render PDF's ------------------------------------------------------------
################################################################################

# Create output directory if necessary
if (!dir.exists(file.path("images", "pdf"))) {
    dir.create(file.path("images", "pdf", "a4"), recursive = TRUE)
    dir.create(file.path("images", "pdf", "letter"))
}

# Only render new keyboards
# for (size in c("A4", "Letter")) {
#   pdfs <- list.files(file.path("images", "pdf", size))
#   pdfs <- fs::path_ext_remove(pdfs)
#   kbNames <- kbNames[!kbNames %in% pdfs]
# }

# Loop over all keyboards that are present in images/png
# Use corresponding .png as an input for Markdown document to render a .pdf
# Render .pdf's in the a4 & letter format
# Save .pdf's in images/pdf/a4 or images/pdf/letter
for (size in c("A4", "Letter")) {
    for (kbName in kbNames) {
        rmarkdown::render(
            input = file.path("code", paste0("print", size, ".Rmd")),
            output_file = file.path("..", "images", "pdf", size, paste0(kbName, ".pdf")),
            params = list(path = file.path("..", "images", "png", paste0(kbName, ".png")))
        )
    }
    # Check if all images are (most likely) rendered
    stopifnot(
        length(list.files(file.path("images", "pdf", size))) == length(kbNames)
    )
}

################################################################################
# Add PDF paths to keyboards.csv ------------------------------------------
################################################################################

kbPdfLinks <- data.frame(
    id = kbNames,
    pdf_path_a4 = file.path("/pdf", "a4", paste0(kbNames, ".pdf")),
    pdf_path_letter = file.path("/pdf", "letter", paste0(kbNames, ".pdf"))
)

keyboards <- readr::read_csv("keyboards.csv") %>%
    select(-any_of(c("pdf_path_a4", "pdf_path_letter")))
keyboards <- left_join(keyboards, kbPdfLinks, by = "id")
readr::write_csv(keyboards, "keyboards.csv")
