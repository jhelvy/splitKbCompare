library(tibble)
library(shiny)
library(shinyWidgets)
library(magick)

# Define keyboards
keyboards <- tribble(
    ~id,          ~name,
    'ergodox',    'Ergodox (76 - 80)',
    'ergodash2',  'Ergodash 2 (68 - 72)',
    'ergodash1',  'Ergodash 1 (66 - 68)',
    'redox',      'Redox (70)',
    'keyboardio', 'Keyboardio (64)',
    'nyquist',    'Nyquist (60)',
    'lily58',     'Lily58 (58)',
    'iris',       'Iris (54 - 56)',
    'kyria',      'Kyria (46 - 50)',
    'gergo',      'Gergo (46 - 50)',
    'corne',      'Corne (42)',
    'atreus',     'Atreus (42)',
    'elephant42', 'Elephant42 (42)',
    'minidox',    'Minidox (36)',
    'gergoplex',  'Gergoplex (36)',
    'georgi',     'Georgi (30)'
)

# Define the color palette

# Colors from here: https://sashat.me/2017/01/11/list-of-20-simple-distinct-colors/
# palette <- c('#4363d8', '#3cb44b', '#ffe119', '#e6194b', '#f58231',
#              '#911eb4', '#46f0f0', '#ffffff', '#bcf60c', '#fabebe',
#              '#008080', '#e6beff', '#9a6324', '#fffac8', '#800000',
#              '#aaffc3', '#808000', '#ffd8b1', '#000075', '#f032e6')

# Colors from pals library
# library(pals)
# palette <- polychrome()
# badColors <- c('#5A5156', '#325A9B', '#B00068', '#85660D', '#1C8356', '#B10DA1')
# palette <- palette[-which(palette %in% badColors)]
palette <- c("#E4E1E3", "#F6222E", "#FE00FA", "#16FF32", "#3283FE", "#FEAF16", 
             "#1CFFCE", "#90AD1C", "#2ED9FF", "#DEA0FD", "#AA0DFE", "#F8A19F", 
             "#C4451C", "#FBE426", "#1CBE4F", "#FA0087", "#FC1CBF", "#F7E1A0", 
             "#C075A6", "#782AB6", "#AAF400", "#BDCDFF", "#822E1C", "#B5EFB5", 
             "#7ED7D1", "#1C7F93", "#D85FF7", "#683B79", "#66B0FF", "#3B00FB")

# Add colors to data frame
colors <- palette
colors <- c(colors[1], rep(colors[2], 2), colors[3:length(colors)])
colors <- colors[1:nrow(keyboards)]
labels <- paste0("color: ", colors)
keyboards$color <- colors
keyboards$label <- labels
