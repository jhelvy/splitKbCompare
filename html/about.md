[![License: MIT](https://img.shields.io/github/license/jhelvy/splitKbCompare)](https://github.com/jhelvy/splitKbCompare/blob/master/LICENSE.txt)

<a href="https://github.com/jhelvy/splitKbCompare" target="_blank">
<i class="fa fa-github fa-lg"></i></a> Copyright (c) 2020 John Helveston

### Overview

This app is an interactive [tool](https://jhelvy.shinyapps.io/splitkbcompare/) for comparing layouts of different split mechanical keyboards built for the community of [ergonomic keyboard](https://www.reddit.com/r/ErgoMechKeyboards/) users. Split keyboards offer an ergonomic solution to many issues that make regular keyboards painful or uncomfortable to use, but finding which keyboard is right for you can be costly and difficult. Most split keyboards come as DIY kits, making it difficult (if not impossible) to compare different keyboard layouts prior to building them. This app offers one solution to this problem.

### Features

- A filter for whether or not the keyboard has a number row at the top.
- A filter for the degree of stagger across the key columns.
- A filter for whether or not the keyboard supports rotary encoders.
- A filter for whether or not the keyboard is wireless.
- A filter for the keyboard availability (DIY or pre-built).
- A filter for the maximum number of keys.
- A "print" button that downloads a PDF of the true-to-scale keyboard layout when printed on 8.5 x 11 inch paper.

### Run locally

The app is hosted for [free online](https://jhelvy.shinyapps.io/splitkbcompare/), but you can also run the app locally on your computer by following these steps:

1. Install [R](https://cloud.r-project.org/)
2. Run this code in R to install the [shiny library](https://shiny.rstudio.com/):

```
install.packages("shiny")
```

3. Run this code in R to launch the app:

```
library(shiny)
runGitHub('jhelvy/splitKbCompare')
```

### Under the hood

This app was built using the [R shiny package](https://shiny.rstudio.com/). Shiny apps are typically used to display data and create interactive dashboards. This app has a different purpose: to help the community of ergonomic keyboard users and hobbyists compare different keyboards.

The app uses the [magick library](https://cran.r-project.org/web/packages/magick/vignettes/intro.html) to overlay images of different keyboard layouts of the user's choosing. The app dynamically changes the colors of each keyboard image in real time to help identify the contours of each different keyboard. To print the image to scale, the overlay image is inserted into a RMarkdown document and converted into a true-to-scale PDF. The app is hosted for free on [shinyapps.io](https://www.shinyapps.io/), and the [open source code is hosted on Github](https://github.com/jhelvy/splitKbCompare).
