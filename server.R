function(input, output, session) {

  output$image <- renderImage({
    if (input$ergodox) {
      return(list(
        src = "images/ergodox.png",
        contentType = "image/png",
        alt = "ErgoDox",
        width = "600"
      ))
    } else if (input$iris) {
      return(list(
        src = "images/iris.png",
        filetype = "image/png",
        alt = "Iris",
        width = "600"
      ))
    }
  }, deleteFile = FALSE)
}