library(ggplot2)
library(dplyr)
library(grid)

library(tibble)
df <- state.x77 %>% data.frame %>% 
  rownames_to_column("State") %>% select(State, Population, Illiteracy) %>%
  head(5) %>% 
  mutate(Illiteracy = ifelse(State == "Alabama", -Illiteracy, Illiteracy)) %>%
  mutate(Region = ifelse(State %in% c("Alabama", "Arkansas"), "South", "West"))




positions <- function(width) {
  0.5 * (cumsum(width) + cumsum(c(0, width[-length(width)])))
}

barmekko <- function(df, x, y, width) {
  # TODO: add smart sorting (width or y or data source order)
  xlabel <- substitute(x)
  ylabel <- substitute(y)
  x <- eval(substitute(x), df)
  y <- eval(substitute(y), df)
  width <- eval(substitute(width), df)
  pos <- positions(width)
  ggplot() +
    geom_bar(aes(x = pos, width = width, y = y, fill = x), stat = "identity") +
    scale_x_continuous(labels = x, breaks = pos) +
    xlab(xlabel) + ylab(ylabel) + guides(fill=guide_legend(title=xlabel))
}


bmx <- barmekko(df, x = State, y = Illiteracy, width = Population)
bmx
bmx + guides(fill=guide_legend(title=NULL))
bmx + labs(title = "New plot title!")

# does NOT work with ggplotly- width is the only thing missing, though it
# has the negative --> positive bug seen before in plotly for geom_bar
# (so probably couldn't use it even if that's fixed)
# ggplotly()
