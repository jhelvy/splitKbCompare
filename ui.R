ui <- navbarPage(title = "",
  theme = shinytheme("cyborg"),
  tabPanel("Compare keyboards", icon = icon(name = "keyboard", lib = "font-awesome"),
    sidebarLayout(
      sidebarPanel(
        width = 3,
        # Filter drop down menu
        div(style="display: inline-block;vertical-align:top;",
        dropdown(
          label = "Filters",
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
        )),
        div(style="display: inline-block;vertical-align:top; width: 7px;",HTML("<br>")),
        # Print button
        div(style="display: inline-block;vertical-align:top;",
        downloadButton(
          outputId = "print",
          label    = "Print to scale")),
        # Main keyboard selection options
        prettyCheckboxGroup(
          inputId   = "keyboards",
          label     = HTML('<h4>Select keyboards:</h4>'),
          choices   = keyboards$name,
          shape     = "curve",
          outline   = TRUE,
          animation = "pulse"),
        actionButton(
          inputId = "reset",
          label   = "Reset"),
        br(),br(),
        # Insert footer
        tags$div(HTML(paste(readLines("footer.html"), collapse=" ")))
      ),
      mainPanel(
        # Add custom styling
        tags$head(tags$style(HTML(paste(readLines("style.css"), collapse=" ")))),
        imageOutput("layout")
      )
    )
  ),
  tabPanel("About", icon = icon(name = "question-circle", lib = "font-awesome"),
    mainPanel(width = 6,
      includeMarkdown("README.md"),br(),
      # Insert footer
      tags$div(HTML(paste(readLines("footer.html"), collapse=" "))),br()
    )
  )
)
