library(shiny)
library(shinyWidgets)
library(magick)

ui <- fluidPage(
    
    # Edit CSS styling 
    tags$style("
        @import url(https://fonts.googleapis.com/css?family=Exo);
        .well {
            background-color: #1A1917;
        }
        h1, h2, h3 {
            color: #FFF;
            font-family: 'Exo';
            font-weight: 500;
            margin-bottom: 20px;
        }
        .col-sm-4 {
            color: #FFF;
            font-family: 'Exo';
        }"),
    
    setBackgroundColor(
        color = "black"
    ),
    
    titlePanel("Split keyboard comparison"),

    sidebarLayout(
        sidebarPanel(
            prettyCheckbox(
                inputId = "ErgoDox", 
                label = "ErgoDox",
                value = TRUE,
                shape = "curve", 
                animation = "pulse"),
            prettyCheckbox(
                inputId = "ErgoDash1", 
                label = "ErgoDash 1",
                value = FALSE,
                shape = "curve", 
                animation = "pulse"),
            prettyCheckbox(
                inputId = "ErgoDash2", 
                label = "ErgoDash 2",
                value = FALSE,
                shape = "curve", 
                animation = "pulse"),
            prettyCheckbox(
                inputId = "Redox", 
                label = "Redox",
                value = FALSE,
                shape = "curve", 
                animation = "pulse"),
            prettyCheckbox(
                inputId = "Iris", 
                label = "Iris",
                value = FALSE,
                shape = "curve", 
                animation = "pulse"),
            prettyCheckbox(
                inputId = "Kyria", 
                label = "Kyria",
                value = FALSE,
                shape = "curve", 
                animation = "pulse"),
            prettyCheckbox(
                inputId = "Corne", 
                label = "Corne",
                value = FALSE,
                shape = "curve", 
                animation = "pulse"),
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