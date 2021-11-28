################################################################################
# Prepare paths -----------------------------------------------------------
################################################################################

# Find paths to all images
imagePaths <- list.files(file.path("images", "png"), full.names = TRUE)
relImagePaths <- file.path("..", imagePaths) # relative to code/printA4.Rmd
imageNames <- fs::path_ext_remove(basename(imagePaths))

# Create pdf paths using imageNames
pdfPaths <- file.path("images", "pdf", paste0(imageNames, ".pdf"))
relPdfPaths <- file.path("..", pdfPaths) # relative to code/printA4.Rmd

# Test if number of PDF paths is the same as the number of image paths 
stopifnot(length(relPdfPaths) == length(relImagePaths))

################################################################################
# Render PDF's ------------------------------------------------------------
################################################################################

# Create output directory if necessary
if (!dir.exists(file.path("images", "pdf"))) {
  dir.create(file.path("images", "pdf"))
}

# Loop over all relImagepaths and outputPdfPaths
# Use relImagepaths as parameter for Rmarkdown template
# Use outputPdfPaths as output file path
mapply(
  function(relImagePath, relPdfPath) {
    rmarkdown::render(
      input = file.path("code", "printA4.Rmd"),
      output_file = relPdfPath,
      params = list(path = relImagePath)
    )
  },
  relImagePath = relImagePaths,
  relPdfPath = relPdfPaths
)

# Test if the number of rendered PDF's is the same as the number of image paths
stopifnot(length(list.files(file.path("images", "pdf"))) == length(relImagePaths))

################################################################################
# Add PDF paths to keyboards.csv ------------------------------------------
################################################################################

imagePdfDf <- data.frame(
    id = imageNames, 
    pdf_path = file.path("/pdf", basename(pdfPaths))
    )

keyboards <- readr::read_csv("keyboards.csv")
keyboards <- left_join(keyboards, imagePdfDf, by = "id")
readr::write_csv(keyboards, "keyboards.csv")
