source('config.R')
source('functions.R')

# Create the UI
ui <- fluidPage(

    # Edit CSS styling
    tags$style("
        @import url(https://fonts.googleapis.com/css?family=Exo);
        .well {
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

            prettyCheckbox(
                inputId   = keyboards$id[1],
                label     = tags$span(style = keyboards$label[1],
                                      keyboards$name[1]),
                value     = TRUE,
                shape     = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId   = keyboards$id[2],
                label     = tags$span(style = keyboards$label[2],
                                      keyboards$name[2]),
                value     = FALSE,
                shape     = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId   = keyboards$id[3],
                label     = tags$span(style = keyboards$label[3],
                                      keyboards$name[3]),
                value     = FALSE,
                shape     = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId   = keyboards$id[4],
                label     = tags$span(style = keyboards$label[4],
                                      keyboards$name[4]),
                value     = FALSE,
                shape     = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId   = keyboards$id[5],
                label     = tags$span(style = keyboards$label[5],
                                      keyboards$name[5]),
                value     = FALSE,
                shape     = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId   = keyboards$id[6],
                label     = tags$span(style = keyboards$label[6],
                                      keyboards$name[6]),
                value     = FALSE,
                shape     = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId   = keyboards$id[7],
                label     = tags$span(style = keyboards$label[7],
                                      keyboards$name[7]),
                value     = FALSE,
                shape     = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId   = keyboards$id[8],
                label     = tags$span(style = keyboards$label[8],
                                      keyboards$name[8]),
                value     = FALSE,
                shape     = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId   = keyboards$id[9],
                label     = tags$span(style = keyboards$label[9],
                                      keyboards$name[9]),
                value     = FALSE,
                shape     = "curve",
                animation = "pulse"),

            tags$div(HTML('
                <br>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                <a href="https://github.com/jhelvy/splitKbCompare">
                <i class="fa fa-github" style="color:white;"></i></a>
                <br><br>')),

            downloadButton("print", "Print")
        ),

        mainPanel(

            imageOutput("layout")
        )

    )
)

server <- function(input, output) {

    output$layout <- renderImage({

        # Create the color image overlay
        ids <- getInputIDs(input, keyboards)
        overlayColor <- makeImageOverlay(ids, keyboards, color = T)

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
        ids <- getInputIDs(input, keyboards)
        overlayBw <- makeImageOverlay(ids, keyboards, color = F)

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
