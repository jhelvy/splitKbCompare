# Load functions
getImage <- function(kb) {
    image_read(file.path("images", paste0(kb, ".png")))
}

# Load functions
getColoredImage <- function(kb) {
    image <- images[[kb]]
    color <- colors[kb]
    return(image_colorize(image, 100, color))
}

getOverlay <- function(input, keyboards) {
    overlay <- getImage('background')
    for (kb in keyboards) {
        if (input[[kb]]) {
            overlay <- c(overlay, getColoredImage(kb))
        }
    }
    return(overlay)
}
