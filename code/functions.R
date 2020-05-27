getFilteredRows <- function(input, keyboards) {
    rowsNumKeys <- which(keyboards$nKeysMax <= input$maxNumKeys)
    rowsNumberRow <- filterNumberRow(input, rowsNumKeys)
    rowsColStagger <- filterColStagger(input, rowsNumKeys)
    rowsRotarySupport <- filterRotarySupport(input, rowsNumKeys)
    rowsAvailability <- filterAvailability(input, rowsNumKeys)
    rows <- intersect(rowsColStagger, 
                intersect(rowsRotarySupport,
                    intersect(rowsAvailability,
                        intersect(rowsNumKeys, rowsNumberRow))))
    return(rows)
}

filterNumberRow <- function(input, rows) {
    if (input$hasNumberRow == "Only with number row") {
        rows <- which(keyboards$hasNumRow == 1)
    }
    if (input$hasNumberRow == "Only without number row") {
        rows <- which(keyboards$hasNumRow == 0)
    }
    return(rows)
}

filterColStagger <- function(input, rows) {
    if (input$colStagger != "All") {
        rows <- which(keyboards$colStagger == input$colStagger)
    }
    return(rows)
}

filterRotarySupport <- function(input, rows) {
    if (input$rotaryEncoder == "Yes") {
        rows <- which(keyboards$rotaryEncoder == 1)
    }
    if (input$rotaryEncoder == "No") {
        rows <- which(keyboards$rotaryEncoder == 0)
    }
    return(rows)
}

filterAvailability <- function(input, rows) {
    if (input$availability == "DIY") {
        rows <- which(keyboards$diy == 1)
    }
    if (input$availability == "Pre-built") {
        rows <- which(keyboards$prebuilt == 1)
    }
    return(rows)
}

getSelectedIDs <- function(input, keyboards) {
    names <- input$keyboards
    ids <- keyboards[which(keyboards$nameKeys %in% names),]$id
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
