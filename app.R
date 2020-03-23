source('config.R')
source('functions.R')

header <- dashboardHeader(
    title      = "Split keyboard comparison",
    titleWidth = 400,
    tags$li(class = "dropdown",
    # Add font awesome icons in top-right
    tags$div(HTML('
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
      <a href="https://github.com/jhelvy/splitKbCompare">
      <i class="fa fa-github fa-2x"></i></a>
      <a href="https://creativecommons.org/licenses/by/4.0/">
      <i class="fa fa-creative-commons fa-2x"></i></a>'))
  )
)

sidebar <- dashboardSidebar(
  # Filter options
  sidebarMenu(
    menuItem("Filters", icon = icon("filter"),
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
      sliderInput(
        inputId = "maxNumKeys",
        label = "Max number of keys:",
        min   = min(keyboards$nKeysMin),
        max   = max(keyboards$nKeysMax),
        value = max(keyboards$nKeysMax),
        step  = 1)
    ),
    hr(),
    # Main keyboard selection options
    prettyCheckboxGroup(
      inputId   = "keyboards",
      label     = "Select keyboards:",
      choices   = keyboards$name,
      shape     = "curve",
      outline   = TRUE,
      animation = "pulse"),
    actionButton(
      inputId = "reset",
      label   = "Reset"),
    downloadButton(
      outputId = "print",
      label    = "Print to scale"),
    br(),
    br(),
    # Sidebar footer
    tags$div(HTML('
      <a href="https://shiny.rstudio.com/">&nbsp;&nbsp;&nbsp;&nbsp;Built with
      <img alt="Shiny" src="https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png" height="20">
      </a>'))
  )
)

body <- dashboardBody(
  # Add custom styling
  tags$head(tags$style(HTML(paste(readLines("style.css"), collapse=" ")))),
  imageOutput("layout")
)

server <- function(input, output, session) {
  
  # Control reset button
  observeEvent(input$reset, {
    updatePrettyCheckboxGroup(
      session = session,
      inputId = "keyboards",
      choices = keyboards$name
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

shinyApp(ui = dashboardPage(header, sidebar, body),
         server = server)
