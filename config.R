library(tibble)
library(shiny)
library(shinyWidgets)
library(magick)

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
# library(ggthemes)
# palette <- gdocs_pal()(nrow(keyboards))
# Dark2 from RColorBrewer:
# palette <- c("#1B9E77", "#D95F02", "#7570B3", "#E7298A",
#             "#66A61E", "#E6AB02", "#A6761D", "#FFFFFF")
# Colors from here: https://sashat.me/2017/01/11/list-of-20-simple-distinct-colors/
palette <- c('#4363d8', '#3cb44b', '#ffe119', '#e6194b', '#f58231',
             '#911eb4', '#46f0f0', '#f032e6', '#bcf60c', '#fabebe',
             '#008080', '#e6beff', '#9a6324', '#fffac8', '#800000',
             '#aaffc3', '#808000', '#ffd8b1', '#000075', '#808080',
             '#ffffff', '#000000')
colors <- palette
colors <- c(colors[1], rep(colors[2], 2), colors[3:length(colors)])
colors <- colors[1:nrow(keyboards)]
labels <- paste0("color: ", colors)
keyboards$color <- colors
keyboards$label <- labels
