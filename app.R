source('config.R')
source('functions.R')
source('ui.R')
source('server.R')

shinyApp(ui = ui, server = server)
