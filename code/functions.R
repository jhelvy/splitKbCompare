getFilteredIDs <- function(input, keyboards) {
    idsNumKeys <- which(keyboards$nKeysMax <= input$maxNumKeys)
    idsNumberRow <- filterNumberRow(input, idsNumKeys)
    idsColStagger <- filterColStagger(input, idsNumKeys)
    idsAvailability <- filterAvailability(input, idsNumKeys)
    return(intersect(idsColStagger,
            intersect(idsAvailability,
                intersect(idsNumKeys, idsNumberRow))))
}

filterNumberRow <- function(input, ids) {
    if (input$hasNumberRow == "Only with number row") {
        ids <- which(keyboards$hasNumRow == 1)
    }
    if (input$hasNumberRow == "Only without number row") {
        ids <- which(keyboards$hasNumRow == 0)
    }
    return(ids)
}

filterColStagger <- function(input, ids) {
    if (input$colStagger != "All") {
        ids <- which(keyboards$colStagger == input$colStagger)
    }
    return(ids)
}

filterAvailability <- function(input, ids) {
    if (input$availability == "DIY") {
        ids <- which(keyboards$diy == 1)
    }
    if (input$availability == "Pre-built") {
        ids <- which(keyboards$prebuilt == 1)
    }
    return(ids)
}

getKeyboardIDs <- function(input, keyboards) {
    names <- input$keyboards
    ids <- keyboards[which(keyboards$name %in% names),]$id
    return(ids)
}

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
