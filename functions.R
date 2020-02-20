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

getInputIDs <- function(input, keyboards) {
    ids <- c()
    for (i in 1:nrow(keyboards)) {
        name <- keyboards$id[i]
        if (input[[name]]) { ids <- c(ids, name) }
    }
    return(ids)
}
