library(ggplot2)
library(dplyr)
library(tibble)

# Marimekko example
midwest %>% group_by(state, inmetro) %>% summarize(pop = sum(poptotal))

# Bar mekko example (HS grads and where it matters)
state.x77 %>% data.frame %>% 
  rownames_to_column("State") %>% select(State, Population, Illiteracy, Area)

plot(state.x77 %>% data.frame %>% extract2("Population"), state.x77 %>% 
       data.frame %>% extract2("Illiteracy"))

# TODO: Add something related to the electoral college (% of votes by state- show pop, area)
# TODO: Update the state info?