source(file.path('code', 'config.R'))
source(file.path('code', 'functions.R'))

ui <- navbarPage(title = "",
    theme = shinytheme("cyborg"),
    tabPanel("Compare", icon = icon(name = "balance-scale", lib = "font-awesome"),
        sidebarLayout(
            sidebarPanel(
                width = 3,
                # Filter drop down menu
                h4("Select keyboards:"),
                div(style="display: inline-block;vertical-align:top;",
                dropdown(
                    label = "Filters",
                    sliderInput(
                        inputId = "maxNumKeys",
                        label = "Max number of keys:",
                        min   = min(keyboards$nKeysMin),
                        max   = max(keyboards$nKeysMax),
                        value = max(keyboards$nKeysMax),
                        step  = 1),
                    prettyRadioButtons(
                        inputId   = "hasNumberRow",
                        label     = "Number row:",
                        choices   = c("All", "Only with number row", "Only without number row"),
                        animation = "pulse"),
                    prettyRadioButtons(
                        inputId   = "colStagger",
                        label     = "Column stagger:",
                        choices   = c("All", "Aggressive", "Moderate", "None"),
                        animation = "pulse"),
                    prettyRadioButtons(
                        inputId   = "rotaryEncoder",
                        label     = "Rotary encoder support:",
                        choices   = c("All", "Yes", "No"),
                        animation = "pulse"),
                    prettyRadioButtons(
                        inputId   = "wireless",
                        label     = "Wireless:",
                        choices   = c("All", "Yes", "No"),
                        animation = "pulse"),
                    prettyRadioButtons(
                        inputId   = "onePiece",
                        label     = "One-piece board?:",
                        choices   = c("All", "One-piece", "Two halves"),
                        animation = "pulse"),
                    prettyRadioButtons(
                        inputId   = "availability",
                        label     = "Availability:",
                        choices   = c("All", "DIY", "Pre-built"),
                        animation = "pulse")
                )),
                div(style="display: inline-block;vertical-align:top;",
                    actionButton(
                        inputId = "reset",
                        label   = "Reset")),
                # Main keyboard selection options
                prettyCheckboxGroup(
                    inputId   = "keyboards",
                    label     = '',
                    choices   = keyboards$nameKeys,
                    shape     = "curve",
                    outline   = TRUE,
                    animation = "pulse"),
                # Print buttons
                h4("Print to scale:"),
                downloadButton(
                    outputId = "printLetter",
                    label    = "8.5x11"),
                downloadButton(
                    outputId = "printA4",
                    label    = "A4"),
                br(),br(),
                # Insert footer
                tags$div(HTML(paste(readLines(
                    file.path("includes", "footer.html")), collapse=" ")))
            ),
            mainPanel(
                # Add custom styling
                tags$head(tags$style(HTML(paste(readLines(
                    file.path("includes", "style.css")), collapse=" ")))),
                imageOutput("layout")
            )
        )
    ),
    tabPanel("Keyboards",
        icon = icon(name = "keyboard", lib = "font-awesome"),
        mainPanel(width = 7,
            DT::dataTableOutput('keyboardTable'),br(),
            # Insert footer
            tags$div(HTML(paste(readLines(
                file.path("includes", "footer.html")), collapse=" "))),br()
        )
    ),
    tabPanel("About",
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

    # Filter keyboard options based on filter options
    observe({
        filteredRows <- getFilteredRows(input)
        updatePrettyCheckboxGroup(
            session = session,
            inputId = "keyboards",
            choices = keyboards$nameKeys[filteredRows],
            prettyOptions = list(shape = "curve", outline = TRUE, animation = "pulse")
        )
    })

    # Set Kyria as initial starting layout
    observeEvent("", {
        updatePrettyCheckboxGroup(
            session = session,
            inputId = "keyboards",
            choices   = keyboards$nameKeys,
            selected = "Kyria (46 - 50)",
            prettyOptions = list(shape = "curve", outline = TRUE, animation = "pulse")
        )
    }, once = TRUE)

    # Render keyboard table on "Keyboards" page
    output$keyboardTable <- DT::renderDataTable({
        DT::datatable(
            keyboardTable,
            escape = FALSE,
            style = 'bootstrap',
            rownames = FALSE,
            options = list(pageLength = 50))
    })

    # Control reset button
    observeEvent(input$reset, {
        updateSliderInput(
            session = session,
            inputId = "maxNumKeys",
            value   = max(keyboards$nKeysMax)
        )
        updatePrettyCheckboxGroup(
            session = session,
            inputId = "keyboards",
            choices = keyboards$nameKeys
        )
        updatePrettyRadioButtons(
            session  = session,
            inputId  = "hasNumberRow",
            selected = "All"
        )
        updatePrettyRadioButtons(
            session  = session,
            inputId  = "colStagger",
            selected = "All"
        )
        updatePrettyRadioButtons(
            session  = session,
            inputId  = "rotaryEncoder",
            selected = "All"
        )
        updatePrettyRadioButtons(
            session  = session,
            inputId  = "wireless",
            selected = "All"
        )
        updatePrettyRadioButtons(
            session  = session,
            inputId  = "onePiece",
            selected = "All"
        )
        updatePrettyRadioButtons(
            session  = session,
            inputId  = "availability",
            selected = "All"
        )
    }, ignoreInit = TRUE)

    selectedIDs <- reactive({
        names <- input$keyboards
        return(keyboards[which(keyboards$nameKeys %in% names),]$id)
    })

    makeImageOverlay <- function(color = FALSE) {
        ids <- selectedIDs()
        bg  <- 'bg-white.png'
        if (color) {
            bg <- 'bg-black.png'
            colors <- palette[1:length(ids)]
        }
        overlay <- image_read(file.path('images', bg))
        if (length(ids) > 0) {
            for (i in 1:length(ids)) {
                id <- ids[i]
                if (color) {
                    image <- getColorImage(id, colors[i])
                } else {
                    image <- getImage(id)
                }
                overlay <- c(overlay, image)
            }
        }
        return(image_mosaic(image_join(overlay)))
    }

    # Render overlay image
    output$layout <- renderImage({
        # Create the color image overlay
        overlayColor <- makeImageOverlay(color = TRUE)
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
    downloadImage <- function(size) {
        template <- 'printLetter.Rmd'
        sizeName <- '_8.5x11.pdf'
        if (size == 'a4') {
            template <- 'printA4.Rmd'
            sizeName <- '_a4.pdf'
        }
        downloadHandler(
            filename = function() {
                paste0('compare_', paste(selectedIDs(), collapse='_'), sizeName)
            },
            content = function(file) {
                # Copy the report file to a temporary directory before processing it,
                # in case we don't have write permissions to the current working dir
                # (which can happen when deployed).
                tempReport <- file.path(tempdir(), "print.Rmd")
                file.copy(file.path("code", template), tempReport, overwrite = TRUE)
                # Create the black and white image overlay
                overlayBw <- makeImageOverlay()
                # Define the path to the image
                tmpImagePathBw <- overlayBw %>%
                    image_write(tempfile(fileext = 'png'), format = 'png')
                # Prepare the path to be passed to the Rmd file
                params <- list(path = tmpImagePathBw)
                # Knit the document, passing in the `params` list, and eval it in a
                # child of the global environment (this isolates the code in the document
                # from the code in this app).
                rmarkdown::render(tempReport, output_file = file,
                                  params = params, envir = new.env(parent = globalenv())
                )
            }
        )
    }

    output$printLetter <- downloadImage('letter')
    output$printA4 <- downloadImage('a4')
}

shinyApp(ui = ui, server = server, options = list(launch.browser = TRUE))
