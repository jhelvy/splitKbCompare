library(dplyr)
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(magick)

# Define keyboards
keyboards <- read.csv('keyboards.csv', header = T, stringsAsFactors = F) %>%
    dplyr::mutate(
        name = gsub('_', ' ', id),
        name = tools::toTitleCase(name),
        name = ifelse(
        nKeysMin == nKeysMax,
        paste0(name, ' (', nKeysMin, ')'),
        paste0(name, ' (', nKeysMin, ' - ', nKeysMax, ')')))

# Define the color palette

# Colors from here: https://sashat.me/2017/01/11/list-of-20-simple-distinct-colors/
palette <- c('#ffffff', '#e6194b', '#ffe119', '#3cb44b', '#4363d8', '#f58231',
             '#911eb4', '#46f0f0', '#bcf60c', '#fabebe', '#008080', '#e6beff',
             '#9a6324', '#fffac8', '#aaffc3', '#808000', '#ffd8b1', '#f032e6',
             '#800000', '#000075')

# Another option: the pals library
# library(pals)
# palette <- polychrome()
# badColors <- c('#5A5156', '#325A9B', '#B00068', '#85660D', '#1C8356', '#B10DA1')
# palette <- palette[-which(palette %in% badColors)]
# palette <- c("#E4E1E3", "#F6222E", "#FE00FA", "#16FF32", "#3283FE", "#FEAF16",
#              "#1CFFCE", "#90AD1C", "#2ED9FF", "#DEA0FD", "#AA0DFE", "#F8A19F",
#              "#C4451C", "#FBE426", "#1CBE4F", "#FA0087", "#FC1CBF", "#F7E1A0",
#              "#C075A6", "#782AB6", "#AAF400", "#BDCDFF", "#822E1C", "#B5EFB5",
#              "#7ED7D1", "#1C7F93", "#D85FF7", "#683B79", "#66B0FF", "#3B00FB")
