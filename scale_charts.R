library(tidyverse)
library(hrbrthemes)
countries <- read_csv("input_data/countries.csv")

# traditional for loop

for(target_country in unique(countries$country)) {
  ggplot(countries %>% filter(country == target_country),
         aes(x = year, y = population)) +
    geom_line() + geom_point(color='blue') +
    labs(title = target_country, subtitle = 'Population in millions from 1990 to 2018',
         y = 'Population in millions', x = 'Year') + theme_ipsum()
  ggsave(filename = str_c(target_country, '.png'), path = 'output_charts')  }

# purr approach

plots <- countries %>% 
  split(.$country) %>% 
  map(~ggplot(., aes(x = year, y = population)) +
        geom_line() + geom_point(color='blue') +
        labs(title = .$country, subtitle = 'Population in millions from 1990 to 2018',
             y = 'Population in millions', x = 'Year') +
        theme_ipsum()
  )

paths <- str_c(names(plots), ".png")
pwalk(list(paths, plots), ggsave, path = "save_charts/output_charts")