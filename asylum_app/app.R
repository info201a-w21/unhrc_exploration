# Application file

# Load data and shapefile
library(tidyverse)
library(maps)
library(plotly)
library(countrycode)


# Source the app_server and app_ui
source("app_server.R")
source("app_ui.R")

# Create a new `shinyApp()` using the above ui and server
shinyApp(ui = ui, server = server)