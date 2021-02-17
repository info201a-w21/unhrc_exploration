# Analysis of UNHCR data


# Set up ------------------------------------------------------------------

library(tidyverse)
all_data <- read.csv("data/population.csv", skip = 14)

# Simple exploration
dim(all_data)
unique(all_data$Year)
length(unique(all_data$Country.of.origin))
length(unique(all_data$Country.of.asylum))

data <- all_data %>% 
  filter(Year == 2020) %>% 
  select(contains("Country"), Asylum.seekers)
dim(data)

country_of_interest <- "ESP"

country_data <- data %>% 
  filter(Country.of.asylum..ISO. == country_of_interest)


# High level questions ----------------------------------------------------

# From how many countries do asylum seekers come from (into county of interest)?
num_countries <- nrow(country_data)

# How many people sought asylum in the country in 2020?
num_people <- country_data %>% 
  summarize(total_people = sum(Asylum.seekers)) %>% 
  pull()

top_10_countries <- country_data %>% 
  top_n(10, wt = Asylum.seekers) %>% 
  arrange(-Asylum.seekers) %>% 
  select(Country.of.origin, Asylum.seekers)


# Make a map --------------------------------------------------------------

shapefile <- map_data("world")
