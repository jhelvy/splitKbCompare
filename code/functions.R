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
    rowsNumKeys       <- which(keyboards$nKeysMax <= input$maxNumKeys)
    rowsNumberRow     <- filterNumberRow(input, rowsNumKeys)
    rowsColStagger    <- filterColStagger(input, rowsNumKeys)
    rowsRotarySupport <- filterRotarySupport(input, rowsNumKeys)
    rowsWireless      <- filterWireless(input, rowsNumKeys)
    rowsOnePiece      <- filterOnePiece(input, rowsNumKeys)
    rowsAvailability  <- filterAvailability(input, rowsNumKeys)
    rows <- intersect(rowsColStagger, 
                intersect(rowsRotarySupport,
                    intersect(rowsWireless,
                        intersect(rowsOnePiece,
                            intersect(rowsAvailability,
                                intersect(rowsNumKeys, rowsNumberRow))))))
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

filterWireless <- function(input, rows) {
    if (input$wireless == "Yes") {
        rows <- which(keyboards$wireless == 1)
    }
    if (input$wireless == "No") {
        rows <- which(keyboards$wireless == 0)
    }
    return(rows)
}

filterOnePiece <- function(input, rows) {
    if (input$onePiece == "One-piece") {
        rows <- which(keyboards$onePiece == 1)
    }
    if (input$onePiece == "Two halves") {
        rows <- which(keyboards$onePiece == 0)
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

getImage <- function(id) {
    imagePath <- file.path('images', paste0(id, ".png"))
    return(image_read(imagePath))
}

getColorImage <- function(id, color) {
    image <- getImage(id)
    return(image_colorize(image, 100, color))
}
