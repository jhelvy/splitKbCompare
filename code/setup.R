# install.packages(c(
#     "shiny", "DT", "dplyr", "shinythemes", "shinyWidgets", "magick", "readr",
#     "RColorBrewer", "markdown"
# ))

# Load libraries
library(DT)
library(dplyr)
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(magick)
library(markdown)

# Load custom functions
source(file.path('code', 'functions.R'))

# Load data
keyboards <- loadKeyboards()
keyboardsDT <- loadKeyboardsDT(keyboards)
images <- loadImages()
palette <- loadColorPalette()
