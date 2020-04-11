library(tidyverse)
library(here)

rmarkdown::render(
    input = here::here('pages', 'keyboards.Rmd'),
    output_format = 'github_document')
unlink(here::here('pages', 'keyboards.html'))
