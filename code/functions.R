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
            `Cherry MX?`           = ifelse(mxCompatible == 1, check, ''),
            `Kailh Choc V1?`       = ifelse(chocV1 == 1, check, ''),
            `Kailh Choc V2?`       = ifelse(chocV2 == 1, check, ''),
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
            pdf_path_a4 = paste0(
                '<a href="pdf/a4/', id,
                '.pdf" target="_blank" title="A4"><i class="fa fa-file-pdf-o"></i></a> '
            ),
            pdf_path_letter = paste0(
                '<a href="pdf/letter/', id,
                '.pdf" target="_blank" title="Letter"><i class="fa fa-file-pdf-o"></i></a> '
            ),
            Links = paste0(url_source, url_store),
            PDF = paste(pdf_path_a4, pdf_path_letter)) %>%
        select(
            Name, `# of keys`, `# of rows`, `Column stagger`, `Row stagger?`,
            `Number row?`, `Available DIY?`,`Available pre-built?`,
            `Rotary encoder?`, `Wireless?`, `One-piece board?`, `Cherry MX?`,
            `Kailh Choc V1?`,`Kailh Choc V2?`, Links, PDF)
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
getFilteredKeyboardNames <- function(input, keyboards) {
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
    # Find active one variable filters
    # One variable filters are based on only one column in the dataset
    # e.g. Wireless with only the wireless (0, 1) column
    oneVarFilterIds <- c("hasNumRow", "colStagger", "rowStagger", 
                         "rotaryEncoder", "wireless", "onePiece")
    oneVarInputs <- sapply(oneVarFilterIds, function(id) input[[id]])
    activeOneVar <- oneVarInputs[sapply(oneVarInputs, isTruthy)]
    
    # Make logicals assuming inputId corresponds with column and reactive value
    # corresponds with desired value in column.
    if (length(activeOneVar) > 0) {
        oneVarLogical <- mapply(
            function(inputId, reactiveVal) keyboards[[inputId]] %in% reactiveVal,
            inputId = names(activeOneVar),
            reactiveVal = activeOneVar,
            SIMPLIFY = FALSE
        )
    } else { 
        oneVarLogical <- NULL 
    }
    
    # Find active multi variable filters
    # Multi variable filters are based on multiple columns in the dataset
    # e.g. Switch Type with mxCompatible, chocV1 & chocV2
    multiVarFilterIds <- c("availability", "switchType")
    multiVarInputs <- sapply(multiVarFilterIds, function(id) input[[id]])
    activeMultiVar <- multiVarInputs[sapply(multiVarInputs, isTruthy)]

    # Make logicals assuming reactive value corresponds with column and that
    # column is logical.
    if (length(activeMultiVar) > 0) {
        multiVarLogical <- list(
            apply(
                X = keyboards[, unlist(activeMultiVar)] == 1,
                MARGIN = 1,
                FUN = all
            )
        )
    } else { 
        multiVarLogical <- NULL 
    }
    
    # Make logicals from rangeFilters (always active)
    rangeFilters <- list(
        keyboards$nKeysMin >= input$numKeys[[1]] & 
            keyboards$nKeysMax <= input$numKeys[[2]] &
            keyboards$numRows >= input$numRows[[1]] &
            keyboards$numRows <= input$numRows[[2]]
    )
    
    # Combine all logicals and find rows that are TRUE across all filters
    allFilters <- Reduce(`&`, c(rangeFilters, multiVarLogical, oneVarLogical))
    rows <- which(allFilters)
    
    return(rows)
}

# Functions for creating the merged image overlays
getImageOverlayColor <- function(ids, images, palette) {
    # Don't want to select an index past palette's length
    # So modulo the required indices around palette's length
    # (Note this will select the same color multiple times but it gets so hectic
    # it's unnoticable)
    colors <- c(palette[
                  # Modulo works nicely with 0-indexed not 1 indexed indices, so
                  # convert -> 0-indexed and then back
                  ((seq_along(ids) - 1) %% length(palette)) + 1
                ],
                "white")

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
