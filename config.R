library(tidyverse)
library(shiny)
library(shinyWidgets)
library(magick)
# library(ggthemes)

# Define keyboards
keyboards <- tribble(
    ~id,         ~name,
    'ergodox',   'Ergodox', 
    'ergodash2', 'Ergodash 2',
    'ergodash1', 'Ergodash 1',
    'redox',     'Redox',
    'lily58',    'Lily58',
    'iris',      'Iris',
    'kyria',     'Kyria',
    'corne',     'Corne',
    'minidox',   'Minidox'
)

# Add color palette
# color <- gdocs_pal()(nrow(keyboards))
# color <- hue_pal()(nrow(keyboards))
# Dark2 from RColorBrewer: 
color <- c("#1B9E77", "#D95F02", "#D95F02", "#7570B3", "#E7298A", 
           "#66A61E", "#E6AB02", "#A6761D", "#FFFFFF")
label <- paste0("color: ", color)
keyboards$color <- color
keyboards$label <- label
