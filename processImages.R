source('config.R')
source('functions.R')

# Get the full set of unique combinations of keyboards
combinations <- c()
for (i in 1:nrow(keyboards)) {
    temp <- as.data.frame(t(combn(keyboards$id, i))) %>% 
        unite('name')
    combinations <- c(combinations, temp$name)
}

# For each combination of keyboard, create and store an overlaid image
combinations <- combinations[1:92]
combinations <- combinations[1:20]
for (i in 1:length(combinations)) {
    print(i)
    combination <- combinations[i]
    ids <- str_split(combination, '_')[[1]]
    overlayColor <- getOverlayColor(ids, keyboards) %>%
        image_join() %>%
        image_mosaic()
    overlayBw <- getOverlayBw(ids, keyboards) %>%
        image_join() %>%
        image_mosaic()
    savePathColor <- makeSavePath(combination, color = T)
    savePathBw <- makeSavePath(combination, color = F)
    image_write(overlayColor, savePathColor, format = 'png')
    image_write(overlayBw, savePathBw, format = 'png')
}