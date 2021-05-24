loadImages <- function() {
    imageNames <- c(paste0(keyboards$id, ".png"), "bg-white.png", "bg-black.png")
    imagePaths <- file.path("images", imageNames)
    images <- as.list(image_read(imagePaths))
    names(images) <- c(keyboards$id, "bg_white", "bg_black")
    return(images)
}

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

getImage <- function(images, id) {
    return(images[id])
}

getColorImage <- function(images, id, color) {
    image <- getImage(images, id)
    return(image_colorize(image, 100, color))
}
