library(DT)
library(dplyr)
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(magick)

# Define keyboards
keyboards <- read.csv('keyboards.csv', header = T, stringsAsFactors = F) %>%
    mutate(nameKeys = ifelse(nKeysMin == nKeysMax, 
        paste0(name, ' (', nKeysMin, ')'), 
        paste0(name, ' (', nKeysMin, ' - ', nKeysMax, ')'))) %>% 
    arrange(desc(nKeysMax), desc(nKeysMin), id)

# Define list of keyboards to show
keyboardNamesByKeys <- keyboards$nameKeys
keyboardNamesByName <- keyboards %>% 
    arrange(id, desc(nKeysMax), desc(nKeysMin)) %>% 
    select(nameKeys)
keyboardNamesByName <- keyboardNamesByName$nameKeys

# Create DT of keyboard table for "Keyboards" page
check <- '✓'
keyboardTable <- keyboards %>%
    rename("Name" = name) %>%
    mutate(`# of keys` = ifelse(
        nKeysMin == nKeysMax, nKeysMin,
        paste(nKeysMin, nKeysMax, sep = ' - ')),
        `Column stagger` = colStagger,
        `Number row?` = ifelse(hasNumRow == 1, check, ''),
        `Available DIY?` = ifelse(diy == 1, check, ''),
        `Available pre-built?` = ifelse(prebuilt == 1, check, ''),
        `Rotary encoder?` = ifelse(rotaryEncoder == 1, check, ''),
        `Wireless?` = ifelse(wireless == 1, check, ''),
        `One-piece board?` = ifelse(onePiece == 1, check, ''),
        url_source = ifelse(
            is.na(url_source), '',
            paste0('<a href="', url_source,
                   '" target="_blank"><i class="fa fa-github"></i></a> ')),
        url_store = ifelse(
            is.na(url_store), '',
            paste0('<a href="', url_store,
                   '" target="_blank"><i class="fa fa-shopping-cart"></i></a> ')),
        Links = paste0(url_source, url_store)) %>%
    select(Name, `# of keys`, `Column stagger`, `Number row?`, `Available DIY?`,
           `Available pre-built?`, `Rotary encoder?`, `Wireless?`,
           `One-piece board?`, Links)

# Define the color palette

# OPTION 1
palette1 <- c('white', RColorBrewer::brewer.pal(n = 8, name = "Dark2"))

# OPTION 2
# Colors from here: https://sashat.me/2017/01/11/list-of-20-simple-distinct-colors/
palette2 <- c(
    "#FFFFFF", "#E6194B", "#FFE119", "#3CB44B", "#4363D8", "#F58231",
    "#911EB4", "#46F0F0", "#BCF60C", "#FABEBE", "#008080", "#E6BEFF",
    "#9A6324", "#FFFAC8", "#AAFFC3", "#808000", "#FFD8B1", "#F032E6",
    "#800000", "#000075")

# OPTION 3
# palette <- pals::polychrome()
# badColors <- c('#5A5156', '#325A9B', '#B00068', '#85660D', '#1C8356', '#B10DA1')
# palette <- palette[-which(palette %in% badColors)]
palette3 <- c(
    "#E4E1E3", "#F6222E", "#16FF32", "#3283FE", "#FEAF16", "#FE00FA",
    "#1CFFCE", "#90AD1C", "#2ED9FF", "#DEA0FD", "#AA0DFE", "#F8A19F",
    "#C4451C", "#FBE426", "#1CBE4F", "#FA0087", "#FC1CBF", "#F7E1A0",
    "#C075A6", "#782AB6", "#AAF400", "#BDCDFF", "#822E1C", "#B5EFB5",
    "#7ED7D1", "#1C7F93", "#D85FF7", "#683B79", "#66B0FF", "#3B00FB")

palette <- palette2
