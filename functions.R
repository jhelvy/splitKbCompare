getImage <- function(id) {
    imagePath <- file.path('images', paste0(id, ".png"))
    return(image_read(imagePath))
}

getColorImage <- function(id, color) {
    image <- getImage(id)
    return(image_colorize(image, 100, color))
}

makeImageOverlay <- function(ids, colors = NULL) {
    bg <- 'bg-white.png'
    if (length(colors) > 0) { bg <- 'bg-black.png' }
    overlay <- image_read(file.path('images', bg))
    if (length(ids) > 0) {
        for (i in 1:length(ids)) {
            id <- ids[i]
            if (length(colors) > 0) {
                image <- getColorImage(id, colors[i])
            } else {
                image <- getImage(id)
            }
            overlay <- c(overlay, image)
        }
    }
    return(overlay %>%
           image_join() %>%
           image_mosaic())
}

getKeyboardIDs <- function(input, keyboards) {
    names <- input$keyboards
    ids <- keyboards[which(keyboards$name %in% names),]$id
    return(ids)
}
