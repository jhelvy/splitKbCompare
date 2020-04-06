source('config.R')
source('functions.R')

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
