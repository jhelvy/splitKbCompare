# Load libraries, custom functions, and keyboard data
source(file.path('code', 'setup.R'))

ui <- navbarPage(title = "",
    theme = shinytheme("cyborg"),
    tabPanel(
        title = "Compare", 
        icon = icon(name = "balance-scale", lib = "font-awesome"),
        sidebarLayout(
            sidebarPanel(
                width = 3,
                # Sort list
                # Filter drop down menu
                h4("Filters"),
                dropdown(
                    label = "Number of Keys",
                    width = "200%",
                    sliderInput(
                        inputId = "numKeys",
                        label = NULL,
                        min   = min(keyboards$nKeysMin),
                        max   = max(keyboards$nKeysMax),
                        value = c(min(keyboards$nKeysMin), max(keyboards$nKeysMax)),
                        step  = 1)),
                dropdown(
                    label = "Number of Rows",
                    width = "200%",
                    sliderInput(
                        inputId = "numRows",
                        label = NULL,
                        min   = min(keyboards$numRows),
                        max   = max(keyboards$numRows),
                        value = c(min(keyboards$numRows), max(keyboards$numRows)),
                        step  = 1)),
                pickerInput(
                    inputId   = "hasNumRow",
                    choices   = list(
                        "Only with number row" = 1, 
                        "Only without number row" = 0
                    ),
                    multiple = TRUE,
                    options   = list(
                        `selected-text-format` = "static",
                        title = "Number Row"
                    )),
                pickerInput(
                    inputId   = "colStagger",
                    choices   = list("Aggressive", "Moderate", "None"),
                    multiple  = TRUE,
                    options   = list(
                        `selected-text-format` = "static",
                        title = "Column Stagger"
                    )),
                pickerInput(
                    inputId   = "rowStagger",
                    choices   = list("Yes" = 1, "No" = 0),
                    multiple  = TRUE,
                    options   = list(
                        `selected-text-format` = "static",
                        title = "Row Stagger"
                    )),
                pickerInput(
                    inputId   = "switchType",
                    choices   = list(
                        "Cherry MX" = "mxCompatible",
                        "Kailh Choc V1" = "chocV1",
                        "Kailh Choc V2" = "chocV2"
                    ),
                    multiple = TRUE,
                    options   = list(
                        `selected-text-format` = "static",
                        title = "Switch Type"
                    )),
                pickerInput(
                    inputId   = "rotaryEncoder",
                    choices   = list("Yes" = 1, "No" = 0),
                    multiple  = TRUE,
                    options   = list(
                        `selected-text-format` = "static",
                        title = "Rotary Encoder"
                    )),
                pickerInput(
                    inputId   = "wireless",
                    choices   = list("Yes" = 1, "No" = 0),
                    multiple  = TRUE,
                    options   = list(
                        `selected-text-format` = "static",
                        title = "Wireless"
                    )),
                pickerInput(
                    inputId   = "onePiece",
                    choices   = list("One-piece" = 1, "Two halves" = 0),
                    multiple  = TRUE,
                    options   = list(
                        `selected-text-format` = "static",
                        title = "One-piece"
                    )),
                pickerInput(
                    inputId   = "availability",
                    choices   = list("DIY" = "diy", "Pre-built" = "prebuilt"),
                    multiple  = TRUE,
                    options   = list(
                        `selected-text-format` = "static",
                        title = "Availability"
                    )),
                # Main keyboard selection options
                h4("Keyboards"),
                pickerInput(
                    inputId   = "sortKeyboards",
                    choices   = c("Name", "# Keys"),
                    selected  = "Name",
                    options   = list(
                        `selected-text-format` = "static",
                        title = "Sort"
                    ),
                    inline    = TRUE),
                actionButton(
                    inputId = "selectAll",
                    label   = NULL,
                    icon    = icon("check-square"),
                    inline = TRUE),
                actionButton(
                    inputId = "reset",
                    label   = NULL,
                    icon    = icon("undo"),
                    inline  = TRUE),
                prettyCheckboxGroup(
                    inputId   = "keyboard",
                    label     = '',
                    choices   = keyboards$nameKeys,
                    shape     = "curve",
                    outline   = TRUE,
                    animation = "pulse"),
                # Insert footer
                tags$div(HTML(paste(readLines(
                    file.path("includes", "footer.html")), collapse=" ")))
            ),
            mainPanel(
                # Print button
                downloadButton(
                    outputId = "printFile",
                    label    = "Print to scale (PDF)"),
                # Print/display option
                dropdown(
                    icon = icon("cog"),
                    prettyRadioButtons(
                        inputId   = "printSize",
                        label     = "Print size:",
                        choices   = list("A4" = "A4", "Letter (8.5x11)" = "Letter"),
                        selected  = "A4",
                        animation = "pulse"),
                    prettyRadioButtons(
                        inputId   = "printSepPages",
                        label     = "Print on seperate pages?",
                        choices   = list("Yes" = TRUE, "No" = FALSE),
                        selected  = FALSE,
                        animation = "pulse"),
                    prettyRadioButtons(
                        inputId = "keyboardHalf",
                        label   = "Keyboard half:",
                        choices = c("Left (mirrored)", "Right"),
                        selected = "Right",
                        animation = "pulse")
                ),
                # Add custom styling
                tags$head(tags$style(HTML(paste(readLines(
                    file.path("includes", "style.css")), collapse=" ")))),
                # Image
                imageOutput("layout")
            )
        )
    ),
    tabPanel("Keyboards",
        icon = icon(name = "keyboard", lib = "font-awesome"),
        mainPanel(width = 7,
            DT::dataTableOutput('keyboardsDT'),br(),
            # Insert footer
            tags$div(HTML(paste(readLines(
                file.path("includes", "footer.html")), collapse=" "))),br()
        )
    ),
    tabPanel(HTML('About</a></li><li><a href="https://github.com/jhelvy/splitKbCompare" target="_blank"><i class="fa fa-github fa-fw"></i>'),
        icon = icon(name = "question-circle", lib = "font-awesome"),
        mainPanel(width = 6,
            includeMarkdown("README.md"),br(),
            # Insert footer
            tags$div(HTML(paste(readLines(
                file.path("includes", "footer.html")), collapse=" "))),br()
        )
    )
)

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
    observeEvent("", {
        query <- parseQueryString(session$clientData$url_search)
        keyboardQuery <- query[['keyboards']]
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
    }, once = TRUE)

    # Render keyboard table on "Keyboards" page
    output$keyboardsDT <- DT::renderDataTable({
        DT::datatable(
            keyboardsDT,
            escape = FALSE,
            style = 'bootstrap',
            rownames = FALSE,
            options = list(pageLength = 50))
    })

    # Control reset button
    observeEvent(input$reset, {
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
        pickerIds <- c("hasNumRow", "colStagger", "rowStagger", "rotaryEncoder", 
                       "wireless", "onePiece", "availability", "switchType")
        for (id in pickerIds) {
            updatePickerInput(
                session = session,
                inputId = id,
                selected = character(0)
            )
        }
    }, ignoreInit = TRUE)

    # Control Select All button
    observeEvent(input$selectAll, {
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
    }, ignoreInit = TRUE)

    selectedIDs <- reactive({
        return(keyboards[which(keyboards$nameKeys %in% input$keyboard),]$id)
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
    output$layout <- renderImage({
        # Create the color image overlay
        overlayColor <- makeImageOverlay(images, palette, color = TRUE)
        # Mirror when left half is selected.
        if(input$keyboardHalf == "Left (mirrored)") overlayColor <- image_flop(overlayColor)
        # Define the path to the image
        tmpImagePathColor <- overlayColor %>%
            image_write(tempfile(fileext = 'png'), format = 'png')
        # Render the file
        return(list(src = tmpImagePathColor,
                    width = 700,
                    alt = "Keyboard layout",
                    contentType = "image/png"))

    }, deleteFile = TRUE)

    # Download overlay images
    output$printFile <- downloadHandler(
        filename = function() {
            selectedIDs_filename = paste(selectedIDs(), collapse='_')
            # Magic number but avoid crazily long output filename if many
            # keyboards. Could probably be set even smaller
            if (length(selectedIDs()) > 5) {
                selectedIDs_filename = "many"
            }
            paste0('compare_', selectedIDs_filename, '_', input$printSize, '.pdf')
        },
        content = function(file) {
            # Copy the file to a temporary directory before processing it,
            # in case we don't have write permissions to the current dir
            # (which can happen when deployed).
            tempReport <- file.path(tempdir(), "print.Rmd")
            file.copy(
                file.path("code", paste0('print', input$printSize, '.Rmd')), 
                tempReport, overwrite = TRUE)
            
            
            # Want to support one-page all-overlapping visualization as well
            # as single keyboards. So pass a list of {keyboard groups} where
            # a keyboard group can have any number of keyboards
            
            # Default is one big group so one list of list
            # If only one selected, all overlay = separate page anyway,
            # so don't print redundant page even if sepPages is set
            if(input$printSepPages == FALSE || length(selectedIDs()) == 1){
                id_groups = list(selectedIDs())
            }else{
                # First page is all overlay like normal
                # Then subsequent pages is each keyb individually
                id_groups = c(list(selectedIDs()),
                              selectedIDs())
            }
            
            # Hold path to the image generated for each id_group
            id_group_paths = c()
            for(gp in id_groups){
                # Create the black and white image overlay
                overlayBw <- makeImageOverlay(images, palette,
                                              color = FALSE, IDs = gp)
                
                # Mirror when left half is selected.
                if(input$keyboardHalf== "Left (mirrored)") overlayBw <- image_flop(overlayBw)
                
                # Define the path to the image
                tmpImagePathBw <- overlayBw %>%
                    image_write(tempfile(fileext = '.png'),
                                format = 'png')
                
                id_group_paths = c(id_group_paths,
                                   tmpImagePathBw)
            }
            # Prepare the path to be passed to the Rmd file
            params <- list(path = id_group_paths)
            
            # Knit the document, passing in the `params` list, and eval it 
            # in a child of the global environment (this isolates the code 
            # in the document from the code in this app).
            rmarkdown::render(
                tempReport, output_file = file, params = params, 
                envir = new.env(parent = globalenv())
            )
        }
    )
}

shinyApp(ui = ui, server = server)
