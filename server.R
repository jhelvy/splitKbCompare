
server <- function(input, output, session) {

    # Add pdf folder as ResourcePath
    addResourcePath(prefix = "pdf", directoryPath = file.path("images", "pdf"))

    # Filter keyboard options based on filter options
    observe({
        keyboardNames <- getFilteredKeyboardNames(input, keyboards)
        updatePrettyCheckboxGroup(
            session = session,
            inputId = "keyboard",
            choices = keyboardNames,
            prettyOptions = list(shape = "curve", outline = TRUE, animation = "pulse")
        )
    })

    # Set initial starting layout based on url parameter
    observeEvent("",
        {
            query <- parseQueryString(session$clientData$url_search)
            keyboardQuery <- query[["keyboards"]]
            if (is.null(keyboardQuery)) {
                keyboardNames <- "kyria"
            } else if (grepl(";", keyboardQuery)) {
                keyboardNames <- strsplit(keyboardQuery, ";")[[1]]
            } else {
                keyboardNames <- keyboardQuery
            }
            updatePrettyCheckboxGroup(
                session = session,
                inputId = "keyboard",
                choices = keyboards$nameKeys,
                selected = keyboards$nameKeys[which(keyboards$id %in% keyboardNames)],
                prettyOptions = list(shape = "curve", outline = TRUE, animation = "pulse")
            )
        },
        once = TRUE
    )

    # Render keyboard table on "Keyboards" page
    output$keyboardsDT <- DT::renderDataTable({
        DT::datatable(
            keyboardsDT,
            escape = FALSE,
            style = "bootstrap",
            rownames = FALSE,
            options = list(pageLength = 50)
        )
    })

    # Control reset button
    observeEvent(input$reset,
        {
            updateSliderInput(
                session = session,
                inputId = "numKeys",
                value   = c(min(keyboards$nKeysMin), max(keyboards$nKeysMax))
            )
            updateSliderInput(
                session = session,
                inputId = "numRows",
                value   = c(min(keyboards$numRows), max(keyboards$numRows))
            )
            updatePrettyCheckboxGroup(
                session = session,
                inputId = "keyboard",
                choices = keyboards$nameKeys
            )
            pickerIds <- c(
                "hasNumRow", "colStagger", "rowStagger", "rotaryEncoder",
                "wireless", "onePiece", "availability", "switchType"
            )
            for (id in pickerIds) {
                updatePickerInput(
                    session = session,
                    inputId = id,
                    selected = character(0)
                )
            }
        },
        ignoreInit = TRUE
    )

    # Control Select All button
    observeEvent(
        input$selectAll,
        {
            # Select all displayed (filtered) keyboards
            # Identical to filtering step but also set selected=`choices list`.
            keyboardNames <- getFilteredKeyboardNames(input, keyboards)
            updatePrettyCheckboxGroup(
                session = session,
                inputId = "keyboard",
                choices = keyboardNames,
                selected = keyboardNames,
                prettyOptions = list(shape = "curve", outline = TRUE, animation = "pulse")
            )
        },
        ignoreInit = TRUE
    )

    selectedIDs <- reactive({
        return(keyboards[which(keyboards$nameKeys %in% input$keyboard), ]$id)
    })

    # Create joint overlay image
    # If IDs isn't given, then uses the usual all-selected But can also get just
    # a subset of (selected) keyboards
    makeImageOverlay <- function(images, palette, color = FALSE, IDs = selectedIDs()) {
        if (length(IDs) > 0) {
            if (color) {
                return(getImageOverlayColor(IDs, images, palette))
            } else {
                return(getImageOverlay(IDs, images))
            }
        }
        return(images$scale_black)
    }

    # Render overlay image
    output$layout <- renderImage(
        {
            # Create the color image overlay
            overlayColor <- makeImageOverlay(images, palette, color = TRUE)
            # Mirror when left half is selected.
            if (input$keyboardHalf == "Left (mirrored)") overlayColor <- image_flop(overlayColor)
            # Define the path to the image
            tmpImagePathColor <- overlayColor %>%
                image_write(tempfile(fileext = "png"), format = "png")
            # Render the file
            return(
                list(
                    src = tmpImagePathColor,
                    width = 700,
                    alt = "Keyboard layout",
                    contentType = "image/png"
                )
            )
        },
        deleteFile = TRUE
    )

    # Download overlay images
    output$printFile <- downloadHandler(
        filename = function() {
            selectedIDs_filename <- paste(selectedIDs(), collapse = "_")
            # Magic number but avoid crazily long output filename if many
            # keyboards. Could probably be set even smaller
            if (length(selectedIDs()) > 5) selectedIDs_filename <- "many"
            paste0("compare_", selectedIDs_filename, "_", input$printSize, ".pdf")
        },
        content = function(file) {
            # Copy the file to a temporary directory before processing it,
            # in case we don't have write permissions to the current dir
            # (which can happen when deployed).
            tempReport <- file.path(tempdir(), "print.Rmd")
            file.copy(
                file.path("code", paste0("print", input$printSize, ".Rmd")),
                tempReport,
                overwrite = TRUE
            )

            # Want to support one-page all-overlapping visualization as well
            # as single keyboards. So pass a list of {keyboard groups} where
            # a keyboard group can have any number of keyboards

            # Default is one big group so one list of list
            # If only one selected, all overlay = separate page anyway,
            # so don't print redundant page even if sepPages is set
            if (input$printSepPages == FALSE || length(selectedIDs()) == 1) {
                id_groups <- list(selectedIDs())
            } else {
                # First page is all overlay like normal
                # Then subsequent pages is each keyb individually
                id_groups <- c(list(selectedIDs()), selectedIDs())
            }

            # Hold path to the image generated for each id_group
            id_group_paths <- c()
            for (gp in id_groups) {
                # Create the black and white image overlay
                overlayBw <- makeImageOverlay(images, palette, color = FALSE, IDs = gp)

                # Mirror when left half is selected.
                if (input$keyboardHalf == "Left (mirrored)") overlayBw <- image_flop(overlayBw)

                # Define the path to the image
                tmpImagePathBw <- overlayBw %>%
                    image_write(
                        tempfile(fileext = ".png"),
                        format = "png"
                    )

                id_group_paths <- c(
                    id_group_paths,
                    tmpImagePathBw
                )
            }
            # Prepare the path to be passed to the Rmd file
            params <- list(path = id_group_paths)

            # Knit the document, passing in the `params` list, and eval it
            # in a child of the global environment (this isolates the code
            # in the document from the code in this app).
            rmarkdown::render(
                tempReport,
                output_file = file,
                params = params,
                envir = new.env(parent = globalenv())
            )
        }
    )
}

