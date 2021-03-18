getKeyboardNames <- function(input) {
    filteredRows <- getFilteredRows(input)
    tempKeyboards <- keyboards[filteredRows,]
    if (input$sortKeyboards == "Name") {
        tempKeyboards <- tempKeyboards %>% 
            arrange(id, desc(nKeysMax), desc(nKeysMin))
    }
    if (input$sortKeyboards == "# Keys") {
        tempKeyboards <- tempKeyboards %>% 
            arrange(desc(nKeysMax), desc(nKeysMin), id)
    }
    return(tempKeyboards$nameKeys)
}

getFilteredRows <- function(input) {
    rows <- filterNumKeys(input)
    rows <- filterNumRows(input, rows)
    rows <- filterNumberRow(input, rows)
    rows <- filterColStagger(input, rows)
    rows <- filterRowStagger(input, rows)
    rows <- filterRotarySupport(input, rows)
    rows <- filterWireless(input, rows)
    rows <- filterOnePiece(input, rows)
    rows <- filterAvailability(input, rows)
    return(rows)
}

filterNumKeys <- function(input) {
    return(which(keyboards$nKeysMax <= input$maxNumKeys))
}

filterNumRows <- function(input, temp) {
    rows <- which(keyboards$numRows <= input$maxNumRows)
    return(intersect(temp, rows))
}

filterNumberRow <- function(input, temp) {
    rows <- temp
    if (input$hasNumberRow == "Only with number row") {
        rows <- which(keyboards$hasNumRow == 1)
    }
    if (input$hasNumberRow == "Only without number row") {
        rows <- which(keyboards$hasNumRow == 0)
    }
    return(intersect(temp, rows))
}

filterColStagger <- function(input, temp) {
    rows <- temp
    if (input$colStagger != "All") {
        rows <- which(keyboards$colStagger == input$colStagger)
    }
    return(intersect(temp, rows))
}

filterRowStagger <- function(input, temp) {
    rows <- temp
    if (input$rowStagger == "Yes") {
        rows <- which(keyboards$rowStagger == 1)
    }
    if (input$rowStagger == "No") {
        rows <- which(keyboards$rowStagger == 0)
    }
    return(intersect(temp, rows))
}

filterRotarySupport <- function(input, temp) {
    rows <- temp
    if (input$rotaryEncoder == "Yes") {
        rows <- which(keyboards$rotaryEncoder == 1)
    }
    if (input$rotaryEncoder == "No") {
        rows <- which(keyboards$rotaryEncoder == 0)
    }
    return(intersect(temp, rows))
}

filterWireless <- function(input, temp) {
    rows <- temp
    if (input$wireless == "Yes") {
        rows <- which(keyboards$wireless == 1)
    }
    if (input$wireless == "No") {
        rows <- which(keyboards$wireless == 0)
    }
    return(intersect(temp, rows))
}

filterOnePiece <- function(input, temp) {
    rows <- temp
    if (input$onePiece == "One-piece") {
        rows <- which(keyboards$onePiece == 1)
    }
    if (input$onePiece == "Two halves") {
        rows <- which(keyboards$onePiece == 0)
    }
    return(intersect(temp, rows))
}

filterAvailability <- function(input, temp) {
    rows <- temp
    if (input$availability == "DIY") {
        rows <- which(keyboards$diy == 1)
    }
    if (input$availability == "Pre-built") {
        rows <- which(keyboards$prebuilt == 1)
    }
    return(intersect(temp, rows))
}

getImage <- function(id) {
    imagePath <- file.path('images', paste0(id, ".png"))
    return(image_read(imagePath))
}

getColorImage <- function(id, color) {
    image <- getImage(id)
    return(image_colorize(image, 100, color))
}

getImageList <- function(keyboards) {
    paths <- file.path('images', paste0(keyboards$id, ".png"))
    images <- list()
    for (i in seq_len(nrow(keyboards))) {
        images[[i]] <- image_read(paths[i])
    }
    names(images) <- keyboards$id
    return(images)
}
