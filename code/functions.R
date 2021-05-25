# Loads the keyboards.csv file as a data frame
loadKeyboards <- function() {
    keyboards <- readr::read_csv('keyboards.csv') %>%
        filter(include == 1) %>%
        mutate(nameKeys = ifelse(nKeysMin == nKeysMax,
            paste0(name, ' (', nKeysMin, ')'),
            paste0(name, ' (', nKeysMin, ' - ', nKeysMax, ')'))) %>%
        arrange(id, desc(nKeysMax), desc(nKeysMin))
    return(keyboards)
}

# Create DT of keyboard table for "Keyboards" page
loadKeyboardsDT <- function(keyboards) {
    check <- '✓'
    keyboardsDT <- keyboards %>%
        rename("Name" = name) %>%
        mutate(`# of keys` = ifelse(
            nKeysMin == nKeysMax, nKeysMin,
            paste(nKeysMin, nKeysMax, sep = ' - ')),
            `# of rows`            = numRows,
            `Column stagger`       = colStagger,
            `Row stagger?`         = ifelse(rowStagger == 1, check, ''),
            `Number row?`          = ifelse(hasNumRow == 1, check, ''),
            `Available DIY?`       = ifelse(diy == 1, check, ''),
            `Available pre-built?` = ifelse(prebuilt == 1, check, ''),
            `Rotary encoder?`      = ifelse(rotaryEncoder == 1, check, ''),
            `Wireless?`            = ifelse(wireless == 1, check, ''),
            `One-piece board?`     = ifelse(onePiece == 1, check, ''),
            url_source = ifelse(
                is.na(url_source), '',
                paste0(
                    '<a href="', url_source,
                    '" target="_blank"><i class="fa fa-github"></i></a> '
                )
            ),
            url_store = ifelse(
                is.na(url_store), '',
                paste0(
                    '<a href="', url_store,
                    '" target="_blank"><i class="fa fa-shopping-cart"></i></a> '
                )
            ),
            Links = paste0(url_source, url_store)) %>%
        select(
            Name, `# of keys`, `# of rows`, `Column stagger`, `Row stagger?`,
            `Number row?`, `Available DIY?`,`Available pre-built?`,
            `Rotary encoder?`, `Wireless?`, `One-piece board?`, Links)
    return(keyboardsDT)
}

# Loads all svg images as a named list of pngs
loadImages <- function() {
    imageNames <- list.files(file.path('images', 'png'))
    imagePaths <- file.path('images', 'png', imageNames)
    images <- as.list(image_read(imagePaths))
    names(images) <- fs::path_ext_remove(imageNames)
    # Make black background image
    scale_black <- image_colorize(images$scale, opacity = 100, color = "#fff")
    scale_black <- image_background(scale_black, color = "#000", flatten = TRUE)
    images[["scale_black"]] <- scale_black
    return(images)
}

# Load color palette
loadColorPalette <- function() {
    # OPTION 1
    palette1 <- c('white', RColorBrewer::brewer.pal(n = 8, name = "Dark2"))
    
    # OPTION 2
    # Source: https://sashat.me/2017/01/11/list-of-20-simple-distinct-colors/
    palette2 <- c(
        "#FFFFFF", "#E6194B", "#FFE119", "#3CB44B", "#4363D8", "#F58231",
        "#911EB4", "#46F0F0", "#BCF60C", "#FABEBE", "#008080", "#E6BEFF",
        "#9A6324", "#FFFAC8", "#AAFFC3", "#808000", "#FFD8B1", "#F032E6",
        "#800000", "#000075")
    
    # OPTION 3
    # palette <- pals::polychrome()
    # badColors <- c('#5A5156', '#325A9B', '#B00068', '#85660D', '#1C8356', '#B10DA1')
    # palette <- palette[-which(palette %in% badColors)]
    palette3 <- c(
        "#E4E1E3", "#F6222E", "#16FF32", "#3283FE", "#FEAF16", "#FE00FA",
        "#1CFFCE", "#90AD1C", "#2ED9FF", "#DEA0FD", "#AA0DFE", "#F8A19F",
        "#C4451C", "#FBE426", "#1CBE4F", "#FA0087", "#FC1CBF", "#F7E1A0",
        "#C075A6", "#782AB6", "#AAF400", "#BDCDFF", "#822E1C", "#B5EFB5",
        "#7ED7D1", "#1C7F93", "#D85FF7", "#683B79", "#66B0FF", "#3B00FB")
    
    return(palette2)
}

# Controls which keyboards to show based on filter controls
getKeyboardNames <- function(input, keyboards) {
    filteredRows <- getFilteredRows(input, keyboards)
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

getFilteredRows <- function(input, keyboards) {
    rows <- filterNumKeys(input, keyboards)
    rows <- filterNumRows(input, keyboards, rows)
    rows <- filterNumberRow(input, keyboards, rows)
    rows <- filterColStagger(input, keyboards, rows)
    rows <- filterRowStagger(input, keyboards, rows)
    rows <- filterRotarySupport(input, keyboards, rows)
    rows <- filterWireless(input, keyboards, rows)
    rows <- filterOnePiece(input, keyboards, rows)
    rows <- filterAvailability(input, keyboards, rows)
    return(rows)
}

filterNumKeys <- function(input, keyboards) {
    return(which(keyboards$nKeysMax <= input$maxNumKeys))
}

filterNumRows <- function(input, keyboards, temp) {
    rows <- which(keyboards$numRows <= input$maxNumRows)
    return(intersect(temp, rows))
}

filterNumberRow <- function(input, keyboards, temp) {
    rows <- temp
    if (input$hasNumberRow == "Only with number row") {
        rows <- which(keyboards$hasNumRow == 1)
    }
    if (input$hasNumberRow == "Only without number row") {
        rows <- which(keyboards$hasNumRow == 0)
    }
    return(intersect(temp, rows))
}

filterColStagger <- function(input, keyboards, temp) {
    rows <- temp
    if (input$colStagger != "All") {
        rows <- which(keyboards$colStagger == input$colStagger)
    }
    return(intersect(temp, rows))
}

filterRowStagger <- function(input, keyboards, temp) {
    rows <- temp
    if (input$rowStagger == "Yes") {
        rows <- which(keyboards$rowStagger == 1)
    }
    if (input$rowStagger == "No") {
        rows <- which(keyboards$rowStagger == 0)
    }
    return(intersect(temp, rows))
}

filterRotarySupport <- function(input, keyboards, temp) {
    rows <- temp
    if (input$rotaryEncoder == "Yes") {
        rows <- which(keyboards$rotaryEncoder == 1)
    }
    if (input$rotaryEncoder == "No") {
        rows <- which(keyboards$rotaryEncoder == 0)
    }
    return(intersect(temp, rows))
}

filterWireless <- function(input, keyboards, temp) {
    rows <- temp
    if (input$wireless == "Yes") {
        rows <- which(keyboards$wireless == 1)
    }
    if (input$wireless == "No") {
        rows <- which(keyboards$wireless == 0)
    }
    return(intersect(temp, rows))
}

filterOnePiece <- function(input, keyboards, temp) {
    rows <- temp
    if (input$onePiece == "One-piece") {
        rows <- which(keyboards$onePiece == 1)
    }
    if (input$onePiece == "Two halves") {
        rows <- which(keyboards$onePiece == 0)
    }
    return(intersect(temp, rows))
}

filterAvailability <- function(input, keyboards, temp) {
    rows <- temp
    if (input$availability == "DIY") {
        rows <- which(keyboards$diy == 1)
    }
    if (input$availability == "Pre-built") {
        rows <- which(keyboards$prebuilt == 1)
    }
    return(intersect(temp, rows))
}

# Functions for creating the merged image overlays
getImageOverlayColor <- function(ids, images, palette) {
    colors <- c(palette[1:length(ids)], "white")
    ids <- c(ids, "border")
    i <- 1
    overlay <- images$scale_black
    for (id in ids) {
        image <- image_colorize(images[[id]], opacity = 100, color = colors[i])
        overlay <- c(overlay, image)
        i <- i + 1
    }
    return(image_mosaic(image_join(overlay)))
}

getImageOverlay <- function(ids, images) {
    ids <- c("scale", ids)
    return(image_mosaic(image_join(images[ids])))
}
