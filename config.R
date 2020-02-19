library(tibble)
library(shiny)
library(shinyWidgets)
library(shinyjs)
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
colors <- c("#1B9E77", "#D95F02", "#D95F02", "#7570B3", "#E7298A", 
            "#66A61E", "#E6AB02", "#A6761D", "#FFFFFF")
labels <- paste0("color: ", colors)
keyboards$color <- colors
keyboards$label <- labels
