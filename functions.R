# Functions for processing the images
getImage <- function(keyboard, color) {
    image_read(here::here('images', color, paste0(keyboard, ".png")))
}

makeColorizedImage <- function(keyboard, color) {
    image <- getImage(keyboard, 'bw')
    return(image_colorize(image, 100, color))
}

makeImageOverlay <- function(ids, keyboards, color = T) {
    bg <- 'bg-white.png'
    folder <- 'bw'
    if (color) {
        bg <- 'bg-black.png'
        folder <- 'color'
    }
    overlay <- image_read(here::here('images', bg))
    for (id in ids) {
        image <- getImage(id, folder)
        overlay <- c(overlay, image)
    }
    return(overlay %>% 
           image_join() %>% 
           image_mosaic())
}

makeOverlaySavePath <- function(imageName, color = T) {
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
