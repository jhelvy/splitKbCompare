library(shiny)
library(shinyWidgets)
library(magick)

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
                inputId = "ErgoDox",
                label = tags$span(style = "color: #1b9e77", "ErgoDox"),
                value = TRUE,
                shape = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId = "ErgoDash1",
                label = tags$span(style = "color: #7570b3", "ErgoDash 1"),
                value = FALSE,
                shape = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId = "ErgoDash2",
                label = tags$span(style = "color: #7570b3", "ErgoDash 2"),
                value = FALSE,
                shape = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId = "Redox",
                label = tags$span(style = "color: #e6ab02", "Redox"),
                value = FALSE,
                shape = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId = "Iris",
                label = tags$span(style = "color: #e7298a", "Iris"),
                value = FALSE,
                shape = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId = "Kyria",
                label = tags$span(style = "color: #66a61e", "Kyria"),
                value = FALSE,
                shape = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId = "Corne",
                label = tags$span(style = "color: #d95f02", "Corne"),
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

    getImage <- function(keyboard) {
        image_read(file.path("images", paste0(keyboard, ".png")))
    }

    output$layout <- renderImage({

        # Load the images
        images <- getImage("background")
        if (input$ErgoDox) {
            images <- c(images, getImage("ErgoDox"))
        }
        if (input$ErgoDash1) {
            images <- c(images, getImage("ErgoDash1"))
        }
        if (input$ErgoDash2) {
            images <- c(images, getImage("ErgoDash2"))
        }
        if (input$Redox) {
            images <- c(images, getImage("Redox"))
        }
        if (input$Iris) {
            images <- c(images, getImage("Iris"))
        }
        if (input$Kyria) {
            images <- c(images, getImage("Kyria"))
        }
        if (input$Corne) {
            images <- c(images, getImage("Corne"))
        }

        # Create a temp file of the overlay
        if (! is.null(images)) {
            tmpfile <- images %>%
                image_join() %>%
                image_mosaic() %>%
                image_write(tempfile(fileext = 'png'), format = 'png')
        } else {
            tmpfile <- NULL
        }

        # Render the file
        return(list(src = tmpfile,
                    width = 600,
                    alt = "Keyboard layout",
                    contentType = "image/png"))

    }, deleteFile = TRUE)
}

shinyApp(ui = ui, server = server)
