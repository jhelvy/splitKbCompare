# Filter buttons
filterButtons <- function() {
    list(
        div(
            style = "display: inline-block; margin-bottom: 15px;",
            dropdown(
                label = "Number of Keys",
                width = "200%",
                sliderInput(
                    inputId = "numKeys",
                    label = NULL,
                    min = min(keyboards$nKeysMin),
                    max = max(keyboards$nKeysMax),
                    value = c(min(keyboards$nKeysMin), max(keyboards$nKeysMax)),
                    step = 1
                )
            )
        ),
        div(
            style = "display: inline-block; margin-bottom: 15px;",
            dropdown(
                label = "Number of Rows",
                width = "200%",
                sliderInput(
                    inputId = "numRows",
                    label = NULL,
                    min = min(keyboards$numRows),
                    max = max(keyboards$numRows),
                    value = c(min(keyboards$numRows), max(keyboards$numRows)),
                    step = 1
                )
            )
        ),
        div(
            style = "display: inline-block",
            pickerInput(
                inputId = "hasNumRow",
                choices = list(
                    "Only with number row" = 1,
                    "Only without number row" = 0
                ),
                multiple = TRUE,
                options = list(
                    `selected-text-format` = "static",
                    title = "Number Row"
                )
            )
        ),
        div(
            style = "display: inline-block",
            pickerInput(
                inputId = "colStagger",
                choices = list("Aggressive", "Moderate", "None"),
                multiple = TRUE,
                options = list(
                    `selected-text-format` = "static",
                    title = "Column Stagger"
                )
            )
        ),
        div(
            style = "display: inline-block",
            pickerInput(
                inputId = "rowStagger",
                choices = list("Yes" = 1, "No" = 0),
                multiple = TRUE,
                options = list(
                    `selected-text-format` = "static",
                    title = "Row Stagger"
                )
            )
        ),
        div(
            style = "display: inline-block",
            pickerInput(
                inputId = "switchType",
                choices = list(
                    "Cherry MX" = "mxCompatible",
                    "Kailh Choc V1" = "chocV1",
                    "Kailh Choc V2" = "chocV2"
                ),
                multiple = TRUE,
                options = list(
                    `selected-text-format` = "static",
                    title = "Switch Type"
                )
            )
        ),
        div(
            style = "display: inline-block",
            pickerInput(
                inputId = "rotaryEncoder",
                choices = list("Yes" = 1, "No" = 0),
                multiple = TRUE,
                options = list(
                    `selected-text-format` = "static",
                    title = "Rotary Encoder"
                )
            )
        ),
        div(
            style = "display: inline-block",
            pickerInput(
                inputId = "wireless",
                choices = list("Yes" = 1, "No" = 0),
                multiple = TRUE,
                options = list(
                    `selected-text-format` = "static",
                    title = "Wireless"
                )
            )
        ),
        div(
            style = "display: inline-block",
            pickerInput(
                inputId = "onePiece",
                choices = list("One-piece" = 1, "Two halves" = 0),
                multiple = TRUE,
                options = list(
                    `selected-text-format` = "static",
                    title = "One-piece"
                )
            )
        ),
        div(
            style = "display: inline-block",
            pickerInput(
                inputId = "availability",
                choices = list("DIY" = "diy", "Pre-built" = "prebuilt"),
                multiple = TRUE,
                options = list(
                    `selected-text-format` = "static",
                    title = "Availability"
                )
            )
        ),
        div(
            style = "display: inline-block",
            pickerInput(
                inputId = "openSource",
                choices = list("Yes" = TRUE, "No" = FALSE),
                multiple = TRUE,
                options = list(
                    `selected-text-format` = "static",
                    title = "Open Source"
                )
            )
        )
    )
}