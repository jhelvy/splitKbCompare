source('appFunctions.R')
source('appConfig.R')

# Create the UI
ui <- fluidPage(

    # Edit CSS styling
    tags$style("
        @import url(https://fonts.googleapis.com/css?family=Exo);
        .well {
            background-color: #1A1917;
            width: 140px;
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

            width = 2,

            prettyCheckbox(
                inputId = keyboards[1],
                label = tags$span(style = colorLabels[1], keyboardNames[1]),
                value = TRUE,
                shape = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId = keyboards[2],
                label = tags$span(style = colorLabels[2], keyboardNames[2]),
                value = FALSE,
                shape = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId = keyboards[3],
                label = tags$span(style = colorLabels[3], keyboardNames[3]),
                value = FALSE,
                shape = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId = keyboards[4],
                label = tags$span(style = colorLabels[4], keyboardNames[4]),
                value = FALSE,
                shape = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId = keyboards[5],
                label = tags$span(style = colorLabels[5], keyboardNames[5]),
                value = FALSE,
                shape = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId = keyboards[6],
                label = tags$span(style = colorLabels[6], keyboardNames[6]),
                value = FALSE,
                shape = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId = keyboards[7],
                label = tags$span(style = colorLabels[7], keyboardNames[7]),
                value = FALSE,
                shape = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId = keyboards[8],
                label = tags$span(style = colorLabels[8], keyboardNames[8]),
                value = FALSE,
                shape = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId = keyboards[9],
                label = tags$span(style = colorLabels[9], keyboardNames[9]),
                value = FALSE,
                shape = "curve",
                animation = "pulse"),

            tags$div(HTML('<br>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                <a href="https://github.com/jhelvy/splitKbCompare">
                <i class="fa fa-github" style="color:white;"></i></a>'))
            ),

        mainPanel(
            imageOutput("layout")
        )

    )
)

server <- function(input, output) {

    output$layout <- renderImage({

        # Create the image overlay from only the selected images
        tmpfile <- getOverlay(input, keyboards) %>%
            image_join() %>%
            image_mosaic() %>%
            image_write(tempfile(fileext = 'png'), format = 'png')

        # Render the file
        return(list(src = tmpfile,
                    width = 600,
                    alt = "Keyboard layout",
                    contentType = "image/png"))

    }, deleteFile = TRUE)
}

shinyApp(ui = ui, server = server)
