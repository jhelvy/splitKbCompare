source('config.R')
source('functions.R')

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
                value     = TRUE,
                shape     = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId   = keyboards$id[3],
                label     = tags$span(style = keyboards$label[3],
                                      keyboards$name[3]),
                value     = TRUE,
                shape     = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId   = keyboards$id[4],
                label     = tags$span(style = keyboards$label[4],
                                      keyboards$name[4]),
                value     = TRUE,
                shape     = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId   = keyboards$id[5],
                label     = tags$span(style = keyboards$label[5],
                                      keyboards$name[5]),
                value     = TRUE,
                shape     = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId   = keyboards$id[6],
                label     = tags$span(style = keyboards$label[6],
                                      keyboards$name[6]),
                value     = TRUE,
                shape     = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId   = keyboards$id[7],
                label     = tags$span(style = keyboards$label[7],
                                      keyboards$name[7]),
                value     = TRUE,
                shape     = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId   = keyboards$id[8],
                label     = tags$span(style = keyboards$label[8],
                                      keyboards$name[8]),
                value     = TRUE,
                shape     = "curve",
                animation = "pulse"),
            prettyCheckbox(
                inputId   = keyboards$id[9],
                label     = tags$span(style = keyboards$label[9],
                                      keyboards$name[9]),
                value     = TRUE,
                shape     = "curve",
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
        
        # Get the image name for the selected inputs
        imageName <- getImageName(input, keyboards)
        
        # Define the paths to the image
        tmpfile <- image_read(makeSavePath(imageName, color = T)) %>% 
            image_write(tempfile(fileext = 'png'), format = 'png')
        
        # Render the file
        return(list(src = tmpfile,
                    width = 600,
                    alt = "Keyboard layout",
                    contentType = "image/png"))
        
    }, deleteFile = TRUE)
}

shinyApp(ui = ui, server = server)
