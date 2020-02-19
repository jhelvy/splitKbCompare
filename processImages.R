# Create colorized versions of the black and white keyboard layouts

source('config.R')
source('functions.R')

for (id in keyboards$id) {
    color <- as.character(keyboards[which(keyboards$id == id),]$color)
    colorizedImage <- makeColorizedImage(id, color)
    savePath <- here::here('images', 'color', paste0(id, ".png"))
    image_write(colorizedImage, savePath, format = 'png')
}
