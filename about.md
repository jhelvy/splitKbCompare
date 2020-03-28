[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/) <a href="https://github.com/jhelvy/splitKbCompare" target="_blank">
<i class="fa fa-github fa-lg"></i></a>

This app is an interactive tool for comparing layouts of different split mechanical keyboards, built for the DIY [ergonomic keyboard community](https://www.reddit.com/r/ErgoMechKeyboards/).

Typing at your computer for multiple hours every day can lead to multiple health issues, such as [Repetitive Strain Injury (RSI)](https://en.wikipedia.org/wiki/Repetitive_strain_injury). Using a split keyboard design offers an ergonomic solution, but finding which keyboard is right for you can be costly and difficult. Most split keyboards come as DIY kits, making it difficult (if not impossible) to compare different keyboard layouts prior to building them. This app offers a solution to this problem.

Using the [magick library](https://cran.r-project.org/web/packages/magick/vignettes/intro.html), this app overlays images of different keyboard layouts of the user's choosing. The app dynamically changes the colors of each keyboard image in real time to help identify the contours of each different keyboard.

Supported features include:

- A filter for whether or not the keyboard has a number row at the top.
- A filter for the degree of stagger across the key columns.
- A filter for the maximum number of keys.
- A "print" button that downloads a PDF of the keyboard layout image that is accurate to true scale when printed on 8.5 x 11 inch paper.

This app was built using the [R shiny package](https://shiny.rstudio.com/). Shiny apps are typically used to display data and create interactive dashboards. In contrast, while there are no analyses or plots in this app, the images shown are extremely useful for the community of ergonomic keyboard users and hobbyists. The app highlights the power of libraries like [magick](https://cran.r-project.org/web/packages/magick/vignettes/intro.html) for image manipulation in R and the flexibility of the R ecosystem by enabling the manipulated image to be inserted into a RMarkdown document and converted into a true-to-scale PDF.
