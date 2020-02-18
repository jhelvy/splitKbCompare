library(shiny)
library(shinyWidgets)
library(magick)
library(RColorBrewer)

# Define keyboards

keyboards <- c(
    'ergodox', 'redox', 'ergodash2', 'ergodash1', 'lily58', 'iris',
    'kyria', 'corne', 'minidox')
keyboardNames <- c(
    'Ergodox', 'Redox', 'Ergodash 2', 'Ergodash 1', 'Lily58', 'Iris',
    'Kyria', 'Corne', 'Minidox')

# Define color palette & store images
colors <- brewer.pal(length(keyboards), 'Set3')
colorLabels <- paste0("color: ", colors)
names(colors) <- keyboards

# Load all the keyboard images
images <- c()
for (kb in keyboards) { images <- c(images, getImage(kb)) }
names(images) <- keyboards