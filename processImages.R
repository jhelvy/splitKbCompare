source('config.R')
source('functions.R')

# First, create colorized versions of the black and white keyboards
for (id in keyboards$id) {
    color <- as.character(keyboards[which(keyboards$id == id),]$color)
    colorizedImage <- makeColorizedImage(id, color)
    savePath <- here::here('images', 'color', paste0(id, ".png"))
    image_write(colorizedImage, savePathColor, format = 'png')
}

# Get the full set of unique combinations of keyboards
combinations <- c()
for (i in 1:nrow(keyboards)) {
    temp <- as.data.frame(t(combn(keyboards$id, i))) %>% 
        unite('name')
    combinations <- c(combinations, temp$name)
}

# For each combination of keyboard, create and store an overlaid image
combinations <- combinations[1:50]
for (i in 1:length(combinations)) {
    print(i)
    combination <- combinations[i]
    ids <- str_split(combination, '_')[[1]]
    overlayColor <- makeImageOverlay(ids, keyboards, color = T)
    overlayBw <- makeImageOverlay(ids, keyboards, color = F)
    savePathColor <- makeOverlaySavePath(combination, color = T)
    savePathBw <- makeOverlaySavePath(combination, color = F)
    image_write(overlayColor, savePathColor, format = 'png')
    image_write(overlayBw, savePathBw, format = 'png')
}