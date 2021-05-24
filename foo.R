source(file.path('code', 'config.R'))
source(file.path('code', 'functions.R'))


board_svg <- rsvg::rsvg_raw(here::here('images', 'svg', 'squiggle.svg'), width = 2000)
board_png <- magick::image_read(board_svg)

