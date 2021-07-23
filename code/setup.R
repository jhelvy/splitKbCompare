# Load libraries
library(DT)
library(dplyr)
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(magick)

# Load custom functions
source(file.path('code', 'functions.R'))

# Load data
keyboards <- loadKeyboards()
keyboardsDT <- loadKeyboardsDT(keyboards)
images <- loadImages()
palette <- loadColorPalette()
