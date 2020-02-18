# Functions for processing the images
getImage <- function(keyboard) {
    image_read(here::here("images", paste0(keyboard, ".png")))
}

getColorizedImage <- function(keyboard, color) {
    image <- getImage(keyboard)
    return(image_colorize(image, 100, color))
}

getOverlayBw <- function(ids, keyboards) {
    overlay <- getImage('bg-white')
    for (id in ids) {
        image <- getColorizedImage(id, 'black')
        overlay <- c(overlay, image)
    }
    return(overlay)
}

getOverlayColor <- function(ids, keyboards) {
    overlay <- getImage('bg-black')
    for (id in ids) {
        color <- as.character(keyboards[which(keyboards$id == id),]$color)
        image <- getColorizedImage(id, color)
        overlay <- c(overlay, image)
    }
    return(overlay)
}

makeSavePath <- function(imageName, color = T) {
    imageName <- paste0(imageName, '.png')
    if (color) {
        return(here::here('images', 'overlays', 'color', imageName))
    }
    return(here::here('images', 'overlays', 'bw', imageName))
}

# Functions for the server
getImageName <- function(input, keyboards) {
    imageNames <- c()
    for (id in keyboards$id) {
        if (input[[id]]) {
            imageNames <- c(imageNames, id)
        }
    }
    return(str_c(imageNames, collapse = '_'))
}
