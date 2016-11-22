library(dplyr)
library(magrittr)

df <- state.x77 %>% data.frame %>% 
  rownames_to_column("State") %>% select(State, Population, Illiteracy)

library(ggplot2)
?ggproto

