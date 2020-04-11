source(file.path('code', 'config.R'))
source(file.path('code', 'functions.R'))

ui <- navbarPage(title = "",
    theme = shinytheme("cyborg"),
    tabPanel("Compare", icon = icon(name = "balance-scale", lib = "font-awesome"),
        sidebarLayout(
            sidebarPanel(
                width = 3,
                # Filter drop down menu
                div(style="display: inline-block;vertical-align:top;",
                dropdown(
                    label = "Filters",
                    prettyRadioButtons(
                        inputId   = "hasNumberRow",
                        label     = "Number row:",
                        choices   = c("All", "Only with number row", "Only without number row"),
                        selected  = "All",
                        animation = "pulse"),
                    prettyRadioButtons(
                        inputId   = "colStagger",
                        label     = "Column stagger:",
                        choices   = c("All", "Strong", "Moderate", "None"),
                        selected  = "All",
                        animation = "pulse"),
                    prettyRadioButtons(
                        inputId   = "availability",
                        label     = "Availability:",
                        choices   = c("All", "DIY", "Pre-built"),
                        selected  = "All",
                        animation = "pulse"),
                    sliderInput(
                        inputId = "maxNumKeys",
                        label = "Max number of keys:",
                        min   = min(keyboards$nKeysMin),
                        max   = max(keyboards$nKeysMax),
                        value = max(keyboards$nKeysMax),
                        step  = 1)
                )),
                div(style="display: inline-block;vertical-align:top; width: 7px;",HTML("<br>")),
                # Print button
                div(style="display: inline-block;vertical-align:top;",
                    downloadButton(
                        outputId = "print",
                        label    = "Print to scale")),
                # Main keyboard selection options
                prettyCheckboxGroup(
                    inputId   = "keyboards",
                    label     = HTML('<h4>Select keyboards:</h4>'),
                    choices   = keyboards$nameKeys,
                    shape     = "curve",
                    outline   = TRUE,
                    animation = "pulse"),
                actionButton(
                    inputId = "reset",
                    label   = "Reset"),
                br(),br(),
                # Insert footer
                tags$div(HTML(paste(readLines(
                    file.path("html", "footer.html")), collapse=" ")))
            ),
            mainPanel(
                # Add custom styling
                tags$head(tags$style(HTML(paste(readLines(
                    file.path("html", "style.css")), collapse=" ")))),
                imageOutput("layout")
            )
        )
    ),
    tabPanel("Keyboards",
        icon = icon(name = "keyboard", lib = "font-awesome"),
        mainPanel(width = 6,
            includeMarkdown(file.path("pages", "keyboards.md")),br(),
            # Insert footer
            tags$div(HTML(paste(readLines(
                file.path("html", "footer.html")), collapse=" "))),br()
        )
    ),
    tabPanel("About",
        icon = icon(name = "question-circle", lib = "font-awesome"),
        mainPanel(width = 6,
            includeMarkdown(file.path("pages", "about.md")),br(),
            # Insert footer
            tags$div(HTML(paste(readLines(
                file.path("html", "footer.html")), collapse=" "))),br()
        )
    )
)

server <- function(input, output, session) {

    # Control reset button
    observeEvent(input$reset, {
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
            inputId  = "availability",
            selected = "All"
        )
        updateSliderInput(
            session = session,
            inputId = "maxNumKeys",
            value   = max(keyboards$nKeysMax)
        )
    }, ignoreInit = TRUE)

    # Filter keyboard options based on filter options
    observe({
        ids <- getFilteredIDs(input, keyboards)
        updatePrettyCheckboxGroup(
            session = session,
            inputId = "keyboards",
            choices = keyboards$nameKeys[ids],
            prettyOptions = list(animation = "pulse", shape = "curve")
        )
    })

    output$layout <- renderImage({

        # Create the color image overlay
        ids <- getKeyboardIDs(input, keyboards)
        colors <- palette[1:length(ids)]
        overlayColor <- makeImageOverlay(ids, colors)

        # Define the path to the image
        tmpImagePathColor <- overlayColor %>%
            image_write(tempfile(fileext = 'png'), format = 'png')

        # Render the file
        return(list(src = tmpImagePathColor,
                    width = 700,
                    alt = "Keyboard layout",
                    contentType = "image/png"))

    }, deleteFile = TRUE)

    output$print <- downloadHandler(

        filename = "splitKbComparison.pdf",

        content = function(file) {
            # Copy the report file to a temporary directory before processing it,
            # in case we don't have write permissions to the current working dir
            # (which can happen when deployed).
            tempReport <- file.path(tempdir(), "print.Rmd")
            file.copy(file.path("code", "print.Rmd"), tempReport, overwrite = TRUE)

            # Create the black and white image overlay
            ids <- getKeyboardIDs(input, keyboards)
            overlayBw <- makeImageOverlay(ids)

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

shinyApp(ui = ui, server = server)
