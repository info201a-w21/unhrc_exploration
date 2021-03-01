#  Server

# Load the shapefile
shapefile <- map_data("world")

all_data <- read.csv("data/population.csv", skip = 14) %>% 
  filter(Year == max(Year, na.rm = T)) %>% 
  select(contains("Country"), Asylum.seekers)

# This defines a server
server <- function(input, output) {
  # Will be next!
  output$map <- renderPlot({
    iso3 <- input$iso3
    country_name <- countrycode(iso3, origin = 'iso3c', destination = 'country.name')
    
    country_data <- all_data %>% 
      filter(Country.of.asylum..ISO. == iso3) %>% 
      select(Country.of.origin..ISO., Asylum.seekers)
    
    country_shapefile <- shapefile %>% 
      mutate(Country.of.origin..ISO. = countrycode(region, origin = 'country.name', destination = 'iso3c')) %>% 
      left_join(country_data, by = "Country.of.origin..ISO.")
    
    asylum_map <- ggplot(data = country_shapefile) +
      geom_polygon(
        mapping = aes(x = long, y = lat, group = group, fill = Asylum.seekers)
      ) +
      labs(title = paste("Number of People Seeking Asylum in", country_name), 
           x = "", y = "", fill = "Num. People") +
      theme_void() +
      coord_quickmap()
    
    return(asylum_map)
  })
  
  output$top_country <- renderText({
    # Do any calculations with input$SOMETHING
    
    # Return the text of interest
    return("test")
  })
  
  output$bar_chart <- renderPlot({
    iso3 <- "ESP"
    
    # Filter down the data to top 10 into spain
    chart_data <- all_data %>% 
      filter(Country.of.asylum..ISO. == iso3) %>% 
      top_n(10, Asylum.seekers)
    
    top_country <- chart_data %>% 
      filter(Asylum.seekers == max(Asylum.seekers)) %>% 
      pull(Country.of.origin)
    
    ggplot(chart_data) +
      geom_col(
        mapping = aes(x = Asylum.seekers,
                      y = reorder(Country.of.origin, Asylum.seekers))
      ) +
      labs(y = "Country", title = "Asylum Seekers", x = "Number of People")
    
  })
}