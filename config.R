library(tidyverse)
library(shiny)
library(shinyWidgets)
library(magick)
library(RColorBrewer)

# Define keyboards
keyboards <- tribble(
    ~id,         ~name,
    'ergodox',   'Ergodox', 
    'ergodash2', 'Ergodash 2',
    'ergodash1', 'Ergodash 1',
    'lily58',    'Lily58',
    'iris',      'Iris',
    'kyria',     'Kyria',
    'corne',     'Corne',
    'minidox',   'Minidox'
)

# Add color palette
colors <- data.frame(
    color = brewer.pal(nrow(keyboards), 'Set3'))
colors$label <- paste0("color: ", colors$color)
keyboards <- bind_cols(keyboards, colors)
