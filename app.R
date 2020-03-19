source('config.R')
source('functions.R')

# Create the UI
ui <- fluidPage(

    # Edit CSS styling
    tags$style("
        @import url(https://fonts.googleapis.com/css?family=Exo);
        .well {
            color: #FFF;
            background-color: #1A1917;
            width: 180px;
        }
        h1, h2, h3 {
            color: #FFF;
            font-family: 'Exo';
            font-weight: 500;
            margin-bottom: 20px;
        }
        .col-sm-2 {
            color: #FFF;
            font-family: 'Exo';
        }"),

    setBackgroundColor(
        color = "black"
    ),

    titlePanel("Split keyboard comparison"),

    sidebarLayout(
        sidebarPanel(
            width = 3,
            prettyCheckboxGroup(
                inputId   = 'keyboards',
                label     = 'Select keyboards',
                choices   = keyboards$name,
                shape     = "curve",
                animation = "pulse"),
            actionButton(inputId = "reset", label = "Reset"),
            downloadButton("print", "Print"),
            br(),
            br(),
            tags$div(HTML('
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                <a href="https://github.com/jhelvy/splitKbCompare">
                <i class="fa fa-github" style="color:white;"></i></a>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                <a href="https://creativecommons.org/licenses/by/4.0/">
                <i class="fa fa-creative-commons" style="color:white;"></i></a>')),
            br(), 
            tags$div(HTML('
                <p>
                Built with
                <a href="https://shiny.rstudio.com/">
                <img alt="Shiny" src="https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png" height="20">
                </a></p>')),
        ),
        mainPanel(
            imageOutput("layout")
        )
    )
)

server <- function(input, output, session) {

    observeEvent(input$reset, {
        updatePrettyCheckboxGroup(
            session = session, 
            inputId = "keyboards",
            choices = keyboards$name, 
            prettyOptions = list(animation = "pulse", shape = "curve")
        )
    }, ignoreInit = TRUE)
  
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
                    width = 600,
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
        file.copy("print.Rmd", tempReport, overwrite = TRUE)

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
