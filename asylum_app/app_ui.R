# Describe the user interface

# List of iso3 codes
country_df <- all_data %>% 
  distinct(Country.of.asylum..ISO., Country.of.asylum)

choices <- setNames(country_df$Country.of.asylum..ISO.,country_df$Country.of.asylum)

map_layout <- sidebarLayout(
  sidebarPanel(
    selectInput(
      inputId = "iso3", 
      label = "Choose a country", 
      choices = choices
    )
  ), 
  mainPanel(plotOutput(outputId = "map"))
)

map_panel <- tabPanel("Map", map_layout)

bar_panel <- tabPanel("Bar Chart", 
  p("say some words", textOutput("top_country", inline = T), "more words"),
  plotOutput("bar_chart"))

# Create the UI
ui <- navbarPage(
  "Asylum Application", 
  map_panel, 
  bar_panel
)
