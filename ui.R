
ui <- navbarPage(
    title = "",
    theme = shinytheme("cyborg"),
    tabPanel(
        title = "Compare",
        icon = icon(name = "balance-scale", lib = "font-awesome"),
        includeCSS(file.path("includes", "style.css")),
        sidebarLayout(
            sidebarPanel(
                width = 3,
                # Sort list
                # Filter drop down menu
                h4("Filters"),
                filterButtons(),
                # Main keyboard selection options
                h4("Keyboards"),
                div(
                    style = "display: inline-block;",
                    pickerInput(
                        inputId = "sortKeyboards",
                        choices = c("Name", "# Keys"),
                        selected = "Name",
                        options = list(
                            `selected-text-format` = "static",
                            title = "Sort"
                        )
                    )
                ),
                actionButton(
                    inputId = "selectAll",
                    label = NULL,
                    icon = icon("check-square"),
                    inline = TRUE
                ),
                actionButton(
                    inputId = "reset",
                    label = NULL,
                    icon = icon("undo"),
                    inline = TRUE
                ),
                prettyCheckboxGroup(
                    inputId = "keyboard",
                    label = "",
                    choices = keyboards$nameKeys,
                    shape = "curve",
                    outline = TRUE,
                    animation = "pulse"
                ),
                # Insert footer
                includeHTML(file.path("includes", "footer.html"))
            ),
            mainPanel(
                # Print button
                downloadButton(
                    outputId = "printFile",
                    label = "Print to scale (PDF)"
                ),
                # Print/display option
                div(
                    style = "display: inline-block",
                    dropdown(
                        icon = icon("cog"),
                        prettyRadioButtons(
                            inputId   = "printSize",
                            label     = "Print size:",
                            choices   = list("A4" = "A4", "Letter (8.5x11)" = "Letter"),
                            selected  = "A4",
                            animation = "pulse"
                        ),
                        prettyRadioButtons(
                            inputId   = "printSepPages",
                            label     = "Print on seperate pages?",
                            choices   = list("Yes" = TRUE, "No" = FALSE),
                            selected  = FALSE,
                            animation = "pulse"
                        ),
                        prettyRadioButtons(
                            inputId = "keyboardHalf",
                            label = "Keyboard half:",
                            choices = c("Left (mirrored)", "Right"),
                            selected = "Right",
                            animation = "pulse"
                        )
                    )
                ),
                # Image
                imageOutput("layout")
            )
        )
    ),
    tabPanel(
        title = "Keyboards",
        icon = icon(name = "keyboard", lib = "font-awesome"),
        mainPanel(
            width = 7,
            switchInput(
                inputId = "filterDT",
                onLabel = "Apply filters",
                offLabel = "Show all",
                size = "mini"
            ),
            DT::dataTableOutput("keyboardsDT"),
            br(),
            # Insert footer
            includeHTML(file.path("includes", "footer.html")),
            br()
        )
    ),
    tabPanel(
        HTML('About</a></li><li><a href="https://github.com/jhelvy/splitKbCompare" target="_blank"><i class="fa fa-github fa-fw"></i>'),
        icon = icon(name = "question-circle", lib = "font-awesome"),
        mainPanel(
            width = 6,
            includeMarkdown("README.md"),
            br(),
            # Insert footer
            includeHTML(file.path("includes", "footer.html")),
            br()
        )
    )
)
