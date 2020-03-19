source('config.R')
source('functions.R')

ui <- dashboardPage(
  dashboardHeader(
    title      = "Split keyboard comparison", 
    titleWidth = 400,
    tags$li(class = "dropdown",
    tags$div(HTML('
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
      <a href="https://github.com/jhelvy/splitKbCompare">
      <i class="fa fa-github" style="color:white;"></i></a>
      <a href="https://creativecommons.org/licenses/by/4.0/">
      <i class="fa fa-creative-commons" style="color:white;"></i></a>'))
    )
  ),
  dashboardSidebar(
    prettyCheckboxGroup(
      inputId   = "features",
      label     = "Features:",
      choices   = c("Has number row"),
      shape     = "curve",
      animation = "pulse"),
    sliderInput(
      inputId = "maxNumKeys", 
      label = "Max number of keys:", 
      min   = min(keyboards$nKeysMin), 
      max   = max(keyboards$nKeysMax), 
      value = max(keyboards$nKeysMax),
      step  = 1),
    prettyCheckboxGroup(
      inputId   = "keyboards",
      label     = "Select keyboards:",
      choices   = keyboards$name,
      shape     = "curve",
      animation = "pulse"),
    actionButton(
      inputId = "reset", 
      label   = "Reset"),
    downloadButton(
      outputId = "print",
      label    = "Print"),
    br(),
    br(),
    # Sidebar footer
    tags$div(HTML('
      <p class = "control-label">&nbsp;&nbsp; Built with
      <a href="https://shiny.rstudio.com/">
      <img alt="Shiny" src="https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png" height="20">
      </a></p>'))
  ),
  dashboardBody(
    imageOutput("layout"),
    # Modify styling
    tags$head(tags$style(HTML('
    @import url(https://fonts.googleapis.com/css?family=Exo);
    /* fontawesome icons in header */
    .fa.fa-github {
      margin: 18px 7px 0px 0px;
    }
    .fa.fa-creative-commons {
      margin: 18px 7px 0px 0px;
    }
    /* title */
    .main-header .logo {
      font-family: Exo, sans-serif;
      font-size: 30px;
    }
    /* main sidebar */
    .skin-blue .main-sidebar {
      background-color: #1A1917;
    }
    /* shiny image */
    img {
      vertical-align: middle;
      margin: 6px 5px 6px -10px;
    }
    /* print button */
    .skin-blue .sidebar a {
      color: #444;
      margin: 6px 5px 6px 15px;
    }
    /* toggle button when hovered  */
    .skin-blue .main-header .navbar .sidebar-toggle:hover{
      background-color: #1A1917;
    }
    /* body */
    .content-wrapper, .right-side {
      background-color: #000;
    }
    /* footer */    
    .skin-blue .wrapper{
      background-color: #000;
    }')))
  )
)

server <- function(input, output, session) {
  
  # Control reset button
  observeEvent(input$reset, {
    updatePrettyCheckboxGroup(
      session = session, 
      inputId = "keyboards",
      choices = keyboards$name, 
      prettyOptions = list(animation = "pulse", shape = "curve")
    )
    updatePrettyCheckboxGroup(
      session = session, 
      inputId = "features",
      choices   = c("Has number row"),
      prettyOptions = list(animation = "pulse", shape = "curve")
    )
    updateSliderInput(
      session = session, 
      inputId = "maxNumKeys",
      min     = min(keyboards$nKeysMin), 
      max     = max(keyboards$nKeysMax), 
      value   = max(keyboards$nKeysMax),
      step    = 1
    )
  }, ignoreInit = TRUE)

  # Filter keyboard options based on feature options and slider value
  observe({
    ids <- which(keyboards$nKeysMax <= input$maxNumKeys)
    if ('Has number row' %in% input$features) { 
      featureIds <- which(keyboards$hasNumRow == 1)
      ids <- intersect(ids, featureIds)
    }
    updatePrettyCheckboxGroup(
      session = session, 
      inputId = "keyboards",
      choices = keyboards$name[ids],
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
