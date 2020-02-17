fluidPage(
  titlePanel("Split keyboard comparison"),

  fluidRow(
    column(4, wellPanel(
      prettyCheckbox(
        inputId = "ergodox", 
        label = "ErgoDox",
        value = TRUE,
        shape = "curve", 
        animation = "pulse"),
      prettyCheckbox(
        inputId = "iris", 
        label = "Iris",
        value = TRUE,
        shape = "curve", 
        animation = "pulse")
    )),
    column(1,
      imageOutput("image", height = "50px")
    )
  )
)