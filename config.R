library(tibble)
library(shiny)
library(shinyWidgets)
library(magick)
# library(ggthemes)

# Define keyboards
keyboards <- tribble(
    ~id,         ~name,
    'ergodox',   'Ergodox (76 - 80)',
    'ergodash2', 'Ergodash 2 (68 - 72)',
    'ergodash1', 'Ergodash 1 (66 - 68)',
    'redox',     'Redox (70)',
    'lily58',    'Lily58 (58)',
    'iris',      'Iris (54 - 56)',
    'kyria',     'Kyria (46 - 50)',
    'corne',     'Corne (42)',
    'minidox',   'Minidox (36)'
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
