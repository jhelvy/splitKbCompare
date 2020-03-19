[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

An interactive [tool](https://jhelvy.shinyapps.io/splitkbcompare/) for comparing layouts of different split mechanical keyboards.

## Supported keyboards

In order of number of keys:

- [ErgoDox (76 - 80)](https://github.com/Ergodox-io/ErgoDox)
- [ErgoDash (66 - 72)](https://github.com/omkbd/ErgoDash)
- [Redox (70)](https://github.com/mattdibi/redox-keyboard)
- [Keyboardio (64)](https://github.com/keyboardio)
- [Nyquist (60)](https://github.com/keebio/nyquist-case)
- [Lily58 (58)](https://github.com/kata0510/Lily58)
- [Iris (54 - 56)](https://github.com/keebio/iris-case)
- [Kyria (46 - 50)](https://github.com/splitkb/kyria)
- [Gergo (46 - 50)](https://www.gboards.ca/)
- [Corne (42)](https://github.com/foostan/crkbd)
- [Atreus (42)](https://github.com/technomancy/atreus)
- [Elephant42 (42)](https://github.com/illness072/elephant42)
- [Minidox (36)](https://github.com/dotdash32/Cases/tree/master/Minidox)
- [Gergoplex (36)](https://www.gboards.ca/)
- [Georgi (30)](https://www.gboards.ca/)

##Screenshot:
![](images/screenshot.png)

## Detailed description:
This app was built for the DIY [ergonomic keyboard community](https://www.reddit.com/r/ErgoMechKeyboards/).

Many of us spend hours every day typing away at our computers, which can lead to multiple health issues such as Repetitive Strain Injury (RSI). Using a "split" keyboard offers an ergonomic solution, but finding which keyboard is right for you can be costly and difficult. Most split keyboards come as DIY kits, making it difficult (if not impossible) to compare different keyboard layouts prior to building them. This app offers a solution to this problem.

Using the [magick library](https://cran.r-project.org/web/packages/magick/vignettes/intro.html), this app overlays images of different keyboard layouts of the user's choosing. The app dynamically changes the colors of each keyboard image in real time to help identify the contours of each different keyboard. The app also has a "print" button that inserts the image overlay into an RMarkdown file that is then compiled into a PDF. When printed, the image is accurate to true scale in the physical world. Finally, the app contains several filtering options for the keyboards, such as the degree of stagger across the key columns and whether or not the keyboard has a number row at the top.

Perhaps one of the most unique aspects of this app is that it is not used to display data in the traditional sense (the purpose of most [R shiny apps](https://shiny.rstudio.com/)). There are no analyses or plots, but the images shown are extremely useful for the intended audience (i.e. the community of ergonomic keyboard users and hobbyists). The app highlights the power of libraries like magick for image manipulation in R and the flexibility of the R ecosystem by enabling the manipulated image to be inserted into a RMarkdown document and converted into a true-to-scale PDF.
