source('config.R')
source('functions.R')

# First, create colorized versions of the black and white keyboards
for (id in keyboards$id) {
    color <- as.character(keyboards[which(keyboards$id == id),]$color)
    colorizedImage <- makeColorizedImage(id, color)
    savePath <- here::here('images', 'color', paste0(id, ".png"))
    image_write(colorizedImage, savePathColor, format = 'png')
}
